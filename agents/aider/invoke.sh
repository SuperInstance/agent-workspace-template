#!/usr/bin/env bash
# Invoke Aider non-interactively.
# Usage: ./invoke.sh "your prompt here" [--files file1 file2 ...]
set -euo pipefail

PROMPT="${1:-}"
shift 2>/dev/null || true
FILES=("$@")
MODEL="${AIDER_MODEL:-sonnet}"

if [ -z "${PROMPT}" ]; then
  echo "Usage: $0 \"prompt\" [--files file1 file2 ...]"
  exit 1
fi

# Aider non-interactive mode: --message + --yes auto-accepts
aider \
  --model "${MODEL}" \
  --message "${PROMPT}" \
  --yes \
  --no-suggestions \
  --no-auto-commits \
  "${FILES[@]}"
