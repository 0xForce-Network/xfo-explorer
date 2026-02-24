# ForceScan（0xForce 區塊瀏覽器）

ForceScan 是基於 onion-monero-blockchain-explorer 的 0xForce 客製化分支。

本工作區的主要客製化：

- CMake 預設指向本地 `xfo-core`（`/workspace/xfo-core`）
- 本地除錯的 RPC 目標：`ai_devnode:18081`（JSON-RPC）
- 區塊上下文顯示 `pow_type` 及 UI 標籤（`CPU · RandomX` / `GPU · Oracle`）
- 區塊獎勵拆分顯示包含治理稅（20%）和礦工獎勵
- Terminal Glass 主題透過 `src/templates/css/terminal.css` 套用
- 輔助啟動腳本：`scripts/run_forcescan.sh`

快速開始（從專案根目錄）：

```bash
scripts/run_forcescan.sh
```

環境變數覆寫：

- `FORCESCAN_DAEMON_URL`（預設：`ai_devnode:18081`）
- `FORCESCAN_BC_PATH`（預設：`/home/monero/.bitmonero/lmdb`）
- `FORCESCAN_PORT`（預設：`8081`）

---

完整的上游 Onion Monero Blockchain Explorer 文件請參閱英文版 [README.md](README.md)。
