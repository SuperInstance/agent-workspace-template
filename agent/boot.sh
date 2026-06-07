#!/usr/bin/env bash
# Agent Boot Protocol
# Runs on every Codespace start to load agent memory and re-establish context.
set -euo pipefail

echo "=== Agent Boot ==="

MEMORY_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/memory" && pwd)"
INCARNATION_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../incarnation" && pwd)"
SESSION_DATE="$(date +%Y-%m-%d)"
SESSION_TIME="$(date +%H:%M:%S)"

# ── 1. Load Session Log ──────────────────────────
echo "[boot] Loading session log..."
if [ -f "${MEMORY_DIR}/SESSION-LOG.md" ]; then
  SESSION_COUNT="$(grep -c "^## " "${MEMORY_DIR}/SESSION-LOG.md" || true)"
  echo "[boot]   Previous sessions: ${SESSION_COUNT}"
else
  echo "[boot]   No session log found — this is the first boot."
fi

# ── 2. Load Decisions ────────────────────────────
echo "[boot] Loading design decisions..."
if [ -f "${MEMORY_DIR}/DECISIONS.md" ]; then
  DECISION_COUNT="$(grep -c "^## " "${MEMORY_DIR}/DECISIONS.md" || true)"
  echo "[boot]   Design decisions recorded: ${DECISION_COUNT}"
fi

# ── 3. Load Gotchas ──────────────────────────────
echo "[boot] Loading gotchas..."
if [ -f "${MEMORY_DIR}/GOTCHAS.md" ]; then
  GOTCHA_COUNT="$(grep -c "\|" "${MEMORY_DIR}/GOTCHAS.md" || true)"
  echo "[boot]   Gotchas recorded: ${GOTCHA_COUNT}"
fi

# ── 4. Load Repo Narrative ──────────────────────
echo "[boot] Loading repo narrative..."
if [ -f "${INCARNATION_DIR}/lore/REPO-NARRATIVE.md" ]; then
  echo "[boot]   Narrative exists."
fi

# ── 5. Check for active agent servers ──────────
echo "[boot] Checking agent servers..."
if [ -f "${HOME}/.agent-logs/opencode.pid" ]; then
  OPID="$(cat "${HOME}/.agent-logs/opencode.pid")"
  if kill -0 "${OPID}" 2>/dev/null; then
    echo "[boot]   OpenCode server: RUNNING (PID ${OPID})"
  else
    echo "[boot]   OpenCode server: NOT RUNNING"
  fi
else
  echo "[boot]   OpenCode server: NOT STARTED"
fi

# ── 6. Write boot entry to session log ──────────
{
  echo ""
  echo "## ${SESSION_DATE} — Boot"
  echo ""
  echo "- **Time:** ${SESSION_TIME} UTC"
  echo "- **Event:** Codespace started"
  echo "- **Memory:** ${SESSION_COUNT:-0} previous sessions loaded"
  echo "- **Decisions:** ${DECISION_COUNT:-0} design decisions loaded"
  echo "- **Gotchas:** ${GOTCHA_COUNT:-0} gotchas loaded"
  echo ""
} >> "${MEMORY_DIR}/SESSION-LOG.md"

echo "[boot] Agent boot complete."
echo ""
echo "The agent is ready. Memory loaded. Context established."
echo "Connect: opencode attach http://<codespace-url>:4096"
