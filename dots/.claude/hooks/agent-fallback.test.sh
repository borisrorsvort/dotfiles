#!/usr/bin/env bash
# Tests for agent-fallback.sh. Orca and notifications are stubbed, so no agent runs and no quota is used.
# Usage: bash agent-fallback.test.sh
set -u
HERE="$(cd "$(dirname "$0")" && pwd)"
SCRIPT="$HERE/agent-fallback.sh"
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
cd "$TMP" || exit 1 # away from any mise.toml that a jq shim would refuse to run in
pass=0; fail=0
ok() { if [ "$2" = "$3" ]; then pass=$((pass + 1)); else fail=$((fail + 1)); echo "FAIL $1: expected '$3', got '$2'"; fi; }
has() { if printf '%s' "$2" | grep -qF -- "$3"; then pass=$((pass + 1)); else fail=$((fail + 1)); echo "FAIL $1: no '$3' in: $(printf '%s' "$2" | head -c 400)"; fi; }
hasnt() { if printf '%s' "$2" | grep -qF -- "$3"; then fail=$((fail + 1)); echo "FAIL $1: found '$3'"; else pass=$((pass + 1)); fi; }

# Stubs: each logs its arguments, and the launch stub can be told to fail.
mkdir -p "$TMP/bin"
cat > "$TMP/bin/orca-stub" <<'EOF'
#!/usr/bin/env bash
if [ "${1:-}" = status ]; then exit 0; fi
printf '%s\n' "$*" >> "$STUB_LOG/launch"
[ -e "$STUB_LOG/launch-fails" ] && exit 1
exit 0
EOF
cat > "$TMP/bin/notify-send" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$*" >> "$STUB_LOG/notify"
EOF
chmod +x "$TMP/bin/orca-stub" "$TMP/bin/notify-send"

FAKE_TOKEN="ghp_""abcdefghijklmnopqrstuvwxyz123456" # split, so secret scanners don't flag this fake
n=0
# Sets up a new project, a clean state folder and a transcript. Leaves the path in $P.
project() {
  n=$((n + 1)); P="$TMP/p$n"; mkdir -p "$P"
  export STUB_LOG="$TMP/log$n"; mkdir -p "$STUB_LOG"; : > "$STUB_LOG/launch"; : > "$STUB_LOG/notify"
  export XDG_STATE_HOME="$TMP/state$n"
  if [ "${1:-git}" = git ]; then
    git -C "$P" init -q; git -C "$P" config user.email t@example.com; git -C "$P" config user.name T
    echo one > "$P/a.txt"; git -C "$P" add a.txt; git -C "$P" commit -qm "first commit"
  fi
  T="$TMP/t$n.jsonl"
  {
    printf '%s\n' '{"type":"user","message":{"role":"user","content":"Build the invoice export"}}'
    printf '%s\n' '{"type":"assistant","message":{"role":"assistant","content":[{"type":"text","text":"I chose CSV over XLSX because clients asked."},{"type":"tool_use","name":"Bash","input":{"command":"ls"}}]}}'
    printf '%s\n' '{"type":"user","message":{"role":"user","content":[{"type":"tool_result","content":"TOOL-OUTPUT-NOISE"}]}}'
    printf '%s\n' '{"type":"user","isSidechain":true,"message":{"role":"user","content":"SIDECHAIN-NOISE"}}'
    printf '%s\n' 'not json at all'
    printf '%s\n' "{\"type\":\"assistant\",\"message\":{\"role\":\"assistant\",\"content\":[{\"type\":\"text\",\"text\":\"Token is $FAKE_TOKEN ok\"}]}}"
  } > "$T"
}
export AGENT_FALLBACK_ORCA="$TMP/bin/orca-stub"
export AGENT_FALLBACK_CONF="$TMP/no-conf"
export PATH="$TMP/bin:$PATH"
run() { ORCA_PANE_KEY=tab:1 bash "$SCRIPT" hook; }
input() { # event [extra jq object]
  jq -cn --arg e "$1" --arg c "$P" --arg t "$T" --argjson x "${2:-{\}}" '{hook_event_name:$e,cwd:$c,transcript_path:$t,session_id:"s1"} + $x'
}
limit_text='{"error":"rate_limit","error_details":"You have hit your usage limit","last_assistant_message":"API Error"}'
temp_text='{"error":"rate_limit","error_details":"429 Too Many Requests","last_assistant_message":"API Error: Rate limit reached"}'
quota() { # percent [seconds until reset] [age in seconds]
  local dir="$XDG_STATE_HOME/agent-fallback"; mkdir -p "$dir"
  jq -cn --argjson p "$1" --argjson r "$(( $(date +%s) + ${2:-7200} ))" --argjson a "$(( $(date +%s) - ${3:-0} ))" \
    '{at:$a,five_hour:$p,five_hour_reset:$r,seven_day:10,seven_day_reset:($r+100000)}' > "$dir/quota.json"
}
launches() { grep -c '' "$STUB_LOG/launch"; }
notifies() { grep -c '' "$STUB_LOG/notify"; }
brief_of() { sed -nE 's/.*Read (.*brief-[^ ]*\.md).*/\1/p' "$STUB_LOG/launch" | head -n 1; }

