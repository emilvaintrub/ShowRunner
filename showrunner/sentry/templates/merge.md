# Sentry Merge Readiness - <finding-id>

## Required Evidence

- [ ] Independent verdict is `SHIP`.
- [ ] Verdict SHA equals the current local feature tip.
- [ ] Configured remote feature tip matches.
- [ ] Original exploit regression passes.
- [ ] Past-finding regression catalog passes.
- [ ] Required human or operational smoke is complete.
- [ ] Disposition decision is recorded (merge / PR / keep on branch / discard).
- [ ] Explicit merge approval is recorded.
- [ ] Primary worktree is clean and hooks are installed.

## Ceremony

Use `../../core/merge.md`. Create exactly:

1. `Merge: <scoped security fix summary>` with `--no-ff`;
2. `docs(backlog): <finding hygiene summary>`.

Verify exactly two first-parent commits, push the primary branch, and verify
local and remote tips match. Never squash, bypass hooks, or merge from the
implementation worktree.
