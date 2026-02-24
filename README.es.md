# ForceScan (Explorador de Bloques 0xForce)

ForceScan es el fork personalizado de 0xForce basado en onion-monero-blockchain-explorer.

Personalizaciones clave en este workspace:

- Los valores predeterminados de CMake apuntan al `xfo-core` local (`/workspace/xfo-core`)
- Objetivo RPC para depuración local: `ai_devnode:18081` (JSON-RPC)
- El contexto de bloque expone `pow_type` e insignias UI (`CPU · RandomX` / `GPU · Oracle`)
- La visualización de recompensa de bloque incluye impuesto de gobernanza (20%) y recompensa del minero
- El tema Terminal Glass se aplica via `src/templates/css/terminal.css`
- Script de lanzamiento auxiliar: `scripts/run_forcescan.sh`

Inicio rápido (desde la raíz del proyecto):

```bash
scripts/run_forcescan.sh
```

Variables de entorno:

- `FORCESCAN_DAEMON_URL` (por defecto: `ai_devnode:18081`)
- `FORCESCAN_BC_PATH` (por defecto: `/home/monero/.bitmonero/lmdb`)
- `FORCESCAN_PORT` (por defecto: `8081`)

---

Para la documentación completa del upstream Onion Monero Blockchain Explorer, consulte el [README.md](README.md) en inglés.
