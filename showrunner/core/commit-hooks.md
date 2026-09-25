# Commit Hooks

Showrunner uses a commit-message allowlist to keep branch history auditable and
to protect the two merge subjects.

## Subject Contract

Allow:

```text
<type>: <summary>
<type>(<scope>): <summary>
<type>!: <summary>
<type>(<scope>)!: <summary>
Merge: <allowed conventional summary>
```

Default types:

`feat`, `fix`, `docs`, `chore`, `refactor`, `test`, `ci`, `build`, `perf`,
and `revert`.

Projects may narrow conventional types or require exact scopes in config. A
bare `feat` admits `feat` with any valid scope; `feat(api)` admits only that
exact prefix. Projects may not remove the merge rule or the configured hygiene
prefix.

`init` passes conventional prefixes to
`install-hooks.ps1 -AllowedPrefixes`. `Merge:` remains a locked hook rule and
must contain an otherwise allowed conventional subject.

Reject empty summaries, malformed scopes, and unlisted prefixes. Never bypass
the hook with `--no-verify`.

## Install Per Clone

From the project root, on POSIX:

```text
<showrunner>/scripts/install-hooks.sh
```

or on Windows:

```text
powershell -ExecutionPolicy Bypass -File <showrunner>/scripts/install-hooks.ps1
```

The installer refuses to overwrite a different existing hook unless the human
has reviewed it and explicitly uses `--force` (`-Force`). It copies
`commit-msg`, the `pre-commit` shim, `showrunner`, and
`showrunner-commit-prefixes` into the configured hooks directory, marks them
executable on POSIX, and runs:

```text
git config core.hooksPath .githooks
```

It also installs `showrunner-sources` ([enforcement.md](enforcement.md)
section 3), the research/evidence linter, into the same hooks directory so it
is available on PATH-relative invocation from any clone without a separate
step.

This setting is clone-local and shared by linked worktrees. Add `--claude`
(`-ClaudeSettings`) to also merge the Claude Code hooks that call `showrunner`
into `.claude/settings.json`, preserving everything already there. See
[enforcement.md](enforcement.md) for what `showrunner` enforces and how.

## Verify

Run in the main worktree and every newly created worktree:

```text
git config --get core.hooksPath
git rev-parse --git-path hooks
```

The first command must equal the configured hooks path. The resolved hook and
allowlist file must exist. On POSIX, the hook must be executable.

Before trusting a new installation, create a disposable repository or fixture:

- an allowed conventional subject succeeds;
- `bad prefix` fails;
- both merge ceremony prefixes succeed.

Do not test rejection by making junk commits in a real project.

## Failure Policy

Missing or incorrect hooks are a hard stop before branch commits or merge.
Repair setup, re-run the rejection fixture, and record the result in the ship
report.
