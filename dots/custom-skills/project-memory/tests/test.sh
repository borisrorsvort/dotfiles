#!/usr/bin/env bash
# Tests for init.sh and memory-check.sh. Usage: bash tests/test.sh
set -u
HERE="$(cd "$(dirname "$0")/.." && pwd)"
INIT="$HERE/scripts/init.sh"; CHECK="$HERE/scripts/memory-check.sh"
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
pass=0; fail=0
ok() { if [ "$2" = "$3" ]; then pass=$((pass + 1)); else fail=$((fail + 1)); echo "FAIL $1: expected '$3', got '$2'"; fi; }
has() { if printf '%s' "$2" | grep -qF -- "$3"; then pass=$((pass + 1)); else fail=$((fail + 1)); echo "FAIL $1: no '$3' in: $2"; fi; }
fresh() { local d="$TMP/$1"; mkdir -p "$d"; (cd "$d" && git init -q); bash "$INIT" "$d" >/dev/null; echo "$d"; }
code() { bash "$CHECK" "$1" >/dev/null 2>&1; echo $?; }

# init: creates everything, passes the linter, and is safe to re-run
d=$(fresh a)
for f in memory/PROJECT.md memory/INDEX.md memory/handoff.md AGENTS.md CLAUDE.md; do ok "init creates $f" "$([ -f "$d/$f" ] && echo y)" y; done
for f in decisions findings proposals archive; do ok "init creates $f/" "$([ -d "$d/memory/$f" ] && echo y)" y; done
ok "fresh project is clean" "$(code "$d")" 0
echo "custom" > "$d/memory/handoff.md"; before=$(cat "$d/AGENTS.md"); bash "$INIT" "$d" >/dev/null
ok "re-run keeps handoff" "$(cat "$d/memory/handoff.md")" custom
ok "re-run does not repeat AGENTS block" "$(cat "$d/AGENTS.md")" "$before"
ok "one CLAUDE import" "$(grep -c '@AGENTS.md' "$d/CLAUDE.md")" 1

# init: respects existing instruction files
d="$TMP/b"; mkdir -p "$d"; printf '# Mine\n\nKeep me.\n' > "$d/AGENTS.md"; printf 'Claude rule\n' > "$d/CLAUDE.md"; bash "$INIT" "$d" >/dev/null
has "keeps AGENTS content" "$(cat "$d/AGENTS.md")" "Keep me."
has "appends block" "$(cat "$d/AGENTS.md")" "## Project memory"
has "keeps CLAUDE content" "$(cat "$d/CLAUDE.md")" "Claude rule"
has "adds import" "$(cat "$d/CLAUDE.md")" "@AGENTS.md"
d="$TMP/c"; mkdir -p "$d"; echo x > "$d/AGENTS.md"; ln -s AGENTS.md "$d/CLAUDE.md"; bash "$INIT" "$d" >/dev/null
ok "leaves CLAUDE symlink" "$(readlink "$d/CLAUDE.md")" AGENTS.md
ok "symlink gets no import line" "$(grep -c '^@AGENTS.md' "$d/AGENTS.md")" 0

# check: exit codes
mkdir -p "$TMP/none/.git"; ok "no memory exits 2" "$(code "$TMP/none")" 2
d=$(fresh sub); mkdir -p "$d/src/deep"; ok "finds memory from a subfolder" "$(code "$d/src/deep")" 0

# check: each warning fires
d=$(fresh dated); printf '# H\n\n## 2026-10-20\na\n\n## 2026-10-24\nb\n' > "$d/memory/handoff.md"
has "append-only handoff" "$(bash "$CHECK" "$d")" "append-only"
d=$(fresh big); head -c 7000 /dev/zero | tr '\0' x > "$d/memory/handoff.md"
has "oversized handoff" "$(bash "$CHECK" "$d")" "limit 6000"
d=$(fresh old); touch -t 202001010000 "$d/memory/handoff.md"
has "stale handoff" "$(bash "$CHECK" "$d")" "days old"
d=$(fresh link); echo '- [x](decisions/gone.md)' >> "$d/memory/INDEX.md"
has "broken link" "$(bash "$CHECK" "$d")" "missing file: decisions/gone.md"
d=$(fresh nostat); printf '# no frontmatter\n' > "$d/memory/decisions/2026-01-01-a.md"
has "missing status" "$(bash "$CHECK" "$d")" "no 'status: active'"
d=$(fresh unlisted); printf -- '---\nstatus: active\n---\n' > "$d/memory/findings/2026-01-01-b.md"
has "unlisted record" "$(bash "$CHECK" "$d")" "not listed in INDEX.md"
d=$(fresh sup); printf -- '---\nstatus: superseded\nsuperseded_by:\n---\n' > "$d/memory/decisions/2026-01-01-c.md"
has "superseded needs target" "$(bash "$CHECK" "$d")" "no superseded_by"
d=$(fresh prop); echo p > "$d/memory/proposals/2026-01-01-p.md"; touch -t 202001010000 "$d/memory/proposals/2026-01-01-p.md"
has "waiting proposal" "$(bash "$CHECK" "$d")" "Promote it or delete it"
d=$(fresh newprop); echo p > "$d/memory/proposals/2026-01-01-p.md"
ok "new proposal is fine" "$(code "$d")" 0

