# Enforcement

Prose rules are not enough on their own. ShowRunner ships one portable
script, `showrunner`, that turns the most important lifecycle rules into
mechanical checks for Git and for Claude Code. Other agents (Codex, Cursor,
VS Code) rely on the written lifecycle plus the Git hooks.

## 1. The Script

`scripts/showrunner` is POSIX `sh` with `git`, `awk`, `sed`, and `grep`. It
uses `jq` when present and falls back to text parsing. It computes digests
with `sha256sum` or `shasum -a 256`.

It finds the ledger in this order:

1. `$SHOWRUNNER_STATE`, when set;
2. `<primary worktree>/.claude/showrunner/state.md`, where the primary
   worktree is the parent of `git rev-parse --git-common-dir`;
3. `$CLAUDE_PROJECT_DIR/.claude/showrunner/state.md`.

When no ledger exists, every guard allows and `context` prints only a setup
reminder when a config exists. ShowRunner never blocks a project that has not
adopted it.

### Subcommands

| Command | Used by | Behavior |
| --- | --- | --- |
| `showrunner context` | Claude Code `UserPromptSubmit` | Prints a one-paragraph stage reminder. Always exits 0. |
| `showrunner context --session` | Claude Code `SessionStart` | Adds queue, parked releases, the resume point, and the `check` summary. Always exits 0. |
| `showrunner guard` | Claude Code `PreToolUse` | Reads the hook JSON on stdin. Exits 0 to allow; exits 2 with a reason on stderr to block. |
| `showrunner pre-commit` | Git `pre-commit` | Exits 1 with the offending paths to reject a commit. |
| `showrunner check` | conductor, CI | Validates the ledger ([state.md](state.md)). Exits 1 on any error. |

## 2. Rules

**Product edits** (`Edit`, `Write`, `MultiEdit`, `NotebookEdit`):

- A path inside a Git worktree that does not match
  `guard.writable_before_build` is product code.
- Product code may change only when `active.stage` is `build`,
  `active.step0_approved` is not `no`, and the file's worktree is on
  `active.feature_branch`.
- Paths outside any Git worktree are allowed.

**Shell commands** (`Bash`), checked per command segment. Git global options
(`-C`, `-c`, `--git-dir`, `--work-tree`, `--no-pager`) are normalized first,
and a `git switch` or `git checkout` earlier in the same command changes the
branch that later segments are judged against, per repository.

- Hook bypass, always blocked: `--no-verify`; `-n` on `git commit`; setting
  or unsetting `core.hooksPath` through `git config`, `git -c`, or the
  `GIT_CONFIG_*` environment variables. Reading it is allowed.
- `git merge` while the effective branch is the primary branch: blocked
  unless `active.stage` is `merge`.
- A force push (`--force`, `--force-with-lease`, `--force-if-includes`,
  `--mirror`, `-f`, or a `+` refspec) while on the primary branch or naming
  it in a refspec: always blocked.
- A segment starting with any `guard.release_patterns` entry, after leading
  `NAME=value` assignments and `env` are removed: blocked unless
  `active.stage` is `release` and `active.release_authorized` is `yes`.

**Commits** (`pre-commit`):

- On the primary branch, every staged path must be writable, except while
  concluding a merge (`MERGE_HEAD` exists) during the `merge` stage.
- On any other branch, staged product paths require the same three conditions
  as product edits.

**Ledger** (`check`): the rules in [state.md](state.md) section Validation,
plus: a ShowRunner-owned stage (`intake`, `step0`, `build`, `verify`) closed
by an owner outcome is an error.

Block messages name the rule, the current stage, and what the lifecycle
requires next, so the agent redirects instead of retrying.

## 3. Research Linter

`scripts/showrunner-sources` checks research-bearing documents against the
[evidence standard](evidence.md). It is a separate POSIX `sh` script, so the
guard stays small and fast.

```text
showrunner-sources lint [--registers FILE] [--fetch] DOCUMENT...
```

