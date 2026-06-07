#!/usr/bin/env bash
# Stop all persistent agent servers.
set -euo pipefail

LOGDIR="${HOME}/.agent-logs"

echo "=== Stopping Agent Fleet ==="

for pidfile in "${LOGDIR}"/*.pid; do
  [ -f "${pidfile}" ] || continue
  AGENT_NAME="$(basename "${pidfile}" .pid)"
  PID="$(cat "${pidfile}")"
  if kill "${PID}" 2>/dev/null; then
    echo "  Stopped ${AGENT_NAME} (PID ${PID})"
  else
    echo "  ${AGENT_NAME} (PID ${PID}) not running"
  fi
  rm -f "${pidfile}"
done

echo "All servers stopped."