# check: secrets are flagged by file and never printed
d=$(fresh sec); key=$(printf 'a1%.0s' $(seq 1 32)); echo "token: $key" >> "$d/memory/client-constraints.md"; out=$(bash "$CHECK" "$d")
has "flags 64-hex secret" "$out" "client-constraints.md contains a secret-shaped"
ok "does not print the secret" "$(printf '%s' "$out" | grep -c "$key")" 0
d=$(fresh ghp); echo "ghp_abcdefghijklmnopqrstuvwxyz123456" >> "$d/memory/findings/note.txt"
has "flags GitHub token" "$(bash "$CHECK" "$d")" "secret-shaped"

# init: every symlink form of CLAUDE.md -> AGENTS.md is left alone
for form in ./AGENTS.md ABS; do
  d="$TMP/link$RANDOM"; mkdir -p "$d"; echo x > "$d/AGENTS.md"
  [ "$form" = ABS ] && target="$d/AGENTS.md" || target="$form"
  ln -s "$target" "$d/CLAUDE.md"; bash "$INIT" "$d" >/dev/null
  ok "symlink form $form gets no self-import" "$(grep -c '^@AGENTS.md' "$d/AGENTS.md")" 0
done

# init: a similar heading is not the block
d="$TMP/heading"; mkdir -p "$d"; printf '## Project memory notes\n\nOther.\n' > "$d/AGENTS.md"; bash "$INIT" "$d" >/dev/null
has "similar heading still gets the block" "$(cat "$d/AGENTS.md")" "memory/handoff.md"

# init and check: folder names starting with a hyphen, and names with spaces
( cd "$TMP" && mkdir -- -dash && bash "$INIT" ./-dash >/dev/null && bash "$INIT" -dash >/dev/null 2>&1 ); ok "init accepts a leading-hyphen folder" "$?" 0
( cd "$TMP" && bash "$CHECK" -dash >/dev/null 2>&1 ); ok "check accepts a leading-hyphen folder" "$?" 0
d="$TMP/with space"; mkdir -p "$d"; bash "$INIT" "$d" >/dev/null; ok "works with spaces in the path" "$(code "$d")" 0

# check: status must be in the frontmatter, not the body
d=$(fresh bodystatus); printf '# Title\n\nstatus: active\n' > "$d/memory/decisions/2026-01-01-d.md"; echo '- [d](decisions/2026-01-01-d.md)' >> "$d/memory/INDEX.md"
has "body-only status is not status" "$(bash "$CHECK" "$d")" "no 'status: active'"

# check: an index entry for the same file name elsewhere does not count
d=$(fresh samename); printf -- '---\nstatus: active\n---\n' > "$d/memory/decisions/2026-01-01-e.md"; printf 'old\n' > "$d/memory/archive/2026-01-01-e.md"; echo '- [e](archive/2026-01-01-e.md)' >> "$d/memory/INDEX.md"
has "same name in archive is not listed" "$(bash "$CHECK" "$d")" "not listed in INDEX.md"

# init: a bare heading is not the block, and a longer word is not the import
d="$TMP/bare"; mkdir -p "$d"; printf '## Project memory\n' > "$d/AGENTS.md"; printf 'See @AGENTS.md.disabled\n' > "$d/CLAUDE.md"; bash "$INIT" "$d" >/dev/null
has "bare heading still gets the block" "$(cat "$d/AGENTS.md")" "memory/handoff.md"
ok "disabled import is not the import" "$(grep -cx '@AGENTS.md' "$d/CLAUDE.md")" 1
before=$(cat "$d/AGENTS.md"); bash "$INIT" "$d" >/dev/null; ok "re-run stays stable" "$(cat "$d/AGENTS.md")" "$before"

# init: standing rules live in AGENTS.md, with no separate rule files
d=$(fresh rules)
has "AGENTS has the rules section" "$(cat "$d/AGENTS.md")" "## Preferences and client rules"
ok "no preferences file" "$([ -e "$d/memory/preferences.md" ] && echo y || echo n)" n
ok "no client file" "$([ -e "$d/memory/client-constraints.md" ] && echo y || echo n)" n

echo "passed $pass, failed $fail"
[ "$fail" -eq 0 ]
