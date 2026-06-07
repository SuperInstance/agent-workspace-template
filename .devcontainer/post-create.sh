#!/usr/bin/env bash
set -euo pipefail

echo "=== Agent Workspace Post-Create ==="

# ── OpenCode ──────────────────────────────────────────
if ! command -v opencode &>/dev/null; then
  echo "Installing OpenCode..."
  npm install -g opencode
fi

# ── Claude Code ───────────────────────────────────────
if ! command -v claude &>/dev/null; then
  echo "Installing Claude Code..."
  npm install -g @anthropic-ai/claude-code
fi

# ── Crush ─────────────────────────────────────────────
# Crush is a Rust binary; install via cargo
if ! command -v crush &>/dev/null; then
  echo "Installing Crush..."
  cargo install crush --git https://github.com/theseyan/crush 2>/dev/null || \
    echo "NOTE: Crush install skipped (not in cargo registry). Install manually if needed."
fi

# ── Codex CLI ─────────────────────────────────────────
# Codex is a Node package
if ! command -v codex &>/dev/null; then
  echo "Installing Codex CLI..."
  npm install -g @openai/codex
fi

# ── Aider ─────────────────────────────────────────────
if ! command -v aider &>/dev/null; then
  echo "Installing Aider..."
  pip3 install aider-chat
fi

# ── Git config ────────────────────────────────────────
git config --global init.defaultBranch main
git config --global user.name "OpenClaw Agent"
git config --global user.email "agent@openclaw.ai"

# ── Claude Code project context ───────────────────────
mkdir -p .claude

# ── Confirm versions ──────────────────────────────────
echo ""
echo "=== Agent Versions ==="
opencode --version 2>/dev/null && echo "OpenCode: OK" || echo "OpenCode: MISSING"
claude --version 2>/dev/null && echo "Claude Code: OK" || echo "Claude Code: MISSING"
aider --version 2>/dev/null && echo "Aider: OK" || echo "Aider: MISSING"
(codex --help >/dev/null 2>&1 && echo "Codex CLI: OK") || echo "Codex CLI: MISSING"
(crush --help >/dev/null 2>&1 && echo "Crush: OK") || echo "Crush: MISSING"

echo ""
echo "=== Agent Workspace Ready ==="
echo "Run ./agents/fleet/start-all.sh to launch persistent servers."
echo ""

# ── Agent Boot ────────────────────────────────────────
echo "Running agent boot protocol..."
if [ -f "agent/boot.sh" ]; then
  bash agent/boot.sh
  echo "Agent boot complete."
else
  echo "No boot.sh found. Skipping."
fi