# Outside Orca nothing happens
project; input StopFailure "$limit_text" | bash "$SCRIPT" hook; ok "outside Orca exits 0" "$?" 0
ok "outside Orca: no launch" "$(launches)" 0; ok "outside Orca: no notification" "$(notifies)" 0

# A real usage limit hands over once, in the same worktree, with a useful brief
project; echo two >> "$P/a.txt"; mkdir -p "$P/memory"; echo "HANDOFF-NOTE" > "$P/memory/handoff.md"
input StopFailure "$limit_text" | run; ok "limit: exit 0" "$?" 0
ok "limit: one launch" "$(launches)" 1
line=$(cat "$STUB_LOG/launch")
has "limit: launch command" "$line" "agent launch --agent antigravity"
has "limit: told to take over" "$line" "taking over"
has "limit: told not to merge" "$line" "Do not merge or push"
has "limit: brief is data" "$line" "data"
b=$(brief_of); ok "limit: brief exists" "$([ -f "$b" ] && echo y)" y
c=$(cat "$b" 2>/dev/null)
has "brief: original task" "$c" "Build the invoice export"
has "brief: assistant reasoning" "$c" "I chose CSV over XLSX"
has "brief: commit" "$c" "first commit"
has "brief: uncommitted file" "$c" "a.txt"
has "brief: handoff" "$c" "HANDOFF-NOTE"
hasnt "brief: no tool output" "$c" "TOOL-OUTPUT-NOISE"
hasnt "brief: no subagent chatter" "$c" "SIDECHAIN-NOISE"
hasnt "brief: secret removed" "$c" "$FAKE_TOKEN"
has "brief: secret marker" "$c" "[REDACTED]"
ok "limit: brief in the git dir" "$(case "$b" in "$P/.git/"*) echo y;; esac)" y
hasnt "limit: brief not visible to git" "$(git -C "$P" status --short)" "brief"
has "limit: you are told" "$(cat "$STUB_LOG/notify")" "antigravity"

# A second failure in the same worktree only notifies
before=$(notifies); input StopFailure "$limit_text" | run
ok "second failure: no new launch" "$(launches)" 1
ok "second failure: notified" "$(notifies)" "$((before + 1))"
# --reset allows it again
(cd "$P" && bash "$SCRIPT" --reset >/dev/null); input StopFailure "$limit_text" | run
ok "--reset allows another handover" "$(launches)" 2

# An old handover has expired
project; input StopFailure "$limit_text" | run
touch -d '2 days ago' "$P/.git/agent-fallback/handover.lock"; input StopFailure "$limit_text" | run
ok "expired lock allows a handover" "$(launches)" 2

# A temporary 429 does not hand over
project; quota 40; input StopFailure "$temp_text" | run
ok "temporary 429: no launch" "$(launches)" 0; ok "temporary 429: notified" "$(notifies)" 1
# Nor without a reading
project; input StopFailure "$temp_text" | run; ok "no reading, vague error: no launch" "$(launches)" 0
# A high fresh reading confirms the limit
project; quota 97; input StopFailure "$temp_text" | run; ok "high reading: launch" "$(launches)" 1
# A stale reading does not
project; quota 97 7200 7200; input StopFailure "$temp_text" | run; ok "stale reading: no launch" "$(launches)" 0
# Other errors are not ours
project; input StopFailure '{"error":"overloaded"}' | run
ok "overloaded: no launch" "$(launches)" 0; ok "overloaded: no notification" "$(notifies)" 0

# A reset coming soon means waiting
project; quota 99 300; input StopFailure "$limit_text" | run
ok "reset soon: no launch" "$(launches)" 0; has "reset soon: notified" "$(cat "$STUB_LOG/notify")" "reset"

# Subagents never trigger a handover
project; input StopFailure "${limit_text%\}},\"agent_id\":\"sub1\"}" | run; ok "subagent: no launch" "$(launches)" 0

