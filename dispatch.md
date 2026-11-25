# Dispatcher 建置分派

交接順序：Researcher 完成 `research.md` → 本 Dispatcher 分派 → Builder 建置 → 未參與建置的獨立 Verifier 測試與打包。由主代理依序啟動角色，本角色不啟動其他代理。

## 編輯決策

製作使用者指定的冰川反照率正回饋科學背景圖。Researcher 已核實機制，未能核實 2026-11-24 同日特定新聞，該項保持 **UNVERIFIABLE**。日期只作版面日期。不能寫「今日新研究」、不能暗示已涵蓋當日全球新聞。這個範圍差異必須在 README 與驗收報告明示。

## Builder：畫面規格

- 成品：一張 1024 × 1024 PNG；建議預留 48px 四邊安全距離。視覺為自繪編輯插畫，非照片。
- 風格：深海軍藍／暖白的科學雜誌版面，冰雪用亮白與青藍，裸岩用低明度灰褐，吸收的能量與閉環箭頭用琥珀橘。主體應佔約半張圖，文字維持清晰，不做滿版小字新聞表格。
- 上眉：`CLIMATE / SCIENCE EXPLAINER`。右上日期：`24 NOV 2026`，相鄰明示 `EDITION DATE`。
- 主標：優先英文 `LESS ICE.` / `MORE HEAT.` 兩行大字（主標 64–82px）。若採用本機中文字型，可加 28–32px 中文「冰愈少，吸熱愈多」，但不能壓縮主圖或底註可讀性。國際可讀性優先，英文版已可交付。
- 副標：`How glacier retreat can reinforce warming`，約 24–28px。
- 中央插畫：陸地山谷冰川從高山流向前景，亮雪／亮冰與退縮後露出的暗岩共存。利用兩組定性光線呈現「亮面反射更多陽光」與「暗面吸收更多陽光」，箭頭方向必須正確。不是兩個日期的實測前後比較；不需要海面、浮冰或海平面支線。
- 低於副標或圖角保留 `CONCEPTUAL ILLUSTRATION`。
- 下方以三個清楚節點配連續箭頭形成循環：`1 WARMING` / `More snow and ice melt` → `2 DARKER SURFACES` / `Less sunlight reflected` → `3 MORE HEAT ABSORBED` / `More energy available for melting`。回到第一點的箭頭標 `REINFORCING FEEDBACK`。可調整為圖旁三節點環繞主體，但不能只畫單向終止流程。
- 底註至少 16px 且高對比：`One feedback pathway · Not a same-day research claim`；來源行：`Sources: NASA GISS · NASA NTRS 20230017287 · NSIDC`。
- 主標、節點、日期與底註不得裁切／重疊；縮至 512px 仍應能讀懂主標與循環。避免裝飾箭頭與因果箭頭混淆。

## Builder：檔案與實作範圍

從零撰寫程式與原創插畫；不得複製官方 kit 的 starter 圖、入口程式或現成參賽內容。

1. `build.py`（或等效本機建置程式）與可編輯 `artwork.svg`：用程式／SVG 原生幾何畫圖，使用已安裝的本機渲染工具輸出 `entry.png`。允許只用一個能重建圖像的本機繪圖源檔；若不用 SVG，須在 README 說明重建方法。不得使用付費服務、遠端生圖、外部照片或下載字型。建置工具與字型依賴須如實記錄。
2. 根目錄 `entry.png`：完整 PNG、最大 1,048,576 bytes，無未經核實的百分比／日期新發現宣稱。建置後視覺檢查再交接。
3. 根目錄 `main.ts`：Node 22、標準庫；執行只從自身檔案目錄讀取隨附 `entry.png`，以 `MAKEFUN_OUTPUT_DIR` 或預設 `/output` 為目標，建立目錄並寫 `entry.png`。不得依賴 cwd、網路、套件安裝、目前時間或亂數；相同來源輸出同 bytes。不要在 runtime 重新渲染。
4. `README.md`：繁體中文使用說明、預覽、本機 `MAKEFUN_OUTPUT_DIR=out node main.ts`，從零建置方法、來源連結、日期 UNVERIFIABLE 與單一背景圖範圍、Node 22 runtime 無依賴、未上傳未送件、授權。不要加任何會自動呼叫遠端的預覽或 badge。
5. `LICENSE`：MIT，使用中性著作權署名，不複製 kit starter 文件。
6. 可附 `build-notes.md`，記錄字型、渲染器、輸出 SHA256 與視覺檢查。`research.md`、本 `dispatch.md` 與查證材料保留。

Builder 僅建置與自檢，不可代獨立 Verifier 宣布完成，也不可上傳、送件、簽名、登入、執行 `record` 或新增付費資源。交接時列出具體檔案與已知限制。

## 獨立 Verifier：必要驗收與打包

Verifier 必須獨立閱讀來源碼、`research.md`、本規格及官方本機 kit。只做本機驗證；禁止會呼叫官方評審模型、上傳或簽名的命令。若 `check`／`grade-local` 有任何遠端需求，先讀程式判定，不可為測試而付費或送件。

- 實際執行 Node 22 入口兩次到不同新目錄，至少一次從其他 cwd 執行；記錄 exit code、耗時、兩份輸出 SHA256，確認與隨附 `entry.png` 一致。
- 檢查預設 `/output` 路徑寫法、唯讀來源相容性及標準庫依賴；以靜態審查確認無網路／不確定性，清楚區分靜態與動態證據。
- 用獨立 PNG 解碼器完整解碼並檢查 1024 × 1024、大小上限、PNG 完整性。可檢查 chunk CRC，不能只信檔名或 IHDR。
- 必須開圖目視：標題／底註可讀、沒有裁切重疊、陸地冰川清楚、反射與吸收光線正確、因果循環閉合、沒有不當當日新聞宣稱。必要修正交回 Builder，修正後重跑受影響檢查。
- 最後由主代理／Verifier 在所有角色完成後跑官方 `bundle --dry-run`，確認本次父子 session 都收集到、缺漏如實列出。正式本機 transcript bundle 也應由主代理在 Verifier 完成後封裝，以涵蓋 Verifier 最後訊息；不得修改原生紀錄或虛構用量。`--no-superbot-attest` 避免遠端請求。若有 MCP／系統指示缺漏，保持缺漏，不能造出不存在的配置。
- 寫 `verification.md`，逐項 PASS／FAIL／UNVERIFIABLE，區分圖像技術檢查通過與官方新聞評審未執行。無送件或官方評分的行為不得寫成競賽合格。
- 建立本機交付 zip（建議 `dist/news-image-20261124-local.zip`），僅包含原創圖、程式、建置源、README、LICENSE、research／dispatch／verification；排除 `.git`、官方 kit、憑證、本機設定與原始個人 session。另列 SHA256 清單與包內容，解壓後再跑入口確認可用。
- 此 zip 是供本機檢視的交付包，**不是**已簽名競賽 source bundle；官方 transcript bundle 分開存放，並標示可能包含私人指示。不得混入分發 zip。

