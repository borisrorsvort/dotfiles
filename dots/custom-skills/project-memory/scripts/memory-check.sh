#!/usr/bin/env bash
# Lint a project's memory/ folder and print one warning per line.
# Adapted from LeiZiKang/agent-memory (MIT, see LICENSE-agent-memory).
# Usage: memory-check.sh [project-dir]   (default: current folder)
# Exit: 0 clean, 1 warnings, 2 no memory/ folder found.
MAX_HANDOFF=${PROJECT_MEMORY_MAX_HANDOFF:-6000}
MAX_INDEX=${PROJECT_MEMORY_MAX_INDEX:-8000}
STALE_DAYS=${PROJECT_MEMORY_STALE_DAYS:-14}
PROPOSAL_DAYS=${PROJECT_MEMORY_PROPOSAL_DAYS:-7}

dir="$(cd -- "${1:-.}" 2>/dev/null && pwd)" || { echo "No such folder: ${1:-.}" >&2; exit 2; }
while [ ! -d "$dir/memory" ]; do
  [ -e "$dir/.git" ] || [ "$dir" = "/" ] && { echo "No memory/ folder found." >&2; exit 2; }
  dir="$(dirname "$dir")"
done
cd "$dir/memory" || exit 2

found=0
warn() { echo "- $*"; found=1; }
now=$(date +%s)
mtime() { stat -c %Y "$1" 2>/dev/null || stat -f %m "$1"; }
size() { wc -c < "$1" | tr -d ' '; }

if [ -f handoff.md ]; then
  s=$(size handoff.md)
  [ "$s" -gt "$MAX_HANDOFF" ] && warn "handoff.md is $s bytes (limit $MAX_HANDOFF). Rewrite it as the current state only."
  age=$(( (now - $(mtime handoff.md)) / 86400 ))
  [ "$age" -ge "$STALE_DAYS" ] && warn "handoff.md is $age days old. Verify it before relying on it."
  dated=$(grep -cE '^#{1,3} .*[0-9]{4}-[0-9]{2}-[0-9]{2}' handoff.md)
  [ "$dated" -ge 2 ] && warn "handoff.md has $dated dated headings, so it looks append-only. Keep one current snapshot."
else
  warn "handoff.md is missing."
fi

if [ -f INDEX.md ]; then
  s=$(size INDEX.md)
  [ "$s" -gt "$MAX_INDEX" ] && warn "INDEX.md is $s bytes (limit $MAX_INDEX). Trim it to the state line and the record list."
  while read -r link; do
    case "$link" in ''|http://*|https://*|mailto:*) continue ;; esac
    [ -e "$link" ] || warn "INDEX.md links to a missing file: $link"
  done < <(grep -oE '\]\([^)]+\)' INDEX.md | sed -E 's/^\]\(//; s/\)$//; s/#.*//')
else
  warn "INDEX.md is missing."
fi

for f in decisions/*.md findings/*.md; do
  [ -f "$f" ] || continue
  # Only the frontmatter counts: the block between a first-line --- and the next ---.
  fm=$(awk 'NR==1 { if ($0 != "---") exit; next } $0 == "---" { exit } { print }' "$f")
  st=$(printf '%s\n' "$fm" | sed -nE 's/^status:[[:space:]]*([a-z]+).*/\1/p' | head -n 1)
  case "$st" in
    active)
      [ -f INDEX.md ] && ! grep -qF "$f" INDEX.md && warn "$f is not listed in INDEX.md." ;;
    superseded)
      by=$(printf '%s\n' "$fm" | sed -nE 's/^superseded_by:[[:space:]]*//p' | head -n 1)
      if [ -z "$by" ]; then warn "$f is superseded but has no superseded_by."
      elif [ ! -e "decisions/$by" ] && [ ! -e "findings/$by" ] && [ ! -e "$by" ]; then
        warn "$f: superseded_by '$by' does not exist."
      fi ;;
    *) warn "$f has no 'status: active' or 'status: superseded' in its frontmatter." ;;
  esac
done

for f in proposals/*.md; do
  [ -f "$f" ] || continue
  age=$(( (now - $(mtime "$f")) / 86400 ))
  [ "$age" -ge "$PROPOSAL_DAYS" ] && warn "$f has waited $age days. Promote it or delete it."
done

# Secret-shaped strings. Names only: never print the matching value.
while read -r f; do
  warn "$f contains a secret-shaped string. Remove it and rotate the secret."
done < <(grep -rlIE '(sk-[A-Za-z0-9_-]{20,}|ghp_[A-Za-z0-9]{20,}|gho_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}|AIza[0-9A-Za-z_-]{30,}|xox[bp]-[A-Za-z0-9-]{10,}|figd_[A-Za-z0-9_-]{20,}|(^|[^0-9a-fA-F])[0-9a-f]{64}([^0-9a-fA-F]|$))' . 2>/dev/null)

[ "$found" -eq 0 ] || exit 1
exit 0
