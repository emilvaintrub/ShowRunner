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
INSTALL_PS1="$ROOT_DIR/showrunner/scripts/install-hooks.ps1"
SOURCES="$ROOT_DIR/showrunner/scripts/showrunner-sources"

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
         "$ROOT_DIR/showrunner/scripts/showrunner-sources" \
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
           "$ROOT_DIR/showrunner/scripts/showrunner-sources" \
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

# step0_approved is a digit-bearing key ("step0_approved"); check's active-key
# reader must not silently drop it (arc A-2 regression: an approved digest at
# build/verify/security/acceptance/merge must not be treated as unapproved).
repo=$(new_repo)
write_state "$repo" build digest123 feat/x no
out=$(cd "$repo" && "$SHOWRUNNER" check)
rc=$?
{ [ "$rc" -eq 0 ] && printf '%s' "$out" | grep -q "0 errors"; } \
  && pass "step0_approved digit key recognized: approved digest at build passes" \
  || fail "step0_approved digit key recognized: approved digest at build passes" "exit=$rc out=$out"

repo=$(new_repo)
write_state "$repo" verify digest123 feat/x no
out=$(cd "$repo" && "$SHOWRUNNER" check)
rc=$?
{ [ "$rc" -eq 0 ] && printf '%s' "$out" | grep -q "0 errors"; } \
  && pass "step0_approved digit key recognized: approved digest at verify passes" \
  || fail "step0_approved digit key recognized: approved digest at verify passes" "exit=$rc out=$out"

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
# 5b. Project stages P1-P5 (arc A-2): discovery, assessment, business-docs
# ===========================================================================

# Owner-required: discovery/assessment/business-docs closed by showrunner
# (outcome "passed") must error, like the other owner-gate project stages.
for stg in discovery assessment business-docs; do
  repo=$(new_repo)
  write_state "$repo" intake no none no
  append_row "$repo" "| 1 | project | $stg | passed | showrunner | 2026-01-01 | commit:abc | ok |"
  out=$(cd "$repo" && "$SHOWRUNNER" check)
  rc=$?
  { [ "$rc" -eq 1 ] && printf '%s' "$out" | grep -q "owner-gate stage $stg closed by showrunner"; } \
    && pass "owner-required: project $stg closed by showrunner errors" \
    || fail "owner-required: project $stg closed by showrunner errors" "exit=$rc out=$out"
done

# All five project stages need a terminal row under initiative "project"
# while an initiative is active, even one placed well past business-docs.
repo=$(new_repo)
write_state "$repo" roadmap no none no
sed -i 's/initiative: "none"/initiative: "I-001"/' "$repo/.claude/showrunner/state.md"
append_row "$repo" '| 1 | project | setup | passed | showrunner | 2026-01-01 | commit:abc | ok |'
append_row "$repo" '| 2 | project | discovery | approved | owner | 2026-01-01 | commit:abc | "go" |'
append_row "$repo" '| 3 | project | assessment | approved | owner | 2026-01-01 | commit:abc | "proceed" |'
append_row "$repo" '| 4 | project | constitution | approved | owner | 2026-01-01 | commit:abc | "ok" |'
append_row "$repo" '| 5 | I-001 | intake | passed | showrunner | 2026-01-01 | commit:abc | opened |'
out=$(cd "$repo" && "$SHOWRUNNER" check)
rc=$?
{ [ "$rc" -eq 1 ] && printf '%s' "$out" | grep -q "missing predecessor: project business-docs"; } \
  && pass "all five project stages required while an initiative is active (business-docs missing)" \
  || fail "all five project stages required while an initiative is active (business-docs missing)" "exit=$rc out=$out"

append_row "$repo" '| 6 | project | business-docs | approved | owner | 2026-01-01 | commit:abc | "none" |'
out=$(cd "$repo" && "$SHOWRUNNER" check)
rc=$?
{ [ "$rc" -eq 0 ] && printf '%s' "$out" | grep -q "0 errors"; } \
  && pass "all five project stages satisfied while an initiative is active" \
  || fail "all five project stages satisfied while an initiative is active" "exit=$rc out=$out"

# NEW: when active.stage is itself a project stage, every EARLIER project
# stage needs a terminal row, regardless of active.initiative.
repo=$(new_repo)
write_state "$repo" assessment no none no
out=$(cd "$repo" && "$SHOWRUNNER" check)
rc=$?
{ [ "$rc" -eq 1 ] \
    && printf '%s' "$out" | grep -q "missing predecessor: project setup" \
    && printf '%s' "$out" | grep -q "missing predecessor: project discovery"; } \
  && pass "project-stage predecessor check while a project stage is active (missing)" \
  || fail "project-stage predecessor check while a project stage is active (missing)" "exit=$rc out=$out"

repo=$(new_repo)
write_state "$repo" assessment no none no
append_row "$repo" '| 1 | project | setup | passed | showrunner | 2026-01-01 | commit:abc | ok |'
append_row "$repo" '| 2 | project | discovery | approved | owner | 2026-01-01 | commit:abc | "go" |'
out=$(cd "$repo" && "$SHOWRUNNER" check)
rc=$?
{ [ "$rc" -eq 0 ] && printf '%s' "$out" | grep -q "0 errors"; } \
  && pass "project-stage predecessor check while a project stage is active (satisfied)" \
  || fail "project-stage predecessor check while a project stage is active (satisfied)" "exit=$rc out=$out"

