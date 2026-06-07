# Project Context for Claude Code

This is an **Agent Workspace** — a GitHub Codespace configured with multiple AI coding agents.

## Repository Structure

- `agents/` — Scripts for each coding agent (opencode, claude-code, aider, crush, codex)
- `agents/fleet/` — Fleet management (start-all, stop-all, status, route)
- `.devcontainer/` — Codespace configuration and agent installation
- `.github/workflows/` — CI/CD and agent-triggered workflows

## Key Commands

```bash
# Start all agent servers
./agents/fleet/start-all.sh

# Check agent status
./agents/fleet/status.sh

# Route a task to the appropriate agent
./agents/fleet/route.sh "task description" --agent auto

# Run tests
make test  # if Makefile exists, or cargo test / go test / pytest
```

## Agent Roles

- **OpenCode** (`opencode serve`): Primary headless server. Remote agents attach via ACP.
- **Claude Code**: Deep code analysis, architecture reviews, refactoring.
- **Aider**: Lightweight code generation and editing.
- **Crush**: Fast pattern recognition, quick questions, spike validation.
- **Codex CLI**: Experimental agent with MCP and remote-control modes.

## Build/Test Commands (project-specific, fill in)

```bash
# Build
# cargo build  # if Rust
# go build     # if Go
# python setup.py build  # if Python

# Test
# cargo test   # if Rust
# go test ./...  # if Go
# pytest       # if Python
```
