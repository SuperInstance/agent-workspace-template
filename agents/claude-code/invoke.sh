#!/usr/bin/env bash
# Invoke Claude Code non-interactively.
# Usage: ./invoke.sh "your prompt here"
set -euo pipefail

PROMPT="${1:-}"
CWD="${2:-$(pwd)}"
MODEL="${CLAUDE_MODEL:-claude-sonnet-4-20250514}"

if [ -z "${PROMPT}" ]; then
  echo "Usage: $0 \"prompt\" [working-directory]"
  exit 1
fi

cd "${CWD}"

# Run Claude Code in non-interactive print mode
claude \
  --print \
  --model "${MODEL}" \
  --allowedTools "Bash,Edit,Read,Write,Glob,Grep,WebFetch,WebSearch" \
  -p "${PROMPT}"