# context: project stages print "project <stage> (P<n>)"; initiative stages
# keep "<stage> (n/15)".
for pair in "setup:P1" "discovery:P2" "assessment:P3" "constitution:P4" "business-docs:P5"; do
  stg=${pair%%:*}
  pn=${pair##*:}
  repo=$(new_repo)
  write_state "$repo" "$stg" no none no
  out=$(cd "$repo" && "$SHOWRUNNER" context)
  case "$out" in
    *"project $stg ($pn)"*) pass "context labels project stage $stg as $pn" ;;
    *) fail "context labels project stage $stg as $pn" "out=[$out]" ;;
  esac
done

repo=$(new_repo)
write_state "$repo" spec no none no
out=$(cd "$repo" && "$SHOWRUNNER" context)
case "$out" in
  *"spec (3/15)"*) pass "context keeps <stage> (n/15) for initiative stages" ;;
  *) fail "context keeps <stage> (n/15) for initiative stages" "out=[$out]" ;;
esac

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
[ -x "$proj/.githooks/showrunner-sources" ] || ok=0
[ -f "$proj/.githooks/showrunner-commit-prefixes" ] || ok=0
[ "$(git -C "$proj" config --get core.hooksPath)" = ".githooks" ] || ok=0
[ "$ok" -eq 1 ] && pass "install-hooks.sh sets hooksPath and copies 5 files executable" || fail "install-hooks.sh sets hooksPath and copies 5 files executable" "$out"

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
# 7b. install-hooks.ps1 -ClaudeSettings under PowerShell (PS5.1 hardening)
# ===========================================================================

PWSH_BIN=${PWSH:-}
if [ -z "$PWSH_BIN" ] && [ -x /tmp/claude-0/pwsh/pwsh ]; then
  PWSH_BIN=/tmp/claude-0/pwsh/pwsh
fi

if [ -z "$PWSH_BIN" ] || [ ! -x "$PWSH_BIN" ] || ! command -v jq >/dev/null 2>&1; then
  printf 'SKIP: install-hooks.ps1 -ClaudeSettings pwsh regression (no $PWSH / /tmp/claude-0/pwsh/pwsh, or no jq)\n'
else
  pproj=$(new_repo)
  mkdir -p "$pproj/.claude"
  cat > "$pproj/.claude/settings.json" <<'EOF'
{
  "otherSetting": true,
  "hooks": {
    "PostToolUse": [
      { "hooks": [ { "type": "command", "command": "echo unrelated" } ] }
    ]
  }
}
EOF
  out=$("$PWSH_BIN" -NoProfile -File "$INSTALL_PS1" -ProjectRoot "$pproj" -ClaudeSettings 2>&1)
  rc1=$?
  out2=$("$PWSH_BIN" -NoProfile -File "$INSTALL_PS1" -ProjectRoot "$pproj" -Force -ClaudeSettings 2>&1)
  rc2=$?

  ok=1
  [ "$rc1" -eq 0 ] || ok=0
  [ "$rc2" -eq 0 ] || ok=0
  [ -x "$pproj/.githooks/commit-msg" ] || ok=0
  [ -x "$pproj/.githooks/pre-commit" ] || ok=0
  [ -x "$pproj/.githooks/showrunner" ] || ok=0
  [ -x "$pproj/.githooks/showrunner-sources" ] || ok=0
  [ -f "$pproj/.githooks/showrunner-commit-prefixes" ] || ok=0

  other_ok=$(jq -e '.otherSetting == true and (.hooks.PostToolUse[0].hooks[0].command == "echo unrelated")' "$pproj/.claude/settings.json" >/dev/null 2>&1 && echo yes || echo no)
  [ "$other_ok" = "yes" ] || ok=0

  pretooluse_count=$(jq '[.hooks.PreToolUse[] | select(.hooks[]?.command | test("showrunner"))] | length' "$pproj/.claude/settings.json")
  [ "$pretooluse_count" -eq 1 ] || ok=0

  arrays_ok=$(jq -e '[.hooks | to_entries[] | .value | type == "array"] | all' "$pproj/.claude/settings.json" >/dev/null 2>&1 && echo yes || echo no)
  [ "$arrays_ok" = "yes" ] || ok=0

  [ "$ok" -eq 1 ] \
    && pass "install-hooks.ps1 -ClaudeSettings (pwsh): 5 files, no duplicates, unrelated settings kept, hooks are arrays" \
    || fail "install-hooks.ps1 -ClaudeSettings (pwsh): 5 files, no duplicates, unrelated settings kept, hooks are arrays" \
      "rc1=$rc1 rc2=$rc2 other_ok=$other_ok pretooluse_count=$pretooluse_count arrays_ok=$arrays_ok out=$out out2=$out2"
fi

# ===========================================================================
# 8. Reviewer findings (arc A-1 fix round, verdict on tip 2d9ad37)
# ===========================================================================

# F1 (HIGH): chained `git switch main && git merge feat/x` from a feature
# branch must be treated as merging into the primary branch outside the
# merge stage.
repo=$(new_repo)
(cd "$repo" && git checkout -q -b feat/x)
write_state "$repo" spec no none no
out=$(guard_json_bash "git switch main && git merge feat/x" "$repo" | "$SHOWRUNNER" guard 2>&1)
rc=$?
[ "$rc" -eq 2 ] && pass "F1: chained switch-then-merge onto primary blocked outside merge stage" \
  || fail "F1: chained switch-then-merge onto primary blocked outside merge stage" "exit=$rc out=$out"