# Two tabs at once start exactly one agent
project
for i in 1 2 3 4 5 6; do (input StopFailure "$limit_text" | run) & done; wait
ok "parallel: one launch" "$(launches)" 1

# A failed launch notifies and leaves things as they were
project; touch "$STUB_LOG/launch-fails"; input StopFailure "$limit_text" | run; ok "failed launch: exit 0" "$?" 0
has "failed launch: notified" "$(cat "$STUB_LOG/notify")" "failed"
ok "failed launch: lock released" "$([ -e "$P/.git/agent-fallback/handover.lock" ] && echo y || echo n)" n
rm "$STUB_LOG/launch-fails"; : > "$STUB_LOG/launch"; input StopFailure "$limit_text" | run; ok "failed launch: can retry" "$(launches)" 1

# The chain moves on when an agent fails, and a missing file is fine
project; printf 'CHAIN="first second"\n' > "$TMP/conf"
cat > "$TMP/bin/orca-chain" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$*" >> "$STUB_LOG/launch"
case "$*" in *"--agent first"*) exit 1;; esac
exit 0
EOF
chmod +x "$TMP/bin/orca-chain"
input StopFailure "$limit_text" | AGENT_FALLBACK_CONF="$TMP/conf" AGENT_FALLBACK_ORCA="$TMP/bin/orca-chain" ORCA_PANE_KEY=tab:1 bash "$SCRIPT" hook
has "chain: second agent used" "$(tail -n 1 "$STUB_LOG/launch")" "--agent second"
ok "chain: tried both" "$(launches)" 2

# A linked worktree has its own state
project; input StopFailure "$limit_text" | run
W="$TMP/wt$n"; git -C "$P" worktree add -q -b other "$W"; P2="$P"; P="$W"
input StopFailure "$limit_text" | run; ok "linked worktree: own handover" "$(launches)" 2; P="$P2"

# A subfolder resolves to the project, and a folder without git still works
project; mkdir -p "$P/sub/dir"; S="$P"; P="$S/sub/dir"; input StopFailure "$limit_text" | run; P="$S"
ok "subfolder: state at the root" "$([ -d "$P/.git/agent-fallback" ] && echo y)" y
project nogit; input StopFailure "$limit_text" | run; ok "no git: launch" "$(launches)" 1
b=$(brief_of); ok "no git: brief outside the project" "$(case "$b" in "$XDG_STATE_HOME"*) echo y;; esac)" y
ok "no git: nothing added to the folder" "$(/usr/bin/ls -A "$P" | wc -l | tr -d ' ')" 0

# A missing transcript and bad input never fail
project; jq -cn --arg c "$P" '{hook_event_name:"StopFailure",cwd:$c,transcript_path:"/nonexistent",error:"rate_limit",error_details:"usage limit"}' | run
ok "missing transcript: still hands over" "$(launches)" 1
project; printf 'garbage' | run; ok "bad input: exit 0" "$?" 0; ok "bad input: no launch" "$(launches)" 0
project; printf '' | run; ok "empty input: exit 0" "$?" 0

# Near the limit, on its own: ask once, then hand over when the turn ends
project; quota 92; out=$(input PostToolUse | run)
has "near: asks for a handoff" "$out" "additionalContext"
has "near: names the event" "$out" '"hookEventName":"PostToolUse"'
has "near: mentions the handoff file" "$out" "memory/handoff.md"
ok "near: valid JSON" "$(printf '%s' "$out" | jq -r '.hookSpecificOutput.hookEventName')" PostToolUse
ok "near: not launched yet" "$(launches)" 0
out=$(input PostToolUse | run); ok "near: asks only once" "$out" ""
input Stop | run; ok "near: handover at end of turn" "$(launches)" 1
input Stop | run; ok "near: only one handover" "$(launches)" 1

# An ordinary end of turn does nothing
project; quota 50; input Stop | run; ok "ordinary stop: no launch" "$(launches)" 0
out=$(input PostToolUse | run); ok "below threshold: silent" "$out" ""
# A stale reading does not count
project; quota 95 7200 7200; out=$(input PostToolUse | run); ok "near, stale reading: silent" "$out" ""
# No reading at all
project; out=$(input PostToolUse | run); ok "near, no reading: silent" "$out" ""
# Subagents' tool calls don't count
project; quota 95; out=$(input PostToolUse '{"agent_id":"sub1"}' | run); ok "near, subagent: silent" "$out" ""

# Near the limit while you're typing: notify only
project; quota 92; input UserPromptSubmit | run; out=$(input PostToolUse | run)
ok "active: no request to Claude" "$out" ""; ok "active: notified" "$(notifies)" 1
input PostToolUse | run >/dev/null; ok "active: notified once" "$(notifies)" 1
input Stop | run; ok "active: no handover" "$(launches)" 0

