# OMC to Antigravity (AGY) Skills Migration Plan

This document outlines the comprehensive strategy and step-by-step tasks required to adapt Claude Code (OMC) skills into native Antigravity (AGY) skills.

## Phase 1: Inventory and Triage (✅ Completed)
**Goal**: Understand the scope of the 40+ copied OMC skills and filter out redundancies.
- [x] **Task 1.1**: Enumerate all 40 skills currently present in `~/.gemini/config/skills/`.
- [x] **Task 1.2**: Cross-reference with Antigravity's built-in capabilities (e.g., native slash commands, built-in tools) to identify skills that are no longer needed.
- [x] **Task 1.3**: Categorize the remaining skills by complexity:
  - *Low*: Purely prompt-based instructions.
  - *Medium*: Relies on simple bash/node scripts or standard file edits.
  - *High*: Requires complex orchestration, team mode, subagents, or `/goal` primitives.

## Phase 2: Core Concept Mapping & Migration Guide (✅ Completed)
**Goal**: Establish a clear 1-to-1 mapping from Claude's architecture to Antigravity's architecture.
- [x] **Task 2.1 - Paths**: Map `~/.claude/` and `.omc/` paths to `~/.gemini/config/` and `.agents/`.
- [x] **Task 2.2 - Models**: Map Claude models (`haiku`, `sonnet`, `opus`) to Antigravity performance tiers (`flash_lite`, `flash`, `pro`, `inherit`).
- [x] **Task 2.3 - Subagents**: Map Claude's `Agent(subagent_type=...)` and built-in team mode to Antigravity's `invoke_subagent` and `define_subagent` tools.
- [x] **Task 2.4 - State Management**: Map Claude's session IDs and `/goal` state hooks to Antigravity's conversation IDs, background task statuses, and persistent markdown artifacts.
- [x] **Task 2.5**: Document these rules in a `MIGRATION_GUIDE.md` in this directory.

## Phase 3: Porting Low-Complexity Skills (✅ Completed)
**Goal**: Swiftly adapt text-based and prompt-only skills.
- [x] **Task 3.1**: Run a bulk text replacement across target skills to swap `Claude` and `oh-my-claudecode` mentions with `Antigravity` and `AGY`.
- [x] **Task 3.2**: Ensure the YAML frontmatter (`name`, `description`) and markdown structure align perfectly with Antigravity's `SKILL.md` format.
- [x] **Task 3.3**: Verify and test these skills locally.

## Phase 4: Porting Medium-Complexity Skills (✅ Completed)
**Goal**: Update skills that use helper scripts and CLI interactions.
- [x] **Task 4.1**: Refactor embedded bash or Node scripts to replace Claude-specific environment variables (e.g., `CLAUDE_SESSION_ID`) with Antigravity equivalents.
- [x] **Task 4.2**: Update tool calling instructions so the agent uses Antigravity tools (like `run_command`, `replace_file_content`, `grep_search`) instead of Claude's legacy MCP hooks.
- [x] **Task 4.3**: Validate the execution flow of the updated scripts.

## Phase 5: Porting High-Complexity Skills (✅ Completed)
**Goal**: Rewrite the most advanced workflows (e.g., `autopilot`, `omc-teams`, `ccg`, `ultragoal`).
- [x] **Task 5.1 - Autopilot**: Rewrite `autopilot/SKILL.md` to leverage Antigravity's background tasks and iterative `manage_task` loops.
- [x] **Task 5.2 - Teams**: Rewrite `omc-teams/SKILL.md` to define parallel subagents using the `Subagents` array in `invoke_subagent`, orchestrating them via `send_message`.
- [x] **Task 5.3 - Multi-Model**: Rewrite `ccg/SKILL.md` to effectively dispatch tasks to subagents using the `flash` and `pro` model flags.
- [x] **Task 5.4 - State Tracking**: Rework `ultragoal/SKILL.md` to persist ledger artifacts in `.agents/state/` instead of `.omc/`.

## Phase 6: Global Integration and Cleanup (✅ Completed)
**Goal**: Finalize the migration and clean up the environment.
- [x] **Task 6.1**: Reload the Antigravity configuration to ensure all newly adapted skills in `~/.gemini/config/skills/` are successfully discovered.
- [x] **Task 6.2**: Run end-to-end integration tests on the complex workflows (Autopilot & Teams) to ensure seamless subagent orchestration.
- [x] **Task 6.3**: Archive or delete the old, unadapted OMC skills to prevent namespace collisions or agent confusion.