# F2 (HIGH): `git -C <dir> merge ...` must still be recognized as a merge,
# with the branch resolved from <dir>.
repo=$(new_repo)
write_state "$repo" spec no none no
out=$(guard_json_bash "git -C $repo merge feat/x" "$repo" | "$SHOWRUNNER" guard 2>&1)
rc=$?
[ "$rc" -eq 2 ] && pass "F2: git -C DIR merge onto primary blocked (global-option normalization)" \
  || fail "F2: git -C DIR merge onto primary blocked (global-option normalization)" "exit=$rc out=$out"

# F3 (HIGH): a `+<primary>` refspec (no colon) is still a force push to the
# primary branch.
repo=$(new_repo)
(cd "$repo" && git checkout -q -b feat/x)
write_state "$repo" spec no none no
out=$(guard_json_bash "git push origin +main" "$repo" | "$SHOWRUNNER" guard 2>&1)
rc=$?
[ "$rc" -eq 2 ] && pass "F3: git push origin +main blocked from a non-primary branch" \
  || fail "F3: git push origin +main blocked from a non-primary branch" "exit=$rc out=$out"

# F4 (MEDIUM): a symlinked cwd/file_path (e.g. macOS /tmp -> /private/tmp)
# must not produce a false block on an otherwise-writable path.
repo=$(new_repo)
write_state "$repo" spec no none no
linkdir="${repo}-symlink"
ln -s "$repo" "$linkdir"
track_tmp "$linkdir"
out=$(guard_json_edit Write file_path "$linkdir/.claude/showrunner/notes.md" "$linkdir" | "$SHOWRUNNER" guard 2>&1)
rc=$?
[ "$rc" -eq 0 ] && pass "F4: writable path reached through a symlinked worktree path is allowed" \
  || fail "F4: writable path reached through a symlinked worktree path is allowed" "exit=$rc out=$out"

# F5 (MEDIUM): release-pattern matching must see through a leading
# environment-assignment prefix.
repo=$(new_repo)
write_state "$repo" spec no none no "" "vercel --prod"
out=$(guard_json_bash "FOO=1 vercel --prod" "$repo" | "$SHOWRUNNER" guard 2>&1)
rc=$?
[ "$rc" -eq 2 ] && pass "F5a: release pattern recognized through a leading FOO=1 env assignment" \
  || fail "F5a: release pattern recognized through a leading FOO=1 env assignment" "exit=$rc out=$out"

out=$(guard_json_bash "env FOO=1 vercel --prod" "$repo" | "$SHOWRUNNER" guard 2>&1)
rc=$?
[ "$rc" -eq 2 ] && pass "F5b: release pattern recognized through a leading env FOO=1 wrapper" \
  || fail "F5b: release pattern recognized through a leading env FOO=1 wrapper" "exit=$rc out=$out"

# F6 (LOW): context must not print a literal "none" initiative/title.
repo=$(new_repo)
write_state "$repo" spec no none no
out=$(cd "$repo" && "$SHOWRUNNER" context)
case "$out" in
  "ShowRunner: no active initiative; project stage"*) pass "F6: context prints 'no active initiative' when active.initiative is none" ;;
  *) fail "F6: context prints 'no active initiative' when active.initiative is none" "out=[$out]" ;;
esac

# F7 (LOW): a showrunner-only stage (intake/step0/build/verify) closed by an
# owner outcome must be flagged.
repo=$(new_repo)
write_state "$repo" intake no none no
append_row "$repo" '| 1 | I-001 | intake | approved | owner | 2026-01-01 | commit:abc | "go" |'
out=$(cd "$repo" && "$SHOWRUNNER" check)
rc=$?
{ [ "$rc" -eq 1 ] && printf '%s' "$out" | grep -q "showrunner-owned stage intake closed by owner"; } \
  && pass "F7: showrunner-only stage closed by an owner outcome is an error" \
  || fail "F7: showrunner-only stage closed by an owner outcome is an error" "exit=$rc out=$out"

# ===========================================================================
# 9. Reviewer findings round 2 (verdict on tip c615713)
# ===========================================================================

# F8 (HIGH): a git config bypass that disables hooks (core.hooksPath) must
# be blocked exactly like --no-verify, in all its forms, while a bare read
# of the setting stays allowed.
repo=$(new_repo)
write_state "$repo" spec no none no

out=$(guard_json_bash "git config --get core.hooksPath" "$repo" | "$SHOWRUNNER" guard 2>&1)
rc=$?
[ "$rc" -eq 0 ] && pass "F8: git config --get core.hooksPath (read) allowed" \
  || fail "F8: git config --get core.hooksPath (read) allowed" "exit=$rc out=$out"

out=$(guard_json_bash "git config core.hooksPath" "$repo" | "$SHOWRUNNER" guard 2>&1)
rc=$?
[ "$rc" -eq 0 ] && pass "F8: git config core.hooksPath (bare read, no value) allowed" \
  || fail "F8: git config core.hooksPath (bare read, no value) allowed" "exit=$rc out=$out"

out=$(guard_json_bash "git config core.hooksPath /dev/null" "$repo" | "$SHOWRUNNER" guard 2>&1)
rc=$?
[ "$rc" -eq 2 ] && pass "F8: git config core.hooksPath VALUE (set, old syntax) blocked" \
  || fail "F8: git config core.hooksPath VALUE (set, old syntax) blocked" "exit=$rc out=$out"

