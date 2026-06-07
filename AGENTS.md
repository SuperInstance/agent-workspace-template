# Agent Integration Guide

> How OpenClaw mini-agents, Claude Code, OpenCode, Aider, Crush, and Codex interact with this repo.

## For OpenClaw Mini-Agents (Orchestrators)

This repo is designed to be a **build target** for mini-agents running on the Oracle instance. The flow:

```
Oracle (ARM64)
  └─ mini-agent (me)
       ├─ opencode attach → http://<codespace-host>:4096
       │     └─ send coding tasks directly into repo's native environment
       │
       ├─ gh issue comment → "/agent refactor engine.rs"
       │     └─ triggers agent-call.yml workflow
       │
       └─ ssh → codespace → ./agents/fleet/route.sh "task"
             └─ on-demand via existing codespace-worker.sh
```

### Recommended Workflow

| Integration | When to Use |
|-------------|-------------|
| **OpenCode attach** (primary) | Long sessions, back-and-forth, iterative development |
| **GitHub Issue / `/agent`** | Fire-and-forget, async tasks |
| **SSH + route.sh** | Quick one-shot tasks, emergency patches |

## For Claude Code

The `CLAUDE.md` file at the repo root tells Claude Code about the project. It includes:
- Repository structure
- Build/test commands
- Agent capabilities

Run Claude Code manually:
```bash
claude --print -p "your task"
```

## For OpenCode (Headless Server)

The OpenCode server listens on port 4096 when started. Connect from any machine:

```bash
opencode attach http://<codespace-host>:4096
```

Once attached, you're in an interactive coding session running inside the repo's native environment. All file edits, builds, and tests happen in the Codespace — not on your local machine.

## For Aider

Aider works best when pointed at specific files:
```bash
./agents/aider/invoke.sh "refactor this function" --files src/main.rs
```

## For Crush

Crush is for fast pattern recognition and questions:
```bash
./agents/crush/invoke.sh "what does this module do?"
```

## For Codex CLI

Codex can run exec-mode tasks or reviews:
```bash
./agents/codex/invoke.sh exec "fix the bug in main.rs"
./agents/codex/invoke.sh review src/main.rs
```

## Setting Up a New Project

1. Create a new repo from this template
2. Start the Codespace
3. Run `./agents/fleet/start-all.sh` to launch persistent servers
4. From Oracle (or any remote): `opencode attach http://<codespace-url>:4096`
5. Build your project

The template handles agent installation, Git config, and project structure.
