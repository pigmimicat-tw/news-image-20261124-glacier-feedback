"""Independent local verification; standard library plus macOS sips for decoding.

Run: python3 verify.py [--package]
Does not render or modify the artwork, contact any service, or invoke the kit.
"""
import hashlib
import json
import os
from pathlib import Path
import shutil
import struct
import subprocess
import sys
import tempfile
import time
import zipfile
import zlib

ROOT = Path(__file__).resolve().parent
FILES = ["entry.png", "main.ts", "build.m", "build.sh", "README.md", "LICENSE",
         "research.md", "dispatch.md", "build-notes.md", "verification.md", "verify.py"]


def digest(data):
    return hashlib.sha256(data).hexdigest()


def png_check(path):
    data = path.read_bytes()
    assert data[:8] == b"\x89PNG\r\n\x1a\n"
    assert len(data) <= 1048576
    pos, chunks, compressed = 8, [], bytearray()
    while pos < len(data):
        size = struct.unpack(">I", data[pos:pos+4])[0]
        kind = data[pos+4:pos+8]
        end = pos + 12 + size
        assert end <= len(data), "truncated chunk"
        payload = data[pos+8:pos+8+size]
        crc = struct.unpack(">I", data[pos+8+size:end])[0]
        assert zlib.crc32(kind + payload) & 0xffffffff == crc, "CRC mismatch"
        chunks.append(kind.decode("ascii"))
        if kind == b"IHDR":
            w, h, depth, color, compression, filtering, interlace = struct.unpack(">IIBBBBB", payload)
            assert (w, h) == (1024, 1024)
            assert depth == 8 and color in (2, 6) and interlace == 0
            assert compression == filtering == 0
        if kind == b"IDAT":
            compressed.extend(payload)
        pos = end
        if kind == b"IEND":
            assert not payload and pos == len(data), "trailing data"
            break
    assert chunks[0] == "IHDR" and chunks[-1] == "IEND"
    decoder = zlib.decompressobj()
    raw = decoder.decompress(compressed) + decoder.flush()
    assert decoder.eof and not decoder.unused_data and not decoder.unconsumed_tail
    bpp = 4 if color == 6 else 3
    stride = w * bpp
    assert len(raw) == h * (stride + 1)
    # Actually reconstruct every scanline; this is separate from the AppKit encoder.
    previous = bytearray(stride)
    pixels = bytearray()
    for y in range(h):
        row = raw[y*(stride+1):(y+1)*(stride+1)]
        mode, scan = row[0], bytearray(row[1:])
        assert mode <= 4
        for x in range(stride):
            left = scan[x-bpp] if x >= bpp else 0
            up = previous[x]
            upper_left = previous[x-bpp] if x >= bpp else 0
            if mode == 1:
                predictor = left
            elif mode == 2:
                predictor = up
            elif mode == 3:
                predictor = (left + up) // 2
            elif mode == 4:
                p = left + up - upper_left
                d = [abs(p-left), abs(p-up), abs(p-upper_left)]
                predictor = (left, up, upper_left)[d.index(min(d))]
            else:
                predictor = 0
            scan[x] = (scan[x] + predictor) & 255
        pixels.extend(scan)
        previous = scan
    return {"width": w, "height": h, "bytes": len(data), "sha256": digest(data),
            "chunks": chunks, "crc": "PASS", "full_scanline_decode": "PASS",
            "decoded_pixel_sha256": digest(pixels)}


def run_entry(source, cwd, output):
    env = os.environ.copy()
    env["MAKEFUN_OUTPUT_DIR"] = str(output)
    started = time.perf_counter()
    proc = subprocess.run(["node", str(source / "main.ts")], cwd=cwd, env=env,
                          capture_output=True, text=True, timeout=15)
    seconds = time.perf_counter() - started
    assert proc.returncode == 0, proc.stderr
    data = (output / "entry.png").read_bytes()
    assert data == (ROOT / "entry.png").read_bytes()
    return {"exit_code": proc.returncode, "seconds": round(seconds, 6),
            "sha256": digest(data), "same_as_original": True}


def main():
    version = subprocess.check_output(["node", "--version"], text=True).strip()
    assert version.startswith("v22.")
    results = {"node": version, "png": png_check(ROOT / "entry.png")}
    with tempfile.TemporaryDirectory(prefix="makefun-verifier-") as temp:
        temp = Path(temp)
        results["run_1"] = run_entry(ROOT, ROOT, temp / "run-1")
        readonly = temp / "readonly-source"
        readonly.mkdir()
        for name in ("main.ts", "entry.png"):
            shutil.copyfile(ROOT / name, readonly / name)
            (readonly / name).chmod(0o444)
        readonly.chmod(0o555)
        try:
            results["run_2_other_cwd_readonly_source"] = run_entry(readonly, temp, temp / "run-2")
        finally:
            readonly.chmod(0o755)
        # An additional independent platform image codec fully decodes to TIFF.
        proc = subprocess.run(["sips", "-s", "format", "tiff", str(ROOT / "entry.png"),
                               "--out", str(temp / "decoded.tiff")], capture_output=True, timeout=15)
        assert proc.returncode == 0 and (temp / "decoded.tiff").stat().st_size > 0
        results["sips_full_decode_to_tiff"] = {"exit_code": 0, "bytes": (temp / "decoded.tiff").stat().st_size}
        if "--package" in sys.argv:
            dist = ROOT / "dist"
            dist.mkdir(exist_ok=True)
            archive = dist / "news-image-20261124-local.zip"
            sums = "".join(f"{digest((ROOT / n).read_bytes())}  {n}\n" for n in FILES)
            with zipfile.ZipFile(archive, "w", zipfile.ZIP_DEFLATED, compresslevel=9) as z:
                for n in FILES:
                    z.write(ROOT / n, n)
                z.writestr("SHA256SUMS.txt", sums)
            with zipfile.ZipFile(archive) as z:
                assert z.testzip() is None
                assert set(z.namelist()) == set(FILES + ["SHA256SUMS.txt"])
                extracted = temp / "extracted"
                z.extractall(extracted)
            for n in FILES:
                assert (extracted / n).read_bytes() == (ROOT / n).read_bytes()
            results["unpacked_run"] = run_entry(extracted, temp, temp / "unpacked-output")
            results["package"] = {"file": archive.name, "bytes": archive.stat().st_size,
                                  "sha256": digest(archive.read_bytes()), "files": FILES + ["SHA256SUMS.txt"]}
            (dist / "SHA256SUMS.txt").write_text(f"{digest(archive.read_bytes())}  {archive.name}\n" + sums)
            (dist / "CONTENTS.txt").write_text("\n".join(FILES + ["SHA256SUMS.txt"]) + "\n")
    print(json.dumps(results, indent=2))


if __name__ == "__main__":
    main()
