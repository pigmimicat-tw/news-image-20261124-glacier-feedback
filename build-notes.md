# Builder 建置紀錄

完成日期：2026-11-25。角色順序遵循 Researcher → Dispatcher → Builder；本檔只是 Builder 自檢，獨立 Verifier 尚須自行測試與打包。

- 原創繪圖源：`build.m`，以幾何山谷、冰川、裸岩、反射／吸收光線與三節點回饋閉環繪製；無外部照片或 starter 圖。
- 建置工具：macOS AppKit / CoreGraphics、Apple clang 17.0.0（clang-1700.0.13.5），本機已有 Command Line Tools；無安裝或下載。
- 字型：本機 ArialMT / Arial-BoldMT，以字型繪製成像素；交付物未分發字型檔。
- 建置指令：`sh build.sh`。程式在暫存目錄編譯、結束清理；輸出 `entry.png`。
- 早期 Swift 繪圖嘗試遇到既有系統 toolchain 的 SwiftBridging module 重複定義，未修改系統，改採 Objective-C 的 `-fno-modules` 編譯路徑；已移除未採用的 Swift 源檔。
- 圖像：1024 × 1024、175,532 bytes；符合檔案尺寸／大小上限的 Builder 初步檢查。
- PNG SHA256：`4941d17e1283bbb19767c3c5e2f170a492bcfde84b65308873ca38a59ff7c8f2`。
- Runtime：Node v22.22.0 smoke 測試成功。`MAKEFUN_OUTPUT_DIR=.local-audit/builder-smoke node main.ts` 的輸出 SHA256 與原圖完全一致。
- 目視：已用 `view_image` 看完整圖，修正亮雪標籤在白色山峰上的低對比，主標、日期、光線方向、流程與底註無裁切；本圖為陸地冰川概念圖。
- 誠實範圍：2026-11-24 當日特定新聞仍為 UNVERIFIABLE；圖內為 SCIENCE EXPLAINER / EDITION DATE，並保留 Not a same-day research claim。它不是當日全球新聞全景。
- Runtime 僅複製固定 PNG，無網路與套件安裝；重新繪圖會依 macOS / 字型版本而異，不能把跨平台重新渲染宣稱為像素完全一致。
- 未付費、上傳、登入、送件、簽名、執行 record 或呼叫遠端 AI 評審。未建立最終交付包，留給獨立 Verifier。
