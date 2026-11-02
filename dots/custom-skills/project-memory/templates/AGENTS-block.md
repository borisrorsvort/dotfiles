## Project memory

`memory/` holds this project's shared notes, for every agent working here.

**Before starting work,** read `memory/PROJECT.md`, `memory/INDEX.md`, `memory/handoff.md` and `memory/client-constraints.md`, plus any decision listed in the index that touches your task. If the request conflicts with an active decision or a client rule, say so before acting.

**As you work,** record these in `memory/`:

- A choice with a reason: `decisions/YYYY-MM-DD-title.md`, listed in `INDEX.md`
- A client or standing rule: `client-constraints.md`
- A verified gotcha or fact: `findings/YYYY-MM-DD-title.md`, listed in `INDEX.md`

Decision and finding files start with this frontmatter (`type: finding` for findings), followed by what, why and what was rejected:

```
---
type: decision
date: YYYY-MM-DD
status: active
---
```

If you were told you are a worker or one of several agents, write each of these to `proposals/YYYY-MM-DD-title.md` instead, and skip the last step below.

**Before you finish,** rewrite `memory/handoff.md` as the current state: done, in progress, next, open questions.

The `project-memory` skill has the full procedure.