# After typing has gone quiet, it can act
project; quota 92; input UserPromptSubmit | run
touch -d '30 minutes ago' "$P/.git/agent-fallback/last-prompt"; out=$(input PostToolUse | run)
has "quiet again: asks for a handoff" "$out" "additionalContext"

# Typing after the request cancels the handover
project; quota 92; input PostToolUse | run >/dev/null; input UserPromptSubmit | run; input Stop | run
ok "typed after request: no handover" "$(launches)" 0

# Near the limit with a reset close by: notify, no request
project; quota 92 300; out=$(input PostToolUse | run)
ok "near, reset soon: no request" "$out" ""; ok "near, reset soon: notified" "$(notifies)" 1
# The weekly window counts too
project; mkdir -p "$XDG_STATE_HOME/agent-fallback"
jq -cn --argjson a "$(date +%s)" --argjson r "$(( $(date +%s) + 500000 ))" '{at:$a,five_hour:5,five_hour_reset:$r,seven_day:93,seven_day_reset:$r}' > "$XDG_STATE_HOME/agent-fallback/quota.json"
out=$(input PostToolUse | run); has "weekly window: asks" "$out" "additionalContext"
# Once handed over, stop asking
project; quota 92; input StopFailure "$limit_text" | run; out=$(input PostToolUse | run); ok "already handed over: silent" "$out" ""

# Status line: saves the reading and still feeds Orca's script
project
cat > "$TMP/orca-statusline" <<'EOF'
#!/bin/sh
cat > "$STUB_LOG/orca-statusline-input"
EOF
SL='{"rate_limits":{"five_hour":{"used_percentage":91.5,"resets_at":1893456000},"seven_day":{"used_percentage":20,"resets_at":1893500000}}}'
out=$(printf '%s' "$SL" | AGENT_FALLBACK_ORCA_STATUSLINE="$TMP/orca-statusline" bash "$SCRIPT" statusline); ok "statusline: exit 0" "$?" 0
q="$XDG_STATE_HOME/agent-fallback/quota.json"
ok "statusline: five hour" "$(jq -r .five_hour "$q")" 91.5
ok "statusline: five hour reset" "$(jq -r .five_hour_reset "$q")" 1893456000
ok "statusline: seven day" "$(jq -r .seven_day "$q")" 20
ok "statusline: Orca gets the same input" "$(cat "$STUB_LOG/orca-statusline-input")" "$SL"
# A payload without limits keeps the last reading, and Orca's script may be absent
printf '{"model":{}}' | AGENT_FALLBACK_ORCA_STATUSLINE=/nonexistent bash "$SCRIPT" statusline; ok "statusline: no Orca script, exit 0" "$?" 0
ok "statusline: keeps the last reading" "$(jq -r .five_hour "$q")" 91.5
printf 'garbage' | AGENT_FALLBACK_ORCA_STATUSLINE=/nonexistent bash "$SCRIPT" statusline; ok "statusline: bad input, exit 0" "$?" 0
ok "statusline: bad input keeps the reading" "$(jq -r .five_hour "$q")" 91.5
# Only one window reported
printf '{"rate_limits":{"seven_day":{"used_percentage":33,"resets_at":1893500000}}}' | AGENT_FALLBACK_ORCA_STATUSLINE=/nonexistent bash "$SCRIPT" statusline
ok "statusline: one window" "$(jq -r .seven_day "$q")" 33

# A broken jq first on PATH, like a mise shim in an untrusted folder, doesn't disable anything
project; mkdir -p "$TMP/broken"; printf '#!/bin/sh\necho "mise ERROR not trusted" >&2\nexit 1\n' > "$TMP/broken/jq"; chmod +x "$TMP/broken/jq"
input StopFailure "$limit_text" | PATH="$TMP/broken:$PATH" ORCA_PANE_KEY=tab:1 bash "$SCRIPT" hook
ok "broken jq on PATH: still hands over" "$(launches)" 1

# Found in review: a hook killed mid-handover must not leave the lock held
project; cat > "$TMP/bin/orca-slow" <<'EOS'
#!/usr/bin/env bash
sleep 20
EOS
chmod +x "$TMP/bin/orca-slow"; input StopFailure "$limit_text" > "$TMP/in.json"
AGENT_FALLBACK_ORCA="$TMP/bin/orca-slow" ORCA_PANE_KEY=tab:1 bash "$SCRIPT" hook < "$TMP/in.json" & hook_pid=$!
sleep 1; kill -TERM "$hook_pid"; started=$(date +%s); wait "$hook_pid" 2>/dev/null
ok "killed hook: stops promptly" "$([ $(( $(date +%s) - started )) -lt 5 ] && echo y)" y
ok "killed hook: lock released" "$([ -e "$P/.git/agent-fallback/handover.lock" ] && echo y || echo n)" n
input StopFailure "$limit_text" | run; ok "killed hook: can retry" "$(launches)" 1

