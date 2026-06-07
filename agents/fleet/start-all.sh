#!/usr/bin/env bash
# Start all persistent agent servers.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOGDIR="${HOME}/.agent-logs"
mkdir -p "${LOGDIR}"

echo "=== Starting Agent Fleet ==="

# ── OpenCode serve (primary) ─────────────────────
echo "Starting OpenCode server..."
nohup "${SCRIPT_DIR}/opencode/serve.sh" > "${LOGDIR}/opencode.log" 2>&1 &
OPENCODE_PID=$!
echo "  OpenCode PID: ${OPENCODE_PID} (port ${OPENCODE_PORT:-4096})"

# ── Codex daemon (experimental) ──────────────────
echo "Starting Codex daemon..."
nohup "${SCRIPT_DIR}/codex/daemon.sh" > "${LOGDIR}/codex.log" 2>&1 &
CODEX_PID=$!
echo "  Codex PID: ${CODEX_PID} (port ${CODEX_PORT:-4097})"

# Save PIDs for stop-all
echo "${OPENCODE_PID}" > "${LOGDIR}/opencode.pid"
echo "${CODEX_PID}" > "${LOGDIR}/codex.pid"

echo ""
echo "All servers started. Check status with: ./agents/fleet/status.sh"
echo "View logs: ls -la ${LOGDIR}/"
