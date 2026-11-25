# 獨立 Verifier 驗收

日期：2026-11-25。Verifier 未參與 Researcher、Dispatcher 或 Builder 的產出，獨立閱讀來源並開啟原圖與 512px 縮圖。本報告是本機技術驗收，不是 make.fun 官方評分或送件合格證明。

| 項目 | 結果 | 證據／限制 |
| --- | --- | --- |
| PNG 尺寸與大小 | PASS | 1024 × 1024；175,532 bytes，低於 1,048,576 bytes。 |
| PNG 完整性 | PASS | 檢查 PNG signature、所有 chunk 邊界與 CRC、IEND 與無尾隨資料；完整解壓 IDAT 並反解全部掃描列及濾鏡。 |
| 獨立平台解碼 | PASS | macOS `sips` 完整解碼並轉存 TIFF，exit 0，產生 4,197,968 bytes TIFF。 |
| Node 22 離線入口 | PASS | 實際使用 Node v22.22.0。僅引用 `node:fs`、`node:path`、`node:url`，複製隨附 PNG，無套件安裝、網路、時間或亂數。無網路為完整短入口的靜態審查，不是容器網路隔離量測。 |
| 兩跑一致性 | PASS | 兩個新輸出目錄，exit 0；初次約 0.074 秒、第二次約 0.072 秒；兩次與原圖 SHA256 相同。 |
| 其他 cwd／唯讀來源 | PASS | 第二次從不同 cwd 執行絕對路徑入口，來源副本目錄 0555、檔案 0444；成功寫至獨立可寫輸出目錄。未建立完整唯讀容器。 |
| 預設輸出路徑 | PASS（靜態） | 入口明確以 `MAKEFUN_OUTPUT_DIR` 或 `/output` 為目標；動態測試使用獨立暫存輸出，不更動主機 `/output`。 |
| 畫面及因果 | PASS（目視） | 原圖與 512px 縮圖均已查看：主標、節點、日期與底註無裁切；山谷陸地冰川清楚；入射光指向表面、冷色反射光離開冰面；1→2→3 的回返箭頭指回1。回返線以標題區斷開視覺呈現，語意閉環清楚。 |
| 科學與新聞範圍 | PASS（表述）／UNVERIFIABLE（當日新聞） | 機制依 Researcher 的 NASA／NSIDC 背景來源。圖內明示 `SCIENCE EXPLAINER`、`EDITION DATE`、`CONCEPTUAL ILLUSTRATION`、`Not a same-day research claim`。未核實 2026-11-24 特定新研究，未涵蓋當日全球新聞。 |
| 本機交付包 | PASS | 已建立 `dist/news-image-20261124-local.zip`，12 個 allowlist 檔案；zip CRC、逐檔解壓 bytes 比對皆通過，解壓入口再跑 exit 0 且 PNG 雜湊與原圖一致。排除 `.git`、官方 kit、原始 session、個人設定與憑證。包雜湊另見 `dist/SHA256SUMS.txt`。 |
| 官方新聞評審／排名 | UNVERIFIABLE／未執行 | 本競賽無本機評分；未送件、未呼叫遠端評審。 |
| 最終 transcript bundle | pending-root-finalization | 由 root 在本 Verifier 完成後重新執行官方 bundle，涵蓋最後父子紀錄。本報告不預先宣稱完整。 |

原圖與兩次執行輸出 SHA256：

```text
4941d17e1283bbb19767c3c5e2f170a492bcfde84b65308873ca38a59ff7c8f2
```

完整反解像素 SHA256（RGBA 掃描列，無濾鏡 byte）：

```text
94c66b18a9605f7105344d6ffa27265eaf7549c79a96e0b3db77cb45d350af3c
```

可重跑技術驗證：`python3 verify.py`。此腳本不修改圖像，使用 Python 標準庫及 macOS 已有 `sips`，暫存資料會清除。`python3 verify.py --package` 另以固定 allowlist 建立 zip、測試 zip CRC、解壓比對每個檔案並執行解壓入口，產出 `dist/SHA256SUMS.txt` 與 `dist/CONTENTS.txt`。它不連網，也不執行官方 kit。

## 官方 check 的本機限制

已靜態閱讀官方 kit 的 `runCheck3`／`check3`：CLI 預設可讀取網站 kit level／account；`MAKEFUN_OFFLINE=1` 會省略這兩個 fetch 支線。本案沒有 play-code、外部 entry-link 或 source anchor。建議 root 於最終 commit／bundle 後以 `MAKEFUN_OFFLINE=1 node <kit>/cli/makefun.mjs check --kit <kit> --repo <repo> --transcripts <bundle> --json` 執行本機診斷。這個步驟留給 root，結果另存 `.local-audit`，不得冒稱評分。

本 Verifier 未付費、上傳、送件、簽名、登入、執行 `record`、修改成品或呼叫遠端 AI 評審。圖像重建需要 macOS／clang／本機字型；其他平台僅需 Node 22 使用固定圖像。跨平台重新繪製的像素一致性未驗證。
