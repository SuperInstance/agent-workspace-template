#!/usr/bin/env bash
# Check status of all agent servers.
set -euo pipefail

LOGDIR="${HOME}/.agent-logs"

echo "=== Agent Fleet Status ==="

echo ""
echo "Persistent Servers:"

# OpenCode
OPENCODE_PID=""
[ -f "${LOGDIR}/opencode.pid" ] && OPENCODE_PID="$(cat "${LOGDIR}/opencode.pid")"
if [ -n "${OPENCODE_PID}" ] && kill -0 "${OPENCODE_PID}" 2>/dev/null; then
  echo "  ✅ OpenCode serve (PID ${OPENCODE_PID}) — port ${OPENCODE_PORT:-4096}"
else
  echo "  ❌ OpenCode serve — not running"
fi

# Codex
CODEX_PID=""
[ -f "${LOGDIR}/codex.pid" ] && CODEX_PID="$(cat "${LOGDIR}/codex.pid")"
if [ -n "${CODEX_PID}" ] && kill -0 "${CODEX_PID}" 2>/dev/null; then
  echo "  ✅ Codex daemon (PID ${CODEX_PID}) — port ${CODEX_PORT:-4097}"
else
  echo "  ❌ Codex daemon — not running"
fi

echo ""
echo "CLI Agents (on-demand):"

for agent in claude aider crush; do
  if command -v "${agent}" &>/dev/null; then
    echo "  ✅ ${agent}"
  else
    echo "  ❌ ${agent} — not installed"
  fi
done

echo ""
echo "Connect from local agents:"
echo "  opencode attach http://<codespace-host>:${OPENCODE_PORT:-4096}"