out=$(guard_json_bash "git config set core.hooksPath /dev/null" "$repo" | "$SHOWRUNNER" guard 2>&1)
rc=$?
[ "$rc" -eq 2 ] && pass "F8: git config set core.hooksPath VALUE (new syntax) blocked" \
  || fail "F8: git config set core.hooksPath VALUE (new syntax) blocked" "exit=$rc out=$out"

out=$(guard_json_bash "git config --unset core.hooksPath" "$repo" | "$SHOWRUNNER" guard 2>&1)
rc=$?
[ "$rc" -eq 2 ] && pass "F8: git config --unset core.hooksPath blocked" \
  || fail "F8: git config --unset core.hooksPath blocked" "exit=$rc out=$out"

out=$(guard_json_bash "git config --local core.hooksPath /dev/null" "$repo" | "$SHOWRUNNER" guard 2>&1)
rc=$?
[ "$rc" -eq 2 ] && pass "F8: git config --local core.hooksPath VALUE blocked" \
  || fail "F8: git config --local core.hooksPath VALUE blocked" "exit=$rc out=$out"

out=$(guard_json_bash "git -c core.hooksPath=/dev/null commit -m x" "$repo" | "$SHOWRUNNER" guard 2>&1)
rc=$?
[ "$rc" -eq 2 ] && pass "F8: git -c core.hooksPath=... commit blocked" \
  || fail "F8: git -c core.hooksPath=... commit blocked" "exit=$rc out=$out"

out=$(guard_json_bash "git -c core.hookspath=/dev/null log" "$repo" | "$SHOWRUNNER" guard 2>&1)
rc=$?
[ "$rc" -eq 2 ] && pass "F8: git -c core.hookspath=... blocked for any subcommand (case-insensitive key)" \
  || fail "F8: git -c core.hookspath=... blocked for any subcommand (case-insensitive key)" "exit=$rc out=$out"

out=$(guard_json_bash "GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=core.hooksPath GIT_CONFIG_VALUE_0=/dev/null git commit -m x" "$repo" | "$SHOWRUNNER" guard 2>&1)
rc=$?
[ "$rc" -eq 2 ] && pass "F8: GIT_CONFIG_KEY_n=core.hooksPath env override blocked" \
  || fail "F8: GIT_CONFIG_KEY_n=core.hooksPath env override blocked" "exit=$rc out=$out"

out=$(guard_json_bash "GIT_CONFIG_PARAMETERS='core.hooksPath=/dev/null' git commit -m x" "$repo" | "$SHOWRUNNER" guard 2>&1)
rc=$?
[ "$rc" -eq 2 ] && pass "F8: GIT_CONFIG_PARAMETERS=...hooksPath... env override blocked" \
  || fail "F8: GIT_CONFIG_PARAMETERS=...hooksPath... env override blocked" "exit=$rc out=$out"

# F9 (LOW): effective-branch tracking must key off the resolved directory,
# not just the cwd, so a -C-scoped checkout/switch updates the branch a
# later -C-scoped segment targeting the same repo sees.
repo=$(new_repo)
(cd "$repo" && git checkout -q -b feat/x)
write_state "$repo" spec no none no
out=$(guard_json_bash "git -C $repo checkout main && git -C $repo merge feat/x" "$repo" | "$SHOWRUNNER" guard 2>&1)
rc=$?
[ "$rc" -eq 2 ] && pass "F9: -C-scoped checkout-then-merge onto primary blocked (per-directory effective branch)" \
  || fail "F9: -C-scoped checkout-then-merge onto primary blocked (per-directory effective branch)" "exit=$rc out=$out"

# ===========================================================================
# 10. showrunner-sources (arc A-2 research linter)
# ===========================================================================

new_plain_repo() {
  d=$(mktemp -d)
  track_tmp "$d"
  (cd "$d" && git init -q -b main && git config user.email test@example.com && git config user.name Test) >/dev/null 2>&1
  printf '%s\n' "$d"
}

empty_registers() {
  # $1=path
  cat > "$1" <<'REGEOF'
## Sources

| ID | Title | Publisher | URL | Published | Accessed | Type | Excerpt |
| --- | --- | --- | --- | --- | --- | --- | --- |

## Search Log

| ID | Date | Tool | Query | Results opened | Notes |
| --- | --- | --- | --- | --- | --- |

## Assumptions

| ID | Assumption | Value | Rationale | Based on | Sensitivity | Owner status |
| --- | --- | --- | --- | --- | --- | --- |
REGEOF
}

one_source_registers() {
  # $1=path $2=accessed date (default: today via SHOWRUNNER_TODAY-friendly recent date)
  accessed=${2:-2026-09-01}
  cat > "$1" <<REGEOF
## Sources

| ID | Title | Publisher | URL | Published | Accessed | Type | Excerpt |
| --- | --- | --- | --- | --- | --- | --- | --- |
| S1 | Pricing page | Acme | https://acme.example/pricing | 2025 | $accessed | primary | "Plans start at \$12/user/month" |
| S4 | Market report | Analyst Co | https://analyst.example/report | 2025 | $accessed | secondary | "3.0M households" |

## Search Log

| ID | Date | Tool | Query | Results opened | Notes |
| --- | --- | --- | --- | --- | --- |

## Assumptions

| ID | Assumption | Value | Rationale | Based on | Sensitivity | Owner status |
| --- | --- | --- | --- | --- | --- | --- |
| A1 | Growth rate | 20% | Analyst consensus | judgment | swings +/-10% | proposed |
REGEOF
}

