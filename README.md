# Agent Workspace Template

> **A repo with a resident journeyman.** Every project gets its own native build environment, embedded AI agents that built and maintain it, and a living memory of everything that's happened.

Create a repo from this template, boot the Codespace, and you have a full agent ecosystem ready to build, maintain, and explain the codebase — without cloning, without wikis, without context-switching.

## The Philosophy

Most "repo intelligence" systems work like Wikipedia — an outside agent reads your repo, compresses it into vectors or notes, and answers from that compression. One step removed from ground truth.

**We do it differently.** The agent lives inside the repo. It builds the application, fixes bugs, writes tests, and records its experience. When you ask a question, it doesn't read a summary — it remembers, because it was there.

This is **experience-first knowledge** — one abstraction closer to ground truth than any synthesized wiki.

## What's Inside

| Component | Role |
|-----------|------|
| **OpenCode serve** (:4096) | Primary headless server — attach from anywhere via ACP |
| **Claude Code** | Deep reasoning, architecture reviews, maintenance |
| **Aider** | Lightweight code generation with file context |
| **Crush** | Fast pattern recognition, quick questions |
| **Codex CLI** | Exec-mode tasks and code reviews |
| **Fleet router** | Auto-selects the right agent per task type |
| **Agent memory** | Session logs, decisions, gotchas, maintenance history |
| **Incarnation lore** | Repo narrative, architecture evolution |
| **GitHub workflows** | `/agent <task>` via issue comment, automated PR reviews |

## Quick Start

```bash
# 1. Create a new repo from this template on GitHub
# 2. Open the Codespace (everything installs automatically)

# 3. Start persistent agent servers
./agents/fleet/start-all.sh

# 4. Connect from any local agent
opencode attach http://<codespace-url>:4096

# 5. Build your project — every decision is remembered
```

## Architecture

```
Oracle (ARM64, orchestration)
  └─ mini-agents / me
       │
       ├─ opencode attach → Codespace agent (:4096)
       │     └─ Runs in repo-native environment (x86_64)
       │     └─ Writes experience to agent/memory/
       │
       ├─ gh issue comment → "/agent <task>"
       │     └─ Triggers agent-call.yml workflow
       │
       └─ SSH → gh codespace ssh
             └─ ./agents/fleet/route.sh "task"

Every repo's Codespace:
  ├─ opencode serve ─── persistent, attachable
  ├─ agent/memory/ ──── the journeyman's notebook
  ├─ incarnation/lore/ ─ the repo's lived story
  └─ CLI agents ─────── on-demand as needed
```

## The Journeyman Pattern

This isn't just a development environment. It's a **maintenance contract**. The agent in each repo:

- Knows the repo's history — what broke, what fixed it, what scared previous agents
- Handles dependency updates, security patches, and routine maintenance
- Answers questions with lived experience, not compressed summaries
- Gets smarter with every session — memory accumulates

Over time, each repo's resident agent becomes the single most qualified entity to explain, extend, or fix that codebase.

---

**Create a repo from this template and give every project its own journeyman.** 🦞
