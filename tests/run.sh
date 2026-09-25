#!/bin/sh
# Test suite for showrunner/scripts/showrunner and install-hooks.sh.
# Run with: sh tests/run.sh   (and, when available: dash tests/run.sh)
set -u

# Isolate from the host's git config and hooks entirely.
export GIT_CONFIG_GLOBAL=/dev/null
export GIT_CONFIG_SYSTEM=/dev/null
unset GIT_CONFIG_NOSYSTEM 2>/dev/null || true
export GIT_AUTHOR_NAME=Test
export GIT_AUTHOR_EMAIL=test@example.com
export GIT_COMMITTER_NAME=Test
export GIT_COMMITTER_EMAIL=test@example.com
unset SHOWRUNNER_STATE 2>/dev/null || true
unset CLAUDE_PROJECT_DIR 2>/dev/null || true

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
SHOWRUNNER="$ROOT_DIR/showrunner/scripts/showrunner"
INSTALL_SH="$ROOT_DIR/showrunner/scripts/install-hooks.sh"

pass_count=0
fail_count=0
tmp_dirs=""

pass() {
  pass_count=$((pass_count + 1))
  printf 'PASS: %s\n' "$1"
}

fail() {
  fail_count=$((fail_count + 1))
  printf 'FAIL: %s\n' "$1"
  if [ -n "${2:-}" ]; then
    printf '%s\n' "$2" | sed 's/^/  /'
  fi
}

track_tmp() {
  tmp_dirs="$tmp_dirs
$1"
}

cleanup() {
  printf '%s\n' "$tmp_dirs" | while IFS= read -r d; do
    [ -n "$d" ] && [ -d "$d" ] && rm -rf "$d"
  done
}
trap cleanup EXIT

new_repo() {
  d=$(mktemp -d)
  track_tmp "$d"
  (
    cd "$d" || exit 1
    git init -q -b main
    git config user.email test@example.com
    git config user.name Test
    git commit -q --allow-empty -m "chore: init"
  ) >/dev/null 2>&1
  printf '%s\n' "$d"
}

# write_state REPO STAGE STEP0 FEATURE_BRANCH RELEASE_AUTHORIZED [EXTRA_WRITABLE] [RELEASE_PATTERNS]
write_state() {
  repo=$1
  stage=$2
  step0=$3
  fb=$4
  relauth=$5
  extra_writable=${6:-}
  release_patterns=${7:-}
  mkdir -p "$repo/.claude/showrunner"
  {
    printf '```yaml\n'
    printf 'schema_version: 1\n'
    printf 'project:\n'
    printf '  primary_branch: "main"\n'
    printf '  setup: "pending"\n'
    printf '  constitution: "pending"\n'
    printf 'active:\n'
    printf '  initiative: "none"\n'
    printf '  title: "none"\n'
    printf '  stage: "%s"\n' "$stage"
    printf '  status: "in-progress"\n'
    printf '  awaiting: "none"\n'
    printf '  feature_branch: "%s"\n' "$fb"
    printf '  step0_approved: "%s"\n' "$step0"
    printf '  fix_loops: 0\n'
    printf '  release_authorized: "%s"\n' "$relauth"
    printf '  resume: "none"\n'
    printf 'queue: []\n'
    printf 'parked: []\n'
    printf 'guard:\n'
    printf '  writable_before_build:\n'
    printf '    - ".claude/showrunner/*"\n'
    if [ -n "$extra_writable" ]; then
      printf '%s\n' "$extra_writable" | while IFS= read -r g; do
        [ -n "$g" ] && printf '    - "%s"\n' "$g"
      done
    fi
    if [ -n "$release_patterns" ]; then
      printf '  release_patterns:\n'
      printf '%s\n' "$release_patterns" | while IFS= read -r p; do
        [ -n "$p" ] && printf '    - "%s"\n' "$p"
      done
    else
      printf '  release_patterns: []\n'
    fi
    printf '```\n\n'
    printf '## Initiatives\n\n'
    printf '| Initiative | Title | Opened | Owner request (verbatim) | Stage | Status |\n'
    printf '| --- | --- | --- | --- | --- | --- |\n\n'
    printf '## Gate Ledger\n\n'
    printf '| # | Initiative | Stage | Outcome | Approver | Date | Artifact | Evidence |\n'
    printf '| --- | --- | --- | --- | --- | --- | --- | --- |\n'
  } > "$repo/.claude/showrunner/state.md"
}

