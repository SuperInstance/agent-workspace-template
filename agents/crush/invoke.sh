#!/usr/bin/env bash
# Invoke Crush non-interactively.
# Usage: ./invoke.sh "your prompt here"
set -euo pipefail

PROMPT="${1:-}"

if [ -z "${PROMPT}" ]; then
  echo "Usage: $0 \"prompt\""
  exit 1
fi

crush run "${PROMPT}"
