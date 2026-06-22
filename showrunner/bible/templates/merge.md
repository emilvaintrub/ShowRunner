# Bible Merge Readiness - <sync>

## Required Evidence

- [ ] `sync` ran at an exact commit; the worktree was clean and matched that
      tip.
- [ ] Every Part I and Part II claim cites a repository path, interface, or
      named report.
- [ ] Spec-promised capabilities absent from the repository are listed under
      Intent-Not-Shipped, not under What The System Does.
- [ ] Part II S4 is a summary with a pointer to the authoritative security
      document, not a restatement.
- [ ] The human-owned gate (audience framing, capability inclusion, ambiguous
      evidence) is resolved or explicitly empty.
- [ ] Required human or operational smoke is complete.
- [ ] Disposition decision is recorded (merge / PR / keep on branch /
      discard).
- [ ] Explicit merge approval is recorded.
- [ ] Primary worktree is clean and hooks are installed.

## Ceremony

Use `../../core/merge.md`. Create exactly:

1. `Merge: <scoped Bible sync summary>` with `--no-ff`;
2. `docs(backlog): <Bible sync hygiene summary>`.

Verify exactly two first-parent commits, push the primary branch, and verify
local and remote tips match. Never squash, bypass hooks, or merge from the
sync worktree.