# --- clean doc passes -------------------------------------------------------

repo=$(new_plain_repo)
one_source_registers "$repo/registers.md"
cat > "$repo/doc.md" <<'EOF'
# Assessment

Acme's plans start at $12/user/month [S1].

Growth is projected at 20% next year [ASSUMPTION A1].
EOF
out=$("$SOURCES" lint --registers "$repo/registers.md" "$repo/doc.md" 2>&1)
rc=$?
{ [ "$rc" -eq 0 ] && printf '%s' "$out" | grep -q "0 errors, 0 warnings"; } \
  && pass "clean labeled doc passes" || fail "clean labeled doc passes" "exit=$rc out=$out"

# --- untagged currency / percent / magnitude: table cell and prose ---------

repo=$(new_plain_repo)
one_source_registers "$repo/registers.md"
cat > "$repo/tbl.md" <<'EOF'
| Segment | Revenue |
| --- | --- |
| Enterprise | $1,200 |
EOF
out=$("$SOURCES" lint --registers "$repo/registers.md" "$repo/tbl.md" 2>&1)
rc=$?
{ [ "$rc" -eq 1 ] && printf '%s' "$out" | grep -q "figure without a label in table cell"; } \
  && pass "untagged currency in a table cell errors" || fail "untagged currency in a table cell errors" "exit=$rc out=$out"

cat > "$repo/pct.md" <<'EOF'
Growth is projected at 20% next year.
EOF
out=$("$SOURCES" lint --registers "$repo/registers.md" "$repo/pct.md" 2>&1)
rc=$?
{ [ "$rc" -eq 1 ] && printf '%s' "$out" | grep -q "figure without a label"; } \
  && pass "untagged percent in prose errors" || fail "untagged percent in prose errors" "exit=$rc out=$out"

cat > "$repo/mag.md" <<'EOF'
The market is estimated at 3.2M households.
EOF
out=$("$SOURCES" lint --registers "$repo/registers.md" "$repo/mag.md" 2>&1)
rc=$?
{ [ "$rc" -eq 1 ] && printf '%s' "$out" | grep -q "figure without a label"; } \
  && pass "untagged magnitude (3.2M) in prose errors" || fail "untagged magnitude (3.2M) in prose errors" "exit=$rc out=$out"

# --- plain integer / year not flagged ---------------------------------------

repo=$(new_plain_repo)
one_source_registers "$repo/registers.md"
cat > "$repo/plain.md" <<'EOF'
We interviewed 42 customers in 2024.
EOF
out=$("$SOURCES" lint --registers "$repo/registers.md" "$repo/plain.md" 2>&1)
rc=$?
{ [ "$rc" -eq 0 ] && printf '%s' "$out" | grep -q "0 errors"; } \
  && pass "plain integer and year are not figures" || fail "plain integer and year are not figures" "exit=$rc out=$out"

# --- <placeholder> ignored ---------------------------------------------------

cat > "$repo/placeholder.md" <<'EOF'
Template example: revenue is <45%> of total.
EOF
out=$("$SOURCES" lint --registers "$repo/registers.md" "$repo/placeholder.md" 2>&1)
rc=$?
{ [ "$rc" -eq 0 ] && printf '%s' "$out" | grep -q "0 errors"; } \
  && pass "placeholder text inside <...> is ignored" || fail "placeholder text inside <...> is ignored" "exit=$rc out=$out"

# --- fenced code and HTML comments ignored ----------------------------------

cat > "$repo/fenced.md" <<'EOF'
Some prose here.

```
This has $50 with no label but is code.
```

<!-- This has 30% inside a comment, no label -->

More prose without figures.
EOF
out=$("$SOURCES" lint --registers "$repo/registers.md" "$repo/fenced.md" 2>&1)
rc=$?
{ [ "$rc" -eq 0 ] && printf '%s' "$out" | grep -q "0 errors"; } \
  && pass "fenced code blocks and HTML comments are not scanned" || fail "fenced code blocks and HTML comments are not scanned" "exit=$rc out=$out"

# --- label in a different sentence does not count ---------------------------

cat > "$repo/diffsent.md" <<'EOF'
Revenue is $5M. This claim comes from the pricing page [S1].
EOF
out=$("$SOURCES" lint --registers "$repo/registers.md" "$repo/diffsent.md" 2>&1)
rc=$?
{ [ "$rc" -eq 1 ] && printf '%s' "$out" | grep -q "figure without a label"; } \
  && pass "a label in a different sentence does not cover an earlier figure" \
  || fail "a label in a different sentence does not cover an earlier figure" "exit=$rc out=$out"

# --- paragraph/list wrap correction (architect correction on arc A-2) ------

cat > "$repo/wrap_a.md" <<'EOF'
Acme's plans start at $12/user/month
[S1].
EOF
out=$("$SOURCES" lint --registers "$repo/registers.md" "$repo/wrap_a.md" 2>&1)
rc=$?
{ [ "$rc" -eq 0 ] && printf '%s' "$out" | grep -q "0 errors"; } \
  && pass "wrap (a): figure on one line, label on the next line of the same sentence PASSES" \
  || fail "wrap (a): figure on one line, label on the next line of the same sentence PASSES" "exit=$rc out=$out"

