# Release

Release and deploy belong to the owner. ShowRunner must ask; it never infers
whether, when, where, or how to release. The `release` stage is mandatory for
every initiative and its question cannot be waived.

## 1. When It Runs

Immediately after the `merge` stage records a verified ceremony (or the
owner's other disposition). If the owner chose `keep on branch` or `discard`
at merge, the release question is still asked and records `held` or
`not released - discarded`.

## 2. Ownership Preflight

Before asking, check the accounts register ([ownership.md](ownership.md)):
every service this release touches must be `owner-confirmed`. List any
`pending owner` or `at risk` row first, with the one action that fixes it. The
release question waits until the owner resolves each one or accepts the risk in
their own words.

## 3. The Release Question

Prepare, then ask in one message:

1. **What is ready**: the merged change in plain words, the exact commit, and
   the acceptance evidence.
2. **What ShowRunner found in the repository**: release and deploy mechanics
   visible in files (CI workflows, hosting config, package manifests, store
   metadata, migration steps), each marked "found in `<path>`". Findings are
   information, not a plan.
3. **Risks for this release**: migrations, flags, data changes, dependencies,
   accepted risks, and anything irreversible.
4. **What the owner must supply**:
   - release now, schedule it, or hold (with the trigger that ends the hold);
   - target environment(s) and order (for example staging, then production);
   - who executes: the owner, or ShowRunner running the owner's exact steps;
   - the exact commands or console steps, or confirmation of the ones found;
   - required approvals, freeze windows, or announcements;
   - the post-release check and who performs it;
   - the rollback plan and the signal that triggers it.

Recommend an answer for each item from the evidence, and say plainly that the
owner decides. Never fill in a target, credential, account, store listing, or
timing the owner did not supply.

## 4. Recording The Answer

Record the owner's answer verbatim in the ledger as the `release` gate. When
ShowRunner will execute, also set `active.release_authorized: yes` and record
the authorized commands as `guard.release_patterns`. Clear
`release_authorized` to `no` when the stage closes.

## 5. Executing

- **Owner executes**: provide a numbered checklist built from the owner's
  steps, then wait for the returned evidence (URLs, version numbers,
  dashboards, logs).
- **ShowRunner executes**: run exactly the authorized steps, in order, from a
  clean checkout of the merged commit. Stop at the first failure and report;
  do not improvise a fix or an alternate target. Never use credentials the
  owner did not provide for this purpose.

Then run or hand over the post-release check the owner named.

## 6. Outcomes

- `released`: steps executed and the post-release check passed. Record the
  environment, version or deployment id, commit, and evidence.
- `held`: the owner deferred. Park the initiative at `release` with the
  trigger; every session start reminds the owner.
- Failed check: follow the owner's rollback plan, record what happened, and
  re-open the initiative at `build` (defect) or `spec` (direction). Ask the
  owner before any second attempt.

After `released` or `held`, advance to `close`.