guard_json_edit() {
  # $1=tool $2=file_path_key $3=path $4=cwd
  tool=$1
  key=$2
  path=$3
  cwd=$4
  printf '{"tool_name":"%s","tool_input":{"%s":"%s"},"cwd":"%s"}' "$tool" "$key" "$path" "$cwd"
}

guard_json_bash() {
  cmd=$1
  cwd=$2
  esc=$(printf '%s' "$cmd" | sed 's/\\/\\\\/g; s/"/\\"/g')
  printf '{"tool_name":"Bash","tool_input":{"command":"%s"},"cwd":"%s"}' "$esc" "$cwd"
}

# ===========================================================================
# 0. Syntax checks
# ===========================================================================

for f in "$ROOT_DIR/showrunner/scripts/showrunner" \
         "$ROOT_DIR/showrunner/scripts/hooks/pre-commit" \
         "$ROOT_DIR/showrunner/scripts/install-hooks.sh" \
         "$ROOT_DIR/tests/run.sh"; do
  if sh -n "$f" 2>/tmp/synerr.$$; then
    pass "sh -n $f"
  else
    fail "sh -n $f" "$(cat /tmp/synerr.$$)"
  fi
  rm -f /tmp/synerr.$$
done

if command -v dash >/dev/null 2>&1; then
  for f in "$ROOT_DIR/showrunner/scripts/showrunner" \
           "$ROOT_DIR/showrunner/scripts/hooks/pre-commit" \
           "$ROOT_DIR/showrunner/scripts/install-hooks.sh"; do
    if dash -n "$f" 2>/tmp/synerr.$$; then
      pass "dash -n $f"
    else
      fail "dash -n $f" "$(cat /tmp/synerr.$$)"
    fi
    rm -f /tmp/synerr.$$
  done
fi

# ===========================================================================
# 1. No ledger: everything allowed / silent
# ===========================================================================

repo=$(new_repo)

out=$(guard_json_edit Edit file_path "$repo/app.js" "$repo" | "$SHOWRUNNER" guard)
rc=$?
[ "$rc" -eq 0 ] && pass "no ledger: guard allows Edit" || fail "no ledger: guard allows Edit" "exit=$rc out=$out"

out=$(guard_json_bash "git commit --no-verify" "$repo" | "$SHOWRUNNER" guard)
rc=$?
[ "$rc" -eq 0 ] && pass "no ledger: guard allows Bash (even --no-verify)" || fail "no ledger: guard allows Bash" "exit=$rc out=$out"

(cd "$repo" && printf 'x' > product.txt && git add product.txt)
out=$(cd "$repo" && "$SHOWRUNNER" pre-commit 2>&1)
rc=$?
[ "$rc" -eq 0 ] && pass "no ledger: pre-commit allows" || fail "no ledger: pre-commit allows" "exit=$rc out=$out"
(cd "$repo" && git reset -q product.txt && rm -f product.txt)

out=$(cd "$repo" && "$SHOWRUNNER" context)
[ -z "$out" ] && pass "no ledger, no config: context is silent" || fail "no ledger, no config: context is silent" "out=[$out]"

mkdir -p "$repo/.claude/showrunner"
printf '# config\n' > "$repo/.claude/showrunner/config.md"
out=$(cd "$repo" && "$SHOWRUNNER" context)
case "$out" in
  *setup*) pass "config without state: context prints setup reminder" ;;
  *) fail "config without state: context prints setup reminder" "out=[$out]" ;;
esac
rm -f "$repo/.claude/showrunner/config.md"

# ===========================================================================
# 2. Product-edit rules (Edit/Write/MultiEdit/NotebookEdit)
# ===========================================================================

repo=$(new_repo)
write_state "$repo" spec no none no

