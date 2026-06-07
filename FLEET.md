# Agent Routing Guide

> Which agent to use for which task.

## Quick Reference

| Task Type | Recommended Agent | Why |
|-----------|-------------------|-----|
| **Architecture review** | Claude Code | 200K context, deep reasoning, multi-file awareness |
| **Refactor a module** | OpenCode (attach) | Interactive session, can modify files progressively |
| **Quick question** | Crush | Fast pattern recognition, no setup overhead |
| **Add a feature** | Aider | Good at targeted code generation with file context |
| **Bug fix** | OpenCode or Claude Code | Depends on complexity — Claude for subtle bugs |
| **Code review (CI)** | Claude Code (via agent-pr.yml) | Automated PR review |
| **Cross-repo migration** | Kimi Code (external) | 1M+ context, sees entire fleet |
| **Spike/fast prototype** | Crush | Terse, grok-first, fast turnaround |
| **Safety audit** | Claude Code | Deep safety analysis, SAEP vetting |
| **Documentation** | OpenCode | Can write and iterate on docs interactively |

## Auto-Routing Logic

The `route.sh` script auto-selects based on task keywords:

| Keyword in Task | Routes To |
|-----------------|-----------|
| review, audit, check, inspect | Claude Code |
| refactor, rewrite, migrate, restructure | OpenCode |
| quick, fast, spike, grok, what is | Crush |
| implement, add, create, write | Aider |
| codex, merge, resolve | Codex CLI |

Override with `--agent <name>`.

## Architecture Decision

**OpenCode serve is the primary persistent server** because:
1. It has a clean headless mode with ACP protocol
2. `opencode attach` works over HTTP — no SSH required
3. It supports long-running interactive sessions
4. It's designed for agent-to-agent communication

**All other agents are on-demand CLI invocations** because:
- They lack proper headless server modes
- They're designed for single-turn interactions
- They're faster to invoke fresh than to keep alive

## Connecting from External Agents

```bash
# 1. Open tunnel to Codespace
gh codespace ports forward codespace-port:4096 local-port:4096

# 2. Attach OpenCode
opencode attach http://localhost:4096

# 3. Or trigger via GitHub
gh issue comment <issue> --body "/agent review the PR"
```
