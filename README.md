# Agent Workspace Template

> A GitHub template repo that embeds every major coding agent into a Codespace, so any new project inherits the full fleet.

**Every project gets its own native build environment with pre-installed AI agents.** Clone it, rename it, and your agents can work inside the repo via GitHub Actions, OpenCode attach, or direct CLI invocation.

## What's Inside

| Agent | Mode | Invocation |
|-------|------|------------|
| **OpenCode** | Headless server (`serve`) | `opencode attach <url>` — persistent ACP |
| **Codex CLI** | Daemon (`remote-control`) | `codex daemon:start` — experimental HTTP |
| **Claude Code** | CLI, non-interactive | `claude --print -p "task"` |
| **Aider** | CLI, non-interactive | `aider --msg "task" --yes` |
| **Crush** | CLI, non-interactive | `crush run "task"` |

## Quick Start

```bash
# Start all persistent agent servers
./agents/fleet/start-all.sh

# Check what's running
./agents/fleet/status.sh

# Route a task to the right agent
./agents/fleet/route.sh "refactor this module" --agent claude-code
```

## Architecture

```
GitHub Repo
├── Codespace (x86_64, native)
│   ├── opencode serve (:4096)   ← attach here from Oracle/local agents
│   ├── codex remote-control     ← experimental daemon
│   ├── aider                    ← on-demand CLI
│   ├── claude                   ← on-demand CLI
│   └── crush                    ← on-demand CLI
│
├── GitHub Actions
│   ├── agent-call.yml           ← triggerable by issue comment
│   └── agent-pr.yml             ← auto-review PRs
│
└── .devcontainer/
    └── post-create.sh           ← installs everything on Codespace boot
```
