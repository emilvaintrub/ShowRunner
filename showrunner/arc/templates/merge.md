# Arc Merge Readiness - <arc>

## Required Evidence

- [ ] Independent verdict is `SHIP`.
- [ ] Verdict SHA equals current local feature tip.
- [ ] Configured remote feature tip matches.
- [ ] Required human smoke is complete.
- [ ] Disposition decision is recorded (merge / PR / keep on branch / discard).
- [ ] Explicit merge approval is recorded.
- [ ] Primary worktree is clean.
- [ ] Hook path is installed.
- [ ] No unreviewed conflict resolution is needed.
- [ ] Hygiene destination is known.

## Ceremony

Use `../../core/merge.md`. Create exactly:

1. `Merge: <conventional summary>` with `--no-ff`;
2. `docs(backlog): <arc hygiene summary>`.

Verify exactly two first-parent commits, push the primary branch, and verify its
local and remote tips match.

Do not squash, bypass hooks, or merge from the implementation worktree.
