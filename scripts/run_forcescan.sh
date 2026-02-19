#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="${ROOT_DIR}/build"
XFO_CORE_DIR="${FORCESCAN_CORE_DIR:-/workspace/xfo-core}"
XFO_CORE_RELEASE_DIR="${XFO_CORE_DIR}/build/release"
XFO_CORE_MAIN_RELEASE_DIR="${XFO_CORE_DIR}/build/Linux/main/release"

DAEMON_URL="${FORCESCAN_DAEMON_URL:-ai_devnode:18081}"
BC_PATH="${FORCESCAN_BC_PATH:-/home/monero/.bitmonero/lmdb}"
PORT="${FORCESCAN_PORT:-8081}"

if [ ! -d "${XFO_CORE_RELEASE_DIR}" ] && [ ! -d "${XFO_CORE_MAIN_RELEASE_DIR}" ]; then
  echo "[forcescan] xfo-core release build not found, building ${XFO_CORE_DIR}"
  make -C "${XFO_CORE_DIR}" release -j"$(nproc)"
fi

if [ ! -d "${BUILD_DIR}" ]; then
  echo "[forcescan] build dir not found, creating ${BUILD_DIR}"
  cmake -S "${ROOT_DIR}" -B "${BUILD_DIR}" \
    -DMONERO_DIR="${XFO_CORE_DIR}" \
    -DMONERO_BUILD_DIR="${XFO_CORE_MAIN_RELEASE_DIR}"
fi

if [ ! -f "${BUILD_DIR}/Makefile" ]; then
  echo "[forcescan] build files missing, re-running cmake configure"
  cmake -S "${ROOT_DIR}" -B "${BUILD_DIR}" \
    -DMONERO_DIR="${XFO_CORE_DIR}" \
    -DMONERO_BUILD_DIR="${XFO_CORE_MAIN_RELEASE_DIR}"
fi

if [ ! -x "${BUILD_DIR}/xmrblocks" ]; then
  echo "[forcescan] building explorer binary"
  cmake --build "${BUILD_DIR}" -j
fi

echo "[forcescan] starting with daemon ${DAEMON_URL}"
exec "${BUILD_DIR}/xmrblocks" \
  --port "${PORT}" \
  --bc-path "${BC_PATH}" \
  --daemon-url "${DAEMON_URL}" \
  --enable-json-api \
  --enable-autorefresh-option \
  --enable-emission-monitor \
  --enable-pusher