out=$(guard_json_edit Edit file_path "$repo/.claude/showrunner/notes.md" "$repo" | "$SHOWRUNNER" guard)
rc=$?
[ "$rc" -eq 0 ] && pass "writable path allowed at spec" || fail "writable path allowed at spec" "exit=$rc out=$out"

out=$(guard_json_edit Edit file_path "$repo/src/app.js" "$repo" | "$SHOWRUNNER" guard 2>&1)
rc=$?
{ [ "$rc" -eq 2 ] && printf '%s' "$out" | grep -q "ShowRunner guard:"; } && pass "product path blocked at spec" || fail "product path blocked at spec" "exit=$rc out=$out"

(cd "$repo" && git branch feat/x >/dev/null)
write_state "$repo" build "digest123" feat/x no
(cd "$repo" && git checkout -q feat/x)
out=$(guard_json_edit Edit file_path "$repo/src/app.js" "$repo" | "$SHOWRUNNER" guard)
rc=$?
[ "$rc" -eq 0 ] && pass "product path allowed at build with step0 approved on feature branch" || fail "product path allowed at build with step0 approved on feature branch" "exit=$rc out=$out"

write_state "$repo" build no feat/x no
out=$(guard_json_edit Edit file_path "$repo/src/app.js" "$repo" | "$SHOWRUNNER" guard 2>&1)
rc=$?
[ "$rc" -eq 2 ] && pass "product path blocked at build when step0 is no" || fail "product path blocked at build when step0 is no" "exit=$rc out=$out"

write_state "$repo" build digest123 feat/other no
out=$(guard_json_edit Edit file_path "$repo/src/app.js" "$repo" | "$SHOWRUNNER" guard 2>&1)
rc=$?
[ "$rc" -eq 2 ] && pass "product path blocked at build on wrong branch" || fail "product path blocked at build on wrong branch" "exit=$rc out=$out"
(cd "$repo" && git checkout -q main)

outside=$(mktemp -d)
track_tmp "$outside"
out=$(guard_json_edit Edit file_path "$outside/random.txt" "$outside" | "$SHOWRUNNER" guard)
rc=$?
[ "$rc" -eq 0 ] && pass "path outside any repo allowed" || fail "path outside any repo allowed" "exit=$rc out=$out"

write_state "$repo" spec no none no
mkdir -p "$repo/subdir"
out=$(cd "$repo/subdir" && guard_json_edit Edit file_path "../src/app.js" "$repo/subdir" | "$SHOWRUNNER" guard 2>&1)
rc=$?
[ "$rc" -eq 2 ] && pass "relative path resolved via cwd" || fail "relative path resolved via cwd" "exit=$rc out=$out"

out=$(guard_json_edit NotebookEdit notebook_path "$repo/nb/analysis.ipynb" "$repo" | "$SHOWRUNNER" guard 2>&1)
rc=$?
[ "$rc" -eq 2 ] && pass "NotebookEdit notebook_path handled" || fail "NotebookEdit notebook_path handled" "exit=$rc out=$out"

# ===========================================================================
# 3. Bash rules
# ===========================================================================

repo=$(new_repo)
write_state "$repo" spec no none no "" "vercel --prod
npm publish"

out=$(guard_json_bash "git commit --no-verify -m x" "$repo" | "$SHOWRUNNER" guard 2>&1)
rc=$?
[ "$rc" -eq 2 ] && pass "git commit --no-verify blocked" || fail "git commit --no-verify blocked" "exit=$rc out=$out"

out=$(guard_json_bash "git commit -n -m x" "$repo" | "$SHOWRUNNER" guard 2>&1)
rc=$?
[ "$rc" -eq 2 ] && pass "git commit -n -m x blocked" || fail "git commit -n -m x blocked" "exit=$rc out=$out"

out=$(guard_json_bash 'git commit -m "use -n flag"' "$repo" | "$SHOWRUNNER" guard 2>&1)
rc=$?
[ "$rc" -eq 0 ] && pass 'git commit -m "use -n flag" NOT blocked' || fail 'git commit -m "use -n flag" NOT blocked' "exit=$rc out=$out"