cat > "$repo/wrap_b.md" <<'EOF'
Acme's plans start at $12/user/month. See details [S1].
EOF
out=$("$SOURCES" lint --registers "$repo/registers.md" "$repo/wrap_b.md" 2>&1)
rc=$?
{ [ "$rc" -eq 1 ] && printf '%s' "$out" | grep -q "wrap_b.md:1: figure without a label"; } \
  && pass "wrap (b): figure in one sentence, label only in the next sentence FAILS (same line)" \
  || fail "wrap (b): figure in one sentence, label only in the next sentence FAILS (same line)" "exit=$rc out=$out"

cat > "$repo/wrap_c.md" <<'EOF'
- Acme's plans start at $12/user/month
  [S1].
EOF
out=$("$SOURCES" lint --registers "$repo/registers.md" "$repo/wrap_c.md" 2>&1)
rc=$?
{ [ "$rc" -eq 0 ] && printf '%s' "$out" | grep -q "0 errors"; } \
  && pass "wrap (c): a list item wrapped onto a continuation line with the label there PASSES" \
  || fail "wrap (c): a list item wrapped onto a continuation line with the label there PASSES" "exit=$rc out=$out"

cat > "$repo/wrap_d.md" <<'EOF'
- Acme's plans start at $12/user/month.
- See details [S1].
EOF
out=$("$SOURCES" lint --registers "$repo/registers.md" "$repo/wrap_d.md" 2>&1)
rc=$?
{ [ "$rc" -eq 1 ] && printf '%s' "$out" | grep -q "wrap_d.md:1: figure without a label"; } \
  && pass "wrap (d): two separate list items - figure in the first, label in the second - FAILS" \
  || fail "wrap (d): two separate list items - figure in the first, label in the second - FAILS" "exit=$rc out=$out"

# --- bracket-list labels -----------------------------------------------------

cat > "$repo/bl1.md" <<'EOF'
Revenue is $5M combining two sources [S1, S4].
EOF
out=$("$SOURCES" lint --registers "$repo/registers.md" "$repo/bl1.md" 2>&1)
rc=$?
{ [ "$rc" -eq 0 ] && printf '%s' "$out" | grep -q "0 errors"; } \
  && pass "bracket list [S1, S4] accepted" || fail "bracket list [S1, S4] accepted" "exit=$rc out=$out"

cat > "$repo/bl2.md" <<'EOF'
Revenue is $5M combining two sources [S1,S4].
EOF
out=$("$SOURCES" lint --registers "$repo/registers.md" "$repo/bl2.md" 2>&1)
rc=$?
{ [ "$rc" -eq 0 ] && printf '%s' "$out" | grep -q "0 errors"; } \
  && pass "bracket list [S1,S4] (no space) accepted" || fail "bracket list [S1,S4] (no space) accepted" "exit=$rc out=$out"

# --- DERIVED with nested labels ---------------------------------------------

cat > "$repo/derived.md" <<'EOF'
SAM 1.2M households [DERIVED: 3.0M [S4] x 40% [ASSUMPTION A1]].
EOF
out=$("$SOURCES" lint --registers "$repo/registers.md" "$repo/derived.md" 2>&1)
rc=$?
{ [ "$rc" -eq 0 ] && printf '%s' "$out" | grep -q "0 errors"; } \
  && pass "DERIVED label with nested S/A ids is accepted and ids are collected" \
  || fail "DERIVED label with nested S/A ids is accepted and ids are collected" "exit=$rc out=$out"

# --- missing S/A/Q id errors --------------------------------------------------

cat > "$repo/missingid.md" <<'EOF'
Revenue is $5M [S9].
EOF
out=$("$SOURCES" lint --registers "$repo/registers.md" "$repo/missingid.md" 2>&1)
rc=$?
{ [ "$rc" -eq 1 ] && printf '%s' "$out" | grep -q "cited id S9 not found in the registers"; } \
  && pass "citing an unknown S id errors" || fail "citing an unknown S id errors" "exit=$rc out=$out"

cat > "$repo/missingq.md" <<'EOF'
No evidence found in web search [search log Q9].
EOF
out=$("$SOURCES" lint --registers "$repo/registers.md" "$repo/missingq.md" 2>&1)
rc=$?
{ [ "$rc" -eq 1 ] && printf '%s' "$out" | grep -q "cited id Q9 not found in the registers"; } \
  && pass "a 'search log Q<n>' reference to an unknown id errors" \
  || fail "a 'search log Q<n>' reference to an unknown id errors" "exit=$rc out=$out"

# --- register row structural errors -----------------------------------------

repo=$(new_plain_repo)
cat > "$repo/regs_bad.md" <<'EOF'
## Sources

| ID | Title | Publisher | URL | Published | Accessed | Type | Excerpt |
| --- | --- | --- | --- | --- | --- | --- | --- |
| S1 | A | Pub |  | 2025 |  | primary |  |

## Search Log

| ID | Date | Tool | Query | Results opened | Notes |
| --- | --- | --- | --- | --- | --- |

## Assumptions