# Found in review: a failed launch on the near-limit path can be retried
project; quota 92; input PostToolUse | run >/dev/null; touch "$STUB_LOG/launch-fails"; input Stop | run; rm "$STUB_LOG/launch-fails"; : > "$STUB_LOG/launch"
out=$(input PostToolUse | run); has "near, failed launch: asks again" "$out" "additionalContext"
input Stop | run; ok "near, failed launch: retry works" "$(launches)" 1

# Found in review: another tab's end of turn doesn't use up the request
project; quota 92; input PostToolUse | run >/dev/null; input Stop '{"session_id":"s2"}' | run
ok "other tab's stop: no handover" "$(launches)" 0
input Stop | run; ok "asked tab's stop: hands over" "$(launches)" 1

# Found in review: a hard-limit handover clears a pending request
project; quota 92; input PostToolUse | run >/dev/null; input StopFailure "$limit_text" | run; before=$(notifies); input Stop | run
ok "after a limit handover: no stray notification" "$(notifies)" "$before"

# Found in review: the hard limit hands over even if you just typed, because Claude can't continue
project; input UserPromptSubmit | run; input StopFailure "$limit_text" | run; ok "just typed, hard limit: hands over" "$(launches)" 1

# Found in review: 'rate limit' wording isn't an allowance running out, but 'hit your limit' is
project; input StopFailure '{"error":"rate_limit","error_details":"You hit your rate limit"}' | run; ok "'hit your rate limit': no launch" "$(launches)" 0
project; input StopFailure '{"error":"rate_limit","last_assistant_message":"You have hit your limit"}' | run; ok "'hit your limit': launch" "$(launches)" 1

# Found in review: only PostToolUse may print, because stray output reaches Claude
project; quota 92
for e in UserPromptSubmit Stop; do out=$(input "$e" | run); ok "$e prints nothing" "$out" ""; done
out=$(input StopFailure "$limit_text" | run); ok "StopFailure prints nothing" "$out" ""

# Found in review: the brief says how old the handoff is, and a huge transcript stays bounded
project; mkdir -p "$P/memory"; echo note > "$P/memory/handoff.md"; touch -d '2020-03-04 10:00' "$P/memory/handoff.md"
python3 -I -c "
import json
line=json.dumps({'type':'assistant','message':{'role':'assistant','content':[{'type':'text','text':'FILLER'}]}})
open('$T','a').write((line+'\n')*30000)
open('$T','a').write(json.dumps({'type':'assistant','message':{'content':[{'type':'text','text':'LAST-MESSAGE'}]}})+'\n')"
input StopFailure "$limit_text" | run; c=$(cat "$(brief_of)")
has "brief: handoff date" "$c" "2020-03-04"; has "brief: task kept with a big transcript" "$c" "Build the invoice export"; has "brief: latest kept" "$c" "LAST-MESSAGE"

# --check reports missing wiring
project
good="$TMP/settings-good.json"; bad="$TMP/settings-bad.json"
jq -n --arg h 'bash "$HOME/.claude/hooks/agent-fallback.sh" hook' --arg s 'bash "$HOME/.claude/hooks/agent-fallback.sh" statusline' '{statusLine:{type:"command",command:$s},
  hooks:{StopFailure:[{matcher:"rate_limit",hooks:[{type:"command",command:$h}]}],
         Stop:[{hooks:[{type:"command",command:$h}]}],
         PostToolUse:[{hooks:[{type:"command",command:$h}]}],
         UserPromptSubmit:[{hooks:[{type:"command",command:$h}]}]}}' > "$good"
jq 'del(.hooks.Stop) | .statusLine.command="orca"' "$good" > "$bad"
AGENT_FALLBACK_SETTINGS="$good" bash "$SCRIPT" --check >/dev/null; ok "--check passes" "$?" 0
out=$(AGENT_FALLBACK_SETTINGS="$bad" bash "$SCRIPT" --check); ok "--check fails" "$?" 1
has "--check names the hook" "$out" "Stop"; has "--check names the status line" "$out" "status line"

echo "passed $pass, failed $fail"
[ "$fail" -eq 0 ]
