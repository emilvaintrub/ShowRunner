# Merge Ceremony

Arc and Sentry share one absolute ceiling: automation stops before `main`.

## Ready To Verify

The feature branch must provide:

- approved Step 0 record;
- scoped commits with passing hooks;
- exact test and gate results;
- migration and dependency notes;
- remote feature-tip match when a remote is configured;
- ship report and required smoke checklist;
- no unexplained scope expansion.

## Independent Verification

The architect:

1. Reads the original brief, approved describe-back, and ship report.
2. Reviews the complete base-to-branch diff.
3. Checks behavior, regressions, security, migrations, flags, locales, and
   project bindings.
4. Runs or confirms configured tests and gates.
5. Issues `SHIP`, `FIX`, or `REDESIGN`.

`FIX` returns to the feature branch. It never authorizes a partial merge.

## Human Gate

Before merge, the human completes any configured physical or operational smoke.
Static analysis cannot waive this gate.

Record:

- environment or device;
- build or deployment identifier;
- checklist results;
- residual issues;
- explicit merge approval.

## Disposition Decision

At the Human Gate, the human chooses what happens to the verified branch:

- **Merge** (default): proceed to Exactly Two Mainline Commits below.
- **Open a pull request**: when the project's contribution workflow requires
  PR review before joining the primary branch, defer the two-commit ceremony
  until the PR is approved and merged through that workflow. This package's
  exact-tip, provenance, and hygiene requirements still apply to the PR's
  merge commit.
- **Keep on branch**: defer the merge decision (for example, pending an
  external dependency or a coordinated release). Record the deferred status
  and the condition that will trigger a later disposition decision.
- **Discard**: the verified work is no longer wanted. Record why; do not
  merge. Branch deletion follows the project's normal hygiene and is not part
  of this ceremony.

The stop-before-merge, exact-tip, and two-commit ceremony below remain
authoritative for the `merge` disposition. The other three options are
exceptions the human may choose, each recorded in the ship report and ledger.

## Exactly Two Mainline Commits

Run from the main worktree where `core.hooksPath` is configured.

1. Update the primary branch from its configured remote when a remote exists.
2. Merge the verified feature branch with `--no-ff`.
3. Use subject `Merge: <scoped conventional summary>`.
4. Perform hygiene:
   - update the configured backlog, project-state file, or Showrunner ledger;
   - remove configured temporary prompt artifacts;
   - record deferred items and smoke status.
5. Commit hygiene separately with
   `docs(backlog): <arc-specific hygiene summary>`.
6. Verify there are exactly two new **first-parent** commits on the primary
   branch: the merge commit and the hygiene commit.
7. Push the primary branch.
8. Verify local and remote primary tips match.

Feature commits remain in history through the merge. "Exactly two" refers to
new first-parent commits created by the ceremony.

## Command Shape

```text
git switch <primary>
git pull --ff-only <remote> <primary>     # when a remote exists
git merge --no-ff <feature> -m "Merge: <summary>"
# update configured hygiene path and clean prompt artifacts
git add <hygiene paths>
git commit -m "docs(backlog): <summary>"
git log --first-parent --oneline <old-primary>..<primary>
git push <remote> <primary>               # when a remote exists
```

Never use `--no-verify`, squash away the reviewed branch, or merge from the
spawned worktree.

## Abort Conditions

Stop before merge when:

- the human gate is incomplete;
- verification is not `SHIP`;
- branch or remote tips differ from the reviewed commit;
- the main worktree has unrelated changes that the ceremony would capture;
- hooks are missing;
- the merge produces unreviewed conflict resolutions;
- the hygiene commit has no truthful project record to update.