out=$(guard_json_bash "git merge feat/x" "$repo" | "$SHOWRUNNER" guard 2>&1)
rc=$?
[ "$rc" -eq 2 ] && pass "git merge on main blocked outside merge stage" || fail "git merge on main blocked outside merge stage" "exit=$rc out=$out"

write_state "$repo" merge no none no "" "vercel --prod
npm publish"
out=$(guard_json_bash "git merge feat/x" "$repo" | "$SHOWRUNNER" guard 2>&1)
rc=$?
[ "$rc" -eq 0 ] && pass "git merge on main allowed in merge stage" || fail "git merge on main allowed in merge stage" "exit=$rc out=$out"

write_state "$repo" spec no none no "" "vercel --prod
npm publish"
out=$(guard_json_bash "git push --force origin main" "$repo" | "$SHOWRUNNER" guard 2>&1)
rc=$?
[ "$rc" -eq 2 ] && pass "git push --force origin main blocked" || fail "git push --force origin main blocked" "exit=$rc out=$out"

(cd "$repo" && git branch feat/x >/dev/null 2>&1 || true)
out=$(guard_json_bash "git push origin feat/x" "$repo" | "$SHOWRUNNER" guard 2>&1)
rc=$?
[ "$rc" -eq 0 ] && pass "git push origin feat/x allowed" || fail "git push origin feat/x allowed" "exit=$rc out=$out"

out=$(guard_json_bash "vercel --prod" "$repo" | "$SHOWRUNNER" guard 2>&1)
rc=$?
[ "$rc" -eq 2 ] && pass "release pattern blocked outside release stage" || fail "release pattern blocked outside release stage" "exit=$rc out=$out"

write_state "$repo" release no none no "" "vercel --prod
npm publish"
out=$(guard_json_bash "vercel --prod" "$repo" | "$SHOWRUNNER" guard 2>&1)
rc=$?
[ "$rc" -eq 2 ] && pass "release pattern blocked in release stage without authorization" || fail "release pattern blocked in release stage without authorization" "exit=$rc out=$out"

write_state "$repo" release no none yes "" "vercel --prod
npm publish"
out=$(guard_json_bash "vercel --prod" "$repo" | "$SHOWRUNNER" guard 2>&1)
rc=$?
[ "$rc" -eq 0 ] && pass "release pattern allowed in release stage with authorization" || fail "release pattern allowed in release stage with authorization" "exit=$rc out=$out"

write_state "$repo" spec no none no "" "vercel --prod
npm publish"
out=$(guard_json_bash "npm test && vercel --prod" "$repo" | "$SHOWRUNNER" guard 2>&1)
rc=$?
[ "$rc" -eq 2 ] && pass "chained npm test && vercel --prod detected" || fail "chained npm test && vercel --prod detected" "exit=$rc out=$out"

# ===========================================================================
# 4. pre-commit rules
# ===========================================================================

repo=$(new_repo)
write_state "$repo" spec no none no
(cd "$repo" && mkdir -p .claude/showrunner && printf 'note\n' >> .claude/showrunner/notes.md && git add .claude/showrunner/notes.md)
out=$(cd "$repo" && "$SHOWRUNNER" pre-commit 2>&1)
rc=$?
[ "$rc" -eq 0 ] && pass "docs-only commit on main allowed" || fail "docs-only commit on main allowed" "exit=$rc out=$out"
(cd "$repo" && git reset -q .claude/showrunner/notes.md)

(cd "$repo" && mkdir -p src && printf 'code\n' > src/app.js && git add src/app.js)
out=$(cd "$repo" && "$SHOWRUNNER" pre-commit 2>&1)
rc=$?
[ "$rc" -eq 1 ] && pass "product file on main rejected" || fail "product file on main rejected" "exit=$rc out=$out"
(cd "$repo" && git reset -q src/app.js)

(cd "$repo" && git checkout -q -b feat/y)
write_state "$repo" build no feat/y no
(cd "$repo" && git add src/app.js)
out=$(cd "$repo" && "$SHOWRUNNER" pre-commit 2>&1)
rc=$?
[ "$rc" -eq 1 ] && pass "product file on feature branch rejected before step0" || fail "product file on feature branch rejected before step0" "exit=$rc out=$out"

