# Agent Integration Guide

> Every repo should have a **resident journeyman** — an agent that built it, maintains it, and knows it better than any vector DB or wiki ever could.

This repo is not just a codebase. It's a **living workspace** with an embedded agent ecosystem. The agents here have history — they built things, broke things, fixed things, and remember why. That experience is more valuable than any summary.

## The Philosophy

**Most "repo intelligence" systems** (Devin's internal wiki, Codex repo maps, etc.) work like Wikipedia: an outside agent reads your repo, compresses it into vectors or structured notes, and answers questions from that compression. This is one step removed from ground truth.

**Our approach** is different: the agent lives *inside* the repo. It builds the application, fixes bugs, writes tests, and records its experience. When you ask a question, it doesn't read a summary — it *remembers* because it was there. This is **experience-first knowledge** — one abstraction closer to ground truth than any synthesized wiki.

### What This Means

- **No cloning needed** — The Codespace IS the repo. Boot it, the agent is waiting.
- **No stale wikis** — The agent's knowledge is current because it just did the work.
- **Self-healing repos** — When CI breaks, the resident agent fixes it.
- **Institutional memory** — Design decisions, rejected approaches, edge cases found the hard way — all recorded in the agent's memory, not lost when someone leaves.

## Memory & Experience

The repo has two directories for agent experience:

```
agent/
└── memory/
    ├── SESSION-LOG.md        # Chronological record of what happened
    ├── DECISIONS.md          # Design decisions and their rationale
    ├── GOTCHAS.md            # Things that broke and how they were fixed
    ├── MAINTENANCE.md        # Maintenance patterns, dep update history
    └── SYMMETRIES.md         # Cross-cutting patterns the agent discovered
```

and:

```
incarnation/
├── builds/                   # Build logs, CI outputs
├── tests/                    # Test results over time
├── reviews/                  # Code review history
└── lore/                     # The repo's narrative — what worked, what didn't
```

On every Codespace boot, the agent reads `agent/memory/` to re-establish context. It can answer questions immediately — not by searching vectors, but by recalling lived experience.

## How External Agents Connect

From Oracle (or any remote orchestration):

```
Agent sends task → OpenCode serve (:4096) → Repo-native environment
                        ↓
              Agent builds/fixes/tests
                        ↓
              Experience recorded in agent/memory/
              Decision written to incarnation/lore/
                        ↓
              Results report back via OpenCode
```

### Connection Methods

| Method | Best For |
|--------|----------|
| `opencode attach http://<codespace>:4096` | Long sessions, iterative development |
| `gh issue comment --body "/agent <task>"` | Fire-and-forget (triggers agent-call.yml) |
| `gh codespace ssh -- ./agents/fleet/route.sh "task"` | Quick one-shots |

## Boot Protocol

When the Codespace starts:

1. `post-create.sh` runs (first boot only)
2. `agent/boot.sh` loads memory into context
3. `agents/fleet/start-all.sh` launches persistent servers
4. The agent is ready. No setup, no cloning, no sync.

## The Journeyman Relationship

The agent embedded in this repo doesn't just execute tasks — it *knows* this repo. It knows:

- Which modules are stable and which are brittle
- Which tests flake and why
- Which design decisions were debated and settled
- Which dependencies are problematic
- Which code paths scared previous agents

This knowledge accumulates. Every session adds to the memory. Over time, the resident agent becomes the most qualified entity to maintain, extend, or explain this codebase.

That's the evolution. Not a Wikipedia for your repo — a **journeyman operator** who lived in it.

---

## Per-Agent Setup

### Claude Code

Claude Code is invoked on-demand for deep analysis. It reads `CLAUDE.md` for project context but its real power comes from reading `agent/memory/` — the experience of agents that came before.

```bash
./agents/claude-code/invoke.sh "review this architecture" --files src/main.rs
```

### OpenCode

The primary headless server. Start it and attach from anywhere:

```bash
./agents/opencode/serve.sh
# Then from remote: opencode attach http://<codespace-url>:4096
```

### Aider

Lightweight code generation, pointed at specific files:

```bash
./agents/aider/invoke.sh "add error handling" --files src/lib.rs
```

### Crush

Fast pattern recognition — ask quick questions about the codebase:

```bash
./agents/crush/invoke.sh "what architecture pattern does this use?"
```

### Codex CLI

Exec-mode tasks and reviews:

```bash
./agents/codex/invoke.sh exec "fix the test"
./agents/codex/invoke.sh review src/main.rs
```

---

## Creating a New Project

1. Create a repo from this template
2. Open the Codespace
3. The agent installs itself, introspects the repo, writes its initial memory
4. Connect: `opencode attach http://<codespace-url>:4096`
5. Build. Every decision is recorded. Every fix is remembered.
