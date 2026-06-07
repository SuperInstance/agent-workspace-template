#!/usr/bin/env bash
# Start Codex CLI in app-server daemon mode with remote control enabled.
# This is experimental — use OpenCode serve as the primary remote agent.
set -euo pipefail

DAEMON_PORT="${CODEX_PORT:-4097}"

echo "Starting Codex app-server daemon with remote control..."
echo "  Port: ${DAEMON_PORT}"
echo "  NOTE: This is experimental. OpenCode serve is the stable remote channel."

# Start the daemon
codex app-server daemon start 2>&1 || {
  echo "Daemon start failed, trying remote-control..."
  codex remote-control start 2>&1 || {
    echo "Warning: Codex daemon/remote-control not available."
    echo "Use 'codex exec \"task\"' for non-interactive CLI usage instead."
    exit 1
  }
}

echo "Codex daemon running."