write_state "$repo" build digest123 feat/y no
out=$(cd "$repo" && "$SHOWRUNNER" pre-commit 2>&1)
rc=$?
[ "$rc" -eq 0 ] && pass "product file on feature branch allowed after step0" || fail "product file on feature branch allowed after step0" "exit=$rc out=$out"
(cd "$repo" && git reset -q src/app.js)
(cd "$repo" && git checkout -q main)

# feat/y never actually diverged (its product edit was only ever staged,
# then reset, never committed), so merging it would be a no-op. Build a
# genuinely divergent branch to merge instead.
(cd "$repo" && git checkout -q -b feat/merge-demo)
(cd "$repo" && printf 'demo\n' > merge-demo.txt && git add merge-demo.txt && git commit -q -m "feat: demo file for merge test")
(cd "$repo" && git checkout -q main)
# --no-commit forces git to stage the merge and stop, leaving MERGE_HEAD
# set, regardless of whether the merge would otherwise be conflict-free.
(cd "$repo" && git merge --no-ff --no-commit -q feat/merge-demo >/tmp/mergeerr.$$ 2>&1)
if (cd "$repo" && git rev-parse -q --verify MERGE_HEAD >/dev/null 2>&1); then
  write_state "$repo" merge no none no
  out=$(cd "$repo" && "$SHOWRUNNER" pre-commit 2>&1)
  rc=$?
  [ "$rc" -eq 0 ] && pass "merge conclusion on main with MERGE_HEAD allowed in merge stage" || fail "merge conclusion on main with MERGE_HEAD allowed in merge stage" "exit=$rc out=$out"
  (cd "$repo" && git merge --abort >/dev/null 2>&1 || true)
else
  fail "merge conclusion on main with MERGE_HEAD allowed in merge stage" "git merge --no-commit did not leave MERGE_HEAD set: $(cat /tmp/mergeerr.$$)"
fi
rm -f /tmp/mergeerr.$$

# ===========================================================================
# 5. check rules
# ===========================================================================

repo=$(new_repo)
write_state "$repo" setup no none no
out=$(cd "$repo" && "$SHOWRUNNER" check)
rc=$?
{ [ "$rc" -eq 0 ] && printf '%s' "$out" | grep -q "0 errors"; } && pass "clean ledger passes" || fail "clean ledger passes" "exit=$rc out=$out"

append_row() {
  # $1=repo $2=row (pipe-delimited already formatted)
  printf '%s\n' "$2" >> "$1/.claude/showrunner/state.md"
}

repo=$(new_repo)
write_state "$repo" spec no none no
sed -i 's/initiative: "none"/initiative: "I-001"/; s/title: "none"/title: "Demo"/' "$repo/.claude/showrunner/state.md"
append_row "$repo" '| 1 | I-001 | intake | passed | showrunner | 2026-01-01 | commit:abc123 | opened |'
out=$(cd "$repo" && "$SHOWRUNNER" check)
rc=$?
{ [ "$rc" -eq 1 ] && printf '%s' "$out" | grep -q "ERROR: missing predecessor: project setup"; } \
  && pass "missing predecessor error" || fail "missing predecessor error" "exit=$rc out=$out"

repo=$(new_repo)
write_state "$repo" intake no none no
append_row "$repo" '| 1 | project | setup | showrunner | showrunner | 2026-01-01 | commit:abc | ok |'
# (deliberately malformed column order above is avoided; correct row below)
: > "$repo/.claude/showrunner/state.md"
write_state "$repo" intake no none no
append_row "$repo" '| 1 | project | setup | passed | showrunner | 2026-01-01 | commit:abc | ok |'
append_row "$repo" '| 2 | project | constitution | passed | showrunner | 2026-01-01 | commit:abc | ok |'
sed -i 's/initiative: "none"/initiative: "I-001"/' "$repo/.claude/showrunner/state.md"
append_row "$repo" '| 3 | I-001 | roadmap | passed | showrunner | 2026-01-01 | commit:abc | "placed on roadmap" |'
out=$(cd "$repo" && "$SHOWRUNNER" check)
rc=$?
{ [ "$rc" -eq 1 ] && printf '%s' "$out" | grep -q "owner-gate stage roadmap closed by showrunner"; } \
  && pass "owner stage closed by showrunner error" || fail "owner stage closed by showrunner error" "exit=$rc out=$out"

