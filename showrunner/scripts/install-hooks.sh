#!/bin/sh
# Installs ShowRunner's Git hooks (POSIX equivalent of install-hooks.ps1).
# See core/commit-hooks.md and core/enforcement.md.
set -eu

usage() {
  cat <<'EOF'
Usage: install-hooks.sh [--project-root DIR] [--hooks-path PATH]
                         [--prefixes a,b,c] [--force] [--claude]

  --project-root DIR   Project root (default: current directory).
  --hooks-path PATH    Hooks directory, relative to the project root
                        (default: .githooks).
  --prefixes a,b,c      Allowed conventional-commit prefixes
                        (default: feat,fix,docs,chore,refactor,test,ci,build,perf,revert).
  --force               Overwrite a differing existing hook without asking.
  --claude               Also merge scripts/claude-hooks.json into
                        <project>/.claude/settings.json.
EOF
}

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

project_root=$(pwd)
hooks_path=".githooks"
prefixes="feat,fix,docs,chore,refactor,test,ci,build,perf,revert"
force=0
do_claude=0

while [ $# -gt 0 ]; do
  case "$1" in
    --project-root) project_root=$2; shift 2 ;;
    --project-root=*) project_root=${1#--project-root=}; shift ;;
    --hooks-path) hooks_path=$2; shift 2 ;;
    --hooks-path=*) hooks_path=${1#--hooks-path=}; shift ;;
    --prefixes) prefixes=$2; shift 2 ;;
    --prefixes=*) prefixes=${1#--prefixes=}; shift ;;
    --force) force=1; shift ;;
    --claude) do_claude=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *)
      echo "install-hooks.sh: unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

project_root=$(CDPATH= cd -- "$project_root" && pwd)

case "$hooks_path" in
  /*)
    echo "install-hooks.sh: --hooks-path must stay within the project: $hooks_path" >&2
    exit 1
    ;;
esac
case "/$hooks_path/" in
  */../*)
    echo "install-hooks.sh: --hooks-path must stay within the project: $hooks_path" >&2
    exit 1
    ;;
esac

if [ ! -e "$project_root/.git" ]; then
  echo "install-hooks.sh: not a Git repository root: $project_root" >&2
  exit 1
fi

oldifs=$IFS
IFS=,
set -f
# shellcheck disable=SC2086
set -- $prefixes
set +f
IFS=$oldifs

docs_ok=0
for p in "$@"; do
  [ -n "$p" ] || continue
  if ! printf '%s' "$p" | grep -Eq '^[a-z][a-z0-9-]*(\([a-z0-9._/-]+\))?$'; then
    echo "install-hooks.sh: invalid conventional commit prefix: $p" >&2
    exit 1
  fi
  if [ "$p" = "docs" ] || [ "$p" = "docs(backlog)" ]; then
    docs_ok=1
  fi
done

if [ "$docs_ok" -ne 1 ]; then
  echo "install-hooks.sh: --prefixes must admit docs(backlog) for the hygiene commit." >&2
  exit 1
fi

hooks_dir="$project_root/$hooks_path"
mkdir -p "$hooks_dir"

install_guarded() {
  # $1=source $2=destination
  if [ -e "$2" ] && [ "$force" -ne 1 ]; then
    if ! cmp -s "$1" "$2"; then
      echo "install-hooks.sh: refusing to overwrite an existing $(basename "$2") hook. Re-run with --force after review." >&2
      exit 1
    fi
  fi
  cp "$1" "$2"
  chmod +x "$2"
}

install_guarded "$script_dir/hooks/commit-msg" "$hooks_dir/commit-msg"
install_guarded "$script_dir/hooks/pre-commit" "$hooks_dir/pre-commit"
install_guarded "$script_dir/showrunner" "$hooks_dir/showrunner"

prefixes_target="$hooks_dir/showrunner-commit-prefixes"
{
  for p in "$@"; do
    [ -n "$p" ] || continue
    printf '%s\n' "$p"
  done
} > "$prefixes_target"

legacy_types="$hooks_dir/showrunner-commit-types"
[ -e "$legacy_types" ] && rm -f "$legacy_types"

git -C "$project_root" config core.hooksPath "$hooks_path"
configured=$(git -C "$project_root" config --get core.hooksPath)
if [ "$configured" != "$hooks_path" ]; then
  echo "install-hooks.sh: hook verification failed. Expected $hooks_path, got '$configured'." >&2
  exit 1
fi

echo "Installed commit-msg hook at $hooks_dir/commit-msg"
echo "Installed pre-commit hook at $hooks_dir/pre-commit"
echo "Installed showrunner script at $hooks_dir/showrunner"
echo "Installed commit prefix allowlist at $prefixes_target"

if [ "$do_claude" -eq 1 ]; then
  settings="$project_root/.claude/settings.json"
  mkdir -p "$project_root/.claude"
  template="$script_dir/claude-hooks.json"
  rendered=$(sed "s#__HOOKS_PATH__#$hooks_path#g" "$template")

  if [ ! -e "$settings" ]; then
    printf '%s\n' "$rendered" > "$settings"
    echo "Installed Claude Code hooks at $settings"
  else
    if ! command -v jq >/dev/null 2>&1; then
      echo "install-hooks.sh: jq is required to merge hooks into an existing $settings (none found on PATH). Install jq, or merge scripts/claude-hooks.json into it by hand." >&2
      exit 1
    fi
    tmpl_file=$(mktemp)
    printf '%s\n' "$rendered" > "$tmpl_file"
    tmp_settings=$(mktemp)
    jq --slurpfile tmpl "$tmpl_file" '
      ($tmpl[0].hooks) as $newhooks
      | .hooks = (
          (.hooks // {}) as $existing
          | reduce ($newhooks | keys[]) as $ev (
              $existing;
              .[$ev] = (
                ((.[$ev] // []) | map(select(((.hooks // []) | any(((.command? // "") | test("/showrunner ")))) | not)))
                + $newhooks[$ev]
              )
            )
        )
    ' "$settings" > "$tmp_settings"
    mv "$tmp_settings" "$settings"
    rm -f "$tmpl_file"
    echo "Merged Claude Code hooks into $settings"
  fi
fi