| ID | Assumption | Value | Rationale | Based on | Sensitivity | Owner status |
| --- | --- | --- | --- | --- | --- | --- |
EOF
printf 'x\n' > "$repo/noop.md"
out=$("$SOURCES" lint --registers "$repo/regs_bad.md" "$repo/noop.md" 2>&1)
rc=$?
{ [ "$rc" -eq 1 ] \
    && printf '%s' "$out" | grep -q "missing a valid Accessed date" \
    && printf '%s' "$out" | grep -q "URL must be http(s) unless Type is owner" \
    && printf '%s' "$out" | grep -q "excerpt must be a non-empty quoted string"; } \
  && pass "a Sources row missing URL/Accessed/excerpt errors on each" \
  || fail "a Sources row missing URL/Accessed/excerpt errors on each" "exit=$rc out=$out"

# --- owner-type row with a file path is OK ----------------------------------

repo=$(new_plain_repo)
cat > "$repo/regs_owner.md" <<'EOF'
## Sources

| ID | Title | Publisher | URL | Published | Accessed | Type | Excerpt |
| --- | --- | --- | --- | --- | --- | --- | --- |
| S1 | Internal deck | Owner | docs/owner-notes.pdf | 2025 | 2026-09-01 | owner | "internal figure" |

## Search Log

| ID | Date | Tool | Query | Results opened | Notes |
| --- | --- | --- | --- | --- | --- |

## Assumptions

| ID | Assumption | Value | Rationale | Based on | Sensitivity | Owner status |
| --- | --- | --- | --- | --- | --- | --- |
EOF
printf 'x\n' > "$repo/noop.md"
out=$("$SOURCES" lint --registers "$repo/regs_owner.md" "$repo/noop.md" 2>&1)
rc=$?
{ [ "$rc" -eq 0 ] && printf '%s' "$out" | grep -q "0 errors"; } \
  && pass "owner-type Sources row with a file path in URL is OK" \
  || fail "owner-type Sources row with a file path in URL is OK" "exit=$rc out=$out"

# --- duplicate id errors -----------------------------------------------------

repo=$(new_plain_repo)
cat > "$repo/regs_dup.md" <<'EOF'
## Sources

| ID | Title | Publisher | URL | Published | Accessed | Type | Excerpt |
| --- | --- | --- | --- | --- | --- | --- | --- |
| S1 | A | Pub | https://example.com/a | 2025 | 2026-09-01 | primary | "hello" |
| S1 | B | Pub | https://example.com/b | 2025 | 2026-09-01 | primary | "world" |

## Search Log

| ID | Date | Tool | Query | Results opened | Notes |
| --- | --- | --- | --- | --- | --- |

## Assumptions

| ID | Assumption | Value | Rationale | Based on | Sensitivity | Owner status |
| --- | --- | --- | --- | --- | --- | --- |
EOF
printf 'x\n' > "$repo/noop.md"
out=$("$SOURCES" lint --registers "$repo/regs_dup.md" "$repo/noop.md" 2>&1)
rc=$?
{ [ "$rc" -eq 1 ] && printf '%s' "$out" | grep -q "duplicate Sources id S1"; } \
  && pass "a duplicate Sources id errors" || fail "a duplicate Sources id errors" "exit=$rc out=$out"

# --- stale source warns (SHOWRUNNER_TODAY) ----------------------------------

repo=$(new_plain_repo)
one_source_registers "$repo/registers.md" "2026-01-01"
cat > "$repo/doc.md" <<'EOF'
Acme's plans start at $12/user/month [S1].
EOF
out=$(SHOWRUNNER_TODAY=2027-06-01 "$SOURCES" lint --registers "$repo/registers.md" "$repo/doc.md" 2>&1)
rc=$?
{ [ "$rc" -eq 0 ] && printf '%s' "$out" | grep -q "WARN:.*cited source S1 was accessed 2026-01-01, older than the freshness window"; } \
  && pass "a stale cited source warns (via SHOWRUNNER_TODAY)" \
  || fail "a stale cited source warns (via SHOWRUNNER_TODAY)" "exit=$rc out=$out"

out=$(SHOWRUNNER_TODAY=2026-02-01 "$SOURCES" lint --registers "$repo/registers.md" "$repo/doc.md" 2>&1)
rc=$?
{ [ "$rc" -eq 0 ] && printf '%s' "$out" | grep -q "0 errors, 0 warnings"; } \
  && pass "a fresh cited source does not warn (via SHOWRUNNER_TODAY)" \
  || fail "a fresh cited source does not warn (via SHOWRUNNER_TODAY)" "exit=$rc out=$out"

# --- EVIDENCE PENDING warns --------------------------------------------------

repo=$(new_plain_repo)
one_source_registers "$repo/registers.md"
cat > "$repo/pending.md" <<'EOF'
Market size is unknown. EVIDENCE PENDING for competitor pricing.
EVIDENCE PENDING also for regulatory scope.
EOF
out=$("$SOURCES" lint --registers "$repo/registers.md" "$repo/pending.md" 2>&1)
rc=$?
{ [ "$rc" -eq 0 ] \
    && printf '%s' "$out" | grep -q "pending.md:1: EVIDENCE PENDING marker found" \
    && printf '%s' "$out" | grep -q "pending.md:2: EVIDENCE PENDING marker found"; } \
  && pass "each EVIDENCE PENDING occurrence warns with file:line" \
  || fail "each EVIDENCE PENDING occurrence warns with file:line" "exit=$rc out=$out"

# --- --fetch via SHOWRUNNER_FETCH_CMD stub ----------------------------------

repo=$(new_plain_repo)
one_source_registers "$repo/registers.md"
cat > "$repo/doc.md" <<'EOF'
Acme's plans start at $12/user/month [S1].
EOF