repo=$(new_repo)
write_state "$repo" intake no none no
append_row "$repo" '| 1 | project | setup | passed | showrunner | 2026-01-01 | commit:abc | ok |'
append_row "$repo" '| 2 | project | constitution | approved | owner | 2026-01-01 | commit:abc | no quote here |'
out=$(cd "$repo" && "$SHOWRUNNER" check)
rc=$?
{ [ "$rc" -eq 1 ] && printf '%s' "$out" | grep -q "owner evidence must be a quoted"; } \
  && pass "owner row without quote error" || fail "owner row without quote error" "exit=$rc out=$out"

repo=$(new_repo)
write_state "$repo" design no none no
append_row "$repo" '| 1 | I-001 | spec | not-applicable | owner | 2026-01-01 | commit:abc | "n/a" |'
out=$(cd "$repo" && "$SHOWRUNNER" check)
rc=$?
{ [ "$rc" -eq 1 ] && printf '%s' "$out" | grep -q "not-applicable is only allowed for design or design-review"; } \
  && pass "not-applicable on spec error" || fail "not-applicable on spec error" "exit=$rc out=$out"

repo=$(new_repo)
write_state "$repo" build digest123 feat/x no
append_row "$repo" '| 1 | I-001 | verify | waived | owner | 2026-01-01 | commit:abc | "skip it" |'
out=$(cd "$repo" && "$SHOWRUNNER" check)
rc=$?
{ [ "$rc" -eq 1 ] && printf '%s' "$out" | grep -q "waived is not allowed for stage verify"; } \
  && pass "waived verify error" || fail "waived verify error" "exit=$rc out=$out"

repo=$(new_repo)
write_state "$repo" build no none no
sed -i 's/initiative: "none"/initiative: "I-001"/' "$repo/.claude/showrunner/state.md"
out=$(cd "$repo" && "$SHOWRUNNER" check)
rc=$?
{ [ "$rc" -eq 1 ] && printf '%s' "$out" | grep -q "without an approved Step 0 digest"; } \
  && pass "build without step0 error" || fail "build without step0 error" "exit=$rc out=$out"

repo=$(new_repo)
write_state "$repo" setup no none no
mkdir -p "$repo/docs"
printf 'hello\n' > "$repo/docs/readme.md"
hash=$(sha256sum "$repo/docs/readme.md" | awk '{print $1}')
append_row "$repo" "| 1 | project | setup | passed | showrunner | 2026-01-01 | docs/readme.md@sha256:$hash | ok |"
out=$(cd "$repo" && "$SHOWRUNNER" check)
rc=$?
{ [ "$rc" -eq 0 ] && printf '%s' "$out" | grep -q "0 errors"; } && pass "digest match adds no warning" || fail "digest match adds no warning" "exit=$rc out=$out"

printf 'changed\n' >> "$repo/docs/readme.md"
out=$(cd "$repo" && "$SHOWRUNNER" check)
rc=$?
{ [ "$rc" -eq 0 ] && printf '%s' "$out" | grep -q "WARN: artifact digest mismatch: docs/readme.md"; } \
  && pass "digest mismatch warns only (exit 0)" || fail "digest mismatch warns only (exit 0)" "exit=$rc out=$out"

repo=$(new_repo)
write_state "$repo" bogus-stage no none no
out=$(cd "$repo" && "$SHOWRUNNER" check)
rc=$?
{ [ "$rc" -eq 1 ] && printf '%s' "$out" | grep -q "is not a known stage"; } \
  && pass "unknown stage error" || fail "unknown stage error" "exit=$rc out=$out"

# ===========================================================================
# 6. Worktree resolution
# ===========================================================================

