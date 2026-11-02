#!/usr/bin/env bash
# Set up memory/ in a project and point agents at it. Safe to re-run: existing files are kept.
# Usage: init.sh <project-dir>
set -eu
SKILL="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT="${1:?usage: init.sh <project-dir>}"
[ -d "$PROJECT" ] || { echo "No such folder: $PROJECT" >&2; exit 1; }
cd -- "$PROJECT"

mkdir -p memory/decisions memory/findings memory/proposals memory/archive
for f in PROJECT.md INDEX.md handoff.md client-constraints.md; do
  if [ -e "memory/$f" ]; then echo "kept      memory/$f"
  else cp "$SKILL/templates/memory/$f" "memory/$f"; echo "created   memory/$f"; fi
done

if grep -qsF '**Before starting work,** read `memory/PROJECT.md`' AGENTS.md; then
  echo "kept      AGENTS.md (already has the block)"
else
  [ -s AGENTS.md ] && printf '\n' >> AGENTS.md
  cat "$SKILL/templates/AGENTS-block.md" >> AGENTS.md
  echo "updated   AGENTS.md"
fi

# Claude Code ignores AGENTS.md when a CLAUDE.md exists, so CLAUDE.md must import it.
if [ -L CLAUDE.md ] && [ CLAUDE.md -ef AGENTS.md ]; then
  echo "kept      CLAUDE.md (links to AGENTS.md)"
elif [ ! -e CLAUDE.md ]; then
  printf '@AGENTS.md\n' > CLAUDE.md
  echo "created   CLAUDE.md"
elif grep -qsx '@AGENTS.md' CLAUDE.md; then
  echo "kept      CLAUDE.md (already imports AGENTS.md)"
else
  printf '\n@AGENTS.md\n' >> CLAUDE.md
  echo "updated   CLAUDE.md"
fi

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  url="$(git remote get-url origin 2>/dev/null || true)"
  [ -n "$url" ] && echo "Check this repo is private before committing memory/: $url"
fi