cat > "$repo/fetch_ok.sh" <<'EOF'
#!/bin/sh
printf 'Our pricing page says: Plans start at $12/user/month for everyone.'
EOF
chmod +x "$repo/fetch_ok.sh"
out=$(SHOWRUNNER_FETCH_CMD="$repo/fetch_ok.sh" "$SOURCES" lint --registers "$repo/registers.md" --fetch "$repo/doc.md" 2>&1)
rc=$?
{ [ "$rc" -eq 0 ] && printf '%s' "$out" | grep -q "| S1 | https://acme.example/pricing | confirmed |"; } \
  && pass "--fetch via stub: confirmed when the excerpt is present" \
  || fail "--fetch via stub: confirmed when the excerpt is present" "exit=$rc out=$out"

cat > "$repo/fetch_nf.sh" <<'EOF'
#!/bin/sh
printf 'Totally unrelated content.'
EOF
chmod +x "$repo/fetch_nf.sh"
out=$(SHOWRUNNER_FETCH_CMD="$repo/fetch_nf.sh" "$SOURCES" lint --registers "$repo/registers.md" --fetch "$repo/doc.md" 2>&1)
rc=$?
{ [ "$rc" -eq 0 ] && printf '%s' "$out" | grep -q "| S1 | https://acme.example/pricing | excerpt-not-found |"; } \
  && pass "--fetch via stub: excerpt-not-found when the page loads without the excerpt" \
  || fail "--fetch via stub: excerpt-not-found when the page loads without the excerpt" "exit=$rc out=$out"

cat > "$repo/fetch_fail.sh" <<'EOF'
#!/bin/sh
exit 1
EOF
chmod +x "$repo/fetch_fail.sh"
out=$(SHOWRUNNER_FETCH_CMD="$repo/fetch_fail.sh" "$SOURCES" lint --registers "$repo/registers.md" --fetch "$repo/doc.md" 2>&1)
rc=$?
{ [ "$rc" -eq 0 ] && printf '%s' "$out" | grep -q "| S1 | https://acme.example/pricing | unreachable |"; } \
  && pass "--fetch via stub: unreachable when the fetch command fails" \
  || fail "--fetch via stub: unreachable when the fetch command fails" "exit=$rc out=$out"

# --fetch never turns into an ERROR / never affects the error count.
out=$(SHOWRUNNER_FETCH_CMD="$repo/fetch_fail.sh" "$SOURCES" lint --registers "$repo/registers.md" --fetch "$repo/doc.md" 2>&1)
rc=$?
{ [ "$rc" -eq 0 ] && printf '%s' "$out" | grep -q "^showrunner-sources: 0 errors,"; } \
  && pass "--fetch results never contribute to the error count" \
  || fail "--fetch results never contribute to the error count" "exit=$rc out=$out"

# --- registers resolved from config / missing registers errors -------------

repo=$(new_plain_repo)
mkdir -p "$repo/.claude/showrunner"
one_source_registers "$repo/registers.md"
cat > "$repo/.claude/showrunner/config.md" <<'EOF'
```yaml
business:
  registers: "registers.md"
  research:
    freshness_days: 365
```
EOF
cat > "$repo/doc.md" <<'EOF'
Acme's plans start at $12/user/month [S1].
EOF
out=$(cd "$repo" && "$SOURCES" lint "$repo/doc.md" 2>&1)
rc=$?
{ [ "$rc" -eq 0 ] && printf '%s' "$out" | grep -q "0 errors"; } \
  && pass "registers resolved from business.registers in config.md" \
  || fail "registers resolved from business.registers in config.md" "exit=$rc out=$out"

repo=$(new_plain_repo)
cat > "$repo/doc.md" <<'EOF'
Plain text with $5 and no label.
EOF
out=$(cd "$repo" && "$SOURCES" lint "$repo/doc.md" 2>&1)
rc=$?
{ [ "$rc" -eq 1 ] && printf '%s' "$out" | grep -q "ERROR:.*business.registers not found"; } \
  && pass "missing/unresolvable registers is an ERROR, exit 1" \
  || fail "missing/unresolvable registers is an ERROR, exit 1" "exit=$rc out=$out"

# --- usage errors exit 2 -----------------------------------------------------

repo=$(new_plain_repo)
one_source_registers "$repo/registers.md"
out=$("$SOURCES" lint --registers "$repo/registers.md" 2>&1)
rc=$?
[ "$rc" -eq 2 ] && pass "usage error (no DOCUMENT) exits 2" || fail "usage error (no DOCUMENT) exits 2" "exit=$rc out=$out"

out=$("$SOURCES" 2>&1)
rc=$?
[ "$rc" -eq 2 ] && pass "usage error (no subcommand) exits 2" || fail "usage error (no subcommand) exits 2" "exit=$rc out=$out"

out=$("$SOURCES" bogus --registers "$repo/registers.md" "$repo/noop.md" 2>&1)
rc=$?
[ "$rc" -eq 2 ] && pass "usage error (unknown subcommand) exits 2" || fail "usage error (unknown subcommand) exits 2" "exit=$rc out=$out"

# ===========================================================================
# Summary
# ===========================================================================

printf '\n%d passed, %d failed\n' "$pass_count" "$fail_count"
if [ "$fail_count" -gt 0 ]; then
  exit 1
fi
exit 0