The registers file comes from `--registers`, else `business.registers` in
`.claude/showrunner/config.md`, else it is an error.

**Registers** (errors): every row in `## Sources` has an `S<n>` id, a URL (or
a file path or description when the Type is `owner`), an `Accessed` date in
`YYYY-MM-DD` form, and a non-empty quoted excerpt; `## Search Log` rows have
`Q<n>` ids and a query; `## Assumptions` rows have `A<n>` ids, a value, a
rationale, and a sensitivity. Ids are unique.

**Documents** (errors): outside fenced code blocks and HTML comments, every
table cell and every prose sentence that contains a figure carries a label in
the same cell or sentence. Sentences are read across wrapped lines: a
paragraph or list item is joined before it is split into sentences, and
errors name the physical line where the figure appears. A figure is a
currency amount (a currency symbol or ISO code next to a number), a
percentage, or a number with a magnitude word or suffix (`k`, `m`, `mm`, `b`,
`bn`, `thousand`, `million`, `billion`, `trillion`). Plain counts, years, and
`<placeholder>` text are not figures. A missing registers file is an error;
exit code 2 is reserved for usage errors. Labels
are `[S<n>]` (several ids may share one bracket, `[S1, S4]`), `[OWNER]`,
`[ASSUMPTION A<n>]`, and `[DERIVED: ...]`. Every cited `S`, `A`, and `Q` id
exists in the registers.

**Warnings**: a cited source whose `Accessed` date is older than
`business.research.freshness_days` (default 365); each `EVIDENCE PENDING`
marker, reported so the owner sees open gaps.

**`--fetch`** (warnings only, never errors): for every cited source with an
`http` or `https` URL, fetch the page, reduce it to lowercase text with
collapsed whitespace, and report `confirmed` when the normalized excerpt is
found, `excerpt-not-found` when the page loads but the excerpt is absent, and
`unreachable` on an HTTP error or timeout. Pages that render in JavaScript or
sit behind a login often report `excerpt-not-found`; the human-readable
citation audit ([evidence.md](evidence.md) section 5) decides those.

Output: `ERROR:` and `WARN:` lines naming file and line, a `--fetch` result
table when requested, then `showrunner-sources: N errors, M warnings`. Exit 1
when there are errors.

## 4. Installation

The `setup` stage installs enforcement into the project and verifies it:

1. Run `scripts/install-hooks.sh` (POSIX) or `scripts/install-hooks.ps1`
   (Windows PowerShell). Each copies `commit-msg`, `pre-commit`, the prefix
   allowlist, `showrunner`, and `showrunner-sources` into the configured
   hooks path, marks them
   executable, and sets `core.hooksPath`.
2. With `--claude` (`-ClaudeSettings` in PowerShell), the installer merges the
   entries from `scripts/claude-hooks.json` into the project's
   `.claude/settings.json`, preserving every existing setting and hook, and
   without duplicating ShowRunner entries on re-run.
3. Commit the hooks path and `.claude/settings.json` on the primary branch as
   `chore(showrunner): install enforcement`, so worktrees and teammates get
   them.
4. Verify: `showrunner check` passes; a product-path edit before Step 0 is
   blocked in a disposable fixture, not in the real project.

The package's own regression suite is `sh tests/run.sh` in the ShowRunner
repository; run it under `sh` and `dash` after changing the script.

## 5. Limits

The guard catches honest mistakes and drift, not a determined bypass.
It inspects edit tools and recognizable Git and release commands; it does not
parse arbitrary shell. A file written through a shell redirect or a script is
not blocked at edit time, but the `pre-commit` rule still rejects committing
it outside `build`. Release wrappers (`npx`, `sudo`, task runners) are matched
only when setup lists them in `guard.release_patterns`.
Instructions and the ledger remain authoritative. Report a guard that blocked
legitimate work as a setup defect and fix `guard.writable_before_build`;
never disable the hook to get past a stage.
