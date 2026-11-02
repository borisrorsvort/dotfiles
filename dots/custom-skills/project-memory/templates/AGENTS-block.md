## Preferences and client rules

Follow these on every task. Each rule gets its own line, with the date and who said it, and states the rule in full: name the exact word, tool or value it refers to, so the rule works without any other context.

## Project memory

`memory/` holds this project's shared notes, for every agent working here.

**Before starting work,** read `memory/PROJECT.md`, `memory/INDEX.md` and `memory/handoff.md`, plus any decision listed in the index that touches your task. If the request conflicts with an active decision or a rule in this file, say so before acting.

**As you work,** record these:

- How the developer wants work done (tools, models, PR and review habits, workflow), or a rule a client set: one line under `## Preferences and client rules` in this file, without being asked
- A choice with a reason: `memory/decisions/YYYY-MM-DD-title.md`, listed in `memory/INDEX.md`
- A verified gotcha or fact the code doesn't already show: `memory/findings/YYYY-MM-DD-title.md`, listed in `memory/INDEX.md`

Decision and finding files start with this frontmatter (`type: finding` for findings), followed by what, why and what was rejected:

```
---
type: decision
date: YYYY-MM-DD
status: active
---
```

If you were told you are a worker or one of several agents, write each of these to `memory/proposals/YYYY-MM-DD-title.md` instead, and skip the last step below.

**Before you finish,** rewrite `memory/handoff.md` as the current state: done, in progress, next, open questions.

The `project-memory` skill has the full procedure.
