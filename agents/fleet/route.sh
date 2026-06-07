#!/usr/bin/env bash
# Route a task to the right agent.
# Usage: ./route.sh "task description" --agent [opencode|claude-code|aider|crush|codex|auto]
set -euo pipefail

TASK="${1:-}"
shift 2>/dev/null || true

# Parse args
AGENT="auto"
FILES=()

while [ $# -gt 0 ]; do
  case "$1" in
    --agent) AGENT="$2"; shift 2 ;;
    --files) shift; while [ $# -gt 0 ] && [[ "$1" != --* ]]; do FILES+=("$1"); shift; done ;;
    *) FILES+=("$1"); shift ;;
  esac
done

if [ -z "${TASK}" ]; then
  echo "Usage: $0 \"task description\" [--agent AGENT] [--files file1 file2 ...]"
  echo ""
  echo "Agents: opencode, claude-code, aider, crush, codex, auto"
  echo "  auto    — Auto-select based on task content"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Auto-select logic
if [ "${AGENT}" = "auto" ]; then
  TASK_LOWER="$(echo "${TASK}" | tr '[:upper:]' '[:lower:]')"
  if echo "${TASK_LOWER}" | grep -qE "review|audit|check|inspect"; then
    AGENT="claude-code"
  elif echo "${TASK_LOWER}" | grep -qE "refactor|rewrite|migrate|restructure"; then
    AGENT="opencode"
  elif echo "${TASK_LOWER}" | grep -qE "quick|fast|spike|grok|what.is|how.does"; then
    AGENT="crush"
  elif echo "${TASK_LOWER}" | grep -qE "implement|add|create|write"; then
    AGENT="aider"
  elif echo "${TASK_LOWER}" | grep -qE "codex|merge|resolve"; then
    AGENT="codex"
  fi
fi

echo "=== Routing: ${AGENT} ==="
echo "Task: ${TASK}"
[ ${#FILES[@]} -gt 0 ] && echo "Files: ${FILES[*]}"
echo ""

case "${AGENT}" in
  opencode)
    "${SCRIPT_DIR}/opencode/serve.sh" --prompt "${TASK}" --print-logs
    ;;
  claude-code)
    "${SCRIPT_DIR}/claude-code/invoke.sh" "${TASK}"
    ;;
  aider)
    if [ ${#FILES[@]} -gt 0 ]; then
      "${SCRIPT_DIR}/aider/invoke.sh" "${TASK}" --files "${FILES[@]}"
    else
      echo "Warning: Aider works best with specific files. Pass --files file.rs."
      "${SCRIPT_DIR}/aider/invoke.sh" "${TASK}"
    fi
    ;;
  crush)
    "${SCRIPT_DIR}/crush/invoke.sh" "${TASK}"
    ;;
  codex)
    "${SCRIPT_DIR}/codex/invoke.sh" exec "${TASK}"
    ;;
  *)
    echo "Unknown agent: ${AGENT}"
    echo "Valid: opencode, claude-code, aider, crush, codex, auto"
    exit 1
    ;;
esac