repo=$(new_repo)
write_state "$repo" spec no none no
wt=$(mktemp -d)
track_tmp "$wt"
rmdir "$wt"
(cd "$repo" && git branch wt-branch >/dev/null 2>&1 && git worktree add -q "$wt" wt-branch) >/dev/null 2>&1
if [ -d "$wt" ]; then
  out=$(cd "$wt" && "$SHOWRUNNER" context)
  case "$out" in
    ShowRunner:*) pass "state resolved from primary worktree inside a linked worktree" ;;
    *) fail "state resolved from primary worktree inside a linked worktree" "out=[$out]" ;;
  esac
  out=$(guard_json_edit Edit file_path "$wt/src/app.js" "$wt" | "$SHOWRUNNER" guard 2>&1)
  rc=$?
  [ "$rc" -eq 2 ] && pass "guard in linked worktree sees primary worktree's ledger" || fail "guard in linked worktree sees primary worktree's ledger" "exit=$rc out=$out"
else
  fail "state resolved from primary worktree inside a linked worktree" "git worktree add failed"
fi

# ===========================================================================
# 7. Installer
# ===========================================================================

proj=$(new_repo)
out=$("$INSTALL_SH" --project-root "$proj" 2>&1)
rc=$?
ok=1
[ "$rc" -eq 0 ] || ok=0
[ -x "$proj/.githooks/commit-msg" ] || ok=0
[ -x "$proj/.githooks/pre-commit" ] || ok=0
[ -x "$proj/.githooks/showrunner" ] || ok=0
[ -f "$proj/.githooks/showrunner-commit-prefixes" ] || ok=0
[ "$(git -C "$proj" config --get core.hooksPath)" = ".githooks" ] || ok=0
[ "$ok" -eq 1 ] && pass "install-hooks.sh sets hooksPath and copies 4 files executable" || fail "install-hooks.sh sets hooksPath and copies 4 files executable" "$out"

out=$("$INSTALL_SH" --project-root "$proj" --claude 2>&1)
rc=$?
{ [ "$rc" -eq 0 ] && [ -f "$proj/.claude/settings.json" ] && grep -q "/showrunner guard" "$proj/.claude/settings.json"; } \
  && pass "--claude creates settings.json" || fail "--claude creates settings.json" "$out"

if command -v jq >/dev/null 2>&1; then
  jq '. + {"otherSetting": true}, .hooks.PostToolUse = [{"hooks":[{"type":"command","command":"echo unrelated"}]}]' \
    "$proj/.claude/settings.json" > /tmp/merged.$$ 2>/dev/null || true
  # simpler: inject an unrelated key/hook directly
  tmp=$(mktemp)
  jq '.otherSetting = true | .hooks.PostToolUse = [{"hooks":[{"type":"command","command":"echo unrelated"}]}]' "$proj/.claude/settings.json" > "$tmp"
  mv "$tmp" "$proj/.claude/settings.json"
  rm -f /tmp/merged.$$

  before_count=$(jq '[.hooks.PreToolUse[] | select(.hooks[]?.command | test("/showrunner "))] | length' "$proj/.claude/settings.json")

  out=$("$INSTALL_SH" --project-root "$proj" --force --claude 2>&1)
  rc=$?
  after_count=$(jq '[.hooks.PreToolUse[] | select(.hooks[]?.command | test("/showrunner "))] | length' "$proj/.claude/settings.json")
  other_ok=$(jq -e '.otherSetting == true and (.hooks.PostToolUse[0].hooks[0].command == "echo unrelated")' "$proj/.claude/settings.json" >/dev/null 2>&1 && echo yes || echo no)

  { [ "$rc" -eq 0 ] && [ "$before_count" -eq 1 ] && [ "$after_count" -eq 1 ] && [ "$other_ok" = "yes" ]; } \
    && pass "re-run with --force --claude does not duplicate entries and preserves unrelated settings" \
    || fail "re-run with --force --claude does not duplicate entries and preserves unrelated settings" \
      "before=$before_count after=$after_count other_ok=$other_ok out=$out"
else
  fail "re-run with --force --claude does not duplicate entries and preserves unrelated settings" "jq not available in this environment"
fi

# ===========================================================================
# Summary
# ===========================================================================

printf '\n%d passed, %d failed\n' "$pass_count" "$fail_count"
if [ "$fail_count" -gt 0 ]; then
  exit 1
fi
exit 0
