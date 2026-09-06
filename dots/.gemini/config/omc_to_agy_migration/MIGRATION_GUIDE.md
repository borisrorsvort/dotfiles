# MIGRATION_GUIDE.md

This document serves as the key mapping guide for converting Claude Code (OMC) primitives into Antigravity (AGY) primitives.

### Path Mappings
- **Claude:** `~/.claude/` -> **Antigravity:** `~/.gemini/config/`
- **Claude Project:** `.omc/` or `.claude/` -> **Antigravity:** `.agents/`

### Terminology
- **Claude Code** -> **Antigravity**
- **oh-my-claudecode:** -> **agy-**

### Model Mappings
- `haiku` -> `flash_lite` (Fastest, low-cost)
- `sonnet` -> `flash` (Standard subagent, research, coding)
- `opus` -> `pro` (Complex reasoning, deep orchestration)

### Agent Primitives
- **Claude's Subagent Syntax:** `Agent(subagent_type="...", model="haiku")`
- **Antigravity's Subagent Syntax:** `invoke_subagent(TypeName="...", Model="flash_lite")`

- **Team Mode:** Claude Code uses implicit team routing. Antigravity uses the `Subagents` array within `invoke_subagent` and orchestrates communication via the `send_message` tool.

### State & Hooks
- `CLAUDE_SESSION_ID` -> `AGY_CONVERSATION_ID`
- Claude `/goal` hooks are replaced by Antigravity's durable background tasks and persistent artifacts (`manage_task`).
