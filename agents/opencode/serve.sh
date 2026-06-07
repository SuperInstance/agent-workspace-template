#!/usr/bin/env bash
# Start OpenCode in headless server mode.
# Local agents connect with: opencode attach http://<codespace-host>:4096
set -euo pipefail

PORT="${OPENCODE_PORT:-4096}"
HOSTNAME="${OPENCODE_HOST:-0.0.0.0}"
CWD="${OPENCODE_CWD:-/workspaces/$(basename $(dirname $(dirname $(pwd))))}"
AUTH="${OPENCODE_PASSWORD:-}"

echo "Starting OpenCode server on ${HOSTNAME}:${PORT}..."
echo "  Working directory: ${CWD}"
echo "  Connect from local agents: opencode attach http://<codespace-url>:${PORT}"

# Use --mdns for local network discovery, --cors for web clients
opencode serve \
  --port "${PORT}" \
  --hostname "${HOSTNAME}" \
  --cwd "${CWD}" \
  --print-logs \
  ${AUTH:+--password "${AUTH}"} \
  "$@"
