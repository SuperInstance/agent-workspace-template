#!/usr/bin/env bash
# Invoke Codex CLI non-interactively.
# Usage: ./invoke.sh "your task description"
#   Or: ./invoke.sh review [files...]
set -euo pipefail

MODE="${1:-exec}"
shift 2>/dev/null || true

case "${MODE}" in
  exec|e)
    codex exec "$@"
    ;;
  review)
    codex review "$@"
    ;;
  *)
    echo "Usage: $0 [exec|review] [args...]"
    echo "  exec    — Run Codex non-interactively (default)"
    echo "  review  — Run a code review"
    exit 1
    ;;
esac
