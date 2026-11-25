#!/bin/sh
# Local macOS build: no installs, downloads, or runtime service calls.
set -eu
artwork_root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
artwork_temp=$(mktemp -d "${TMPDIR:-/tmp}/makefun-artwork.XXXXXX")
trap 'rm -rf "$artwork_temp"' EXIT HUP INT TERM
clang -fobjc-arc -fno-modules -framework AppKit -framework CoreGraphics \
  "$artwork_root/build.m" -o "$artwork_temp/render-artwork"
"$artwork_temp/render-artwork" "$artwork_root/entry.png"
