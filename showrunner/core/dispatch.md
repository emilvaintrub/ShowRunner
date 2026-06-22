# Dispatch

Dispatch preserves a separate implementing context and isolated Git ownership.
Arc and Sentry use it at runtime.

## Required Runtime Capabilities

An adapter must provide:

- a fresh implementer context;
- repository reads;
- an isolated worktree or equivalent isolated index;
- a resumable conversation so Step 0 can be approved before implementation;
- completion notification for background runs;
- branch, commit, test, and push access;
- no authority to merge or push `main`.

A fresh implementer context exists so the implementer re-derives facts from
the repository instead of inheriting the architect's framing, prior attempts,
or conclusions. Treat an implementer that has seen the architect's reasoning,
draft rules, or earlier failed attempts as an isolation defect, not a
convenience tradeoff.

The preferred Claude Code shape is an agent spawn with
`isolation: "worktree"` and `run_in_background: true`. Spawn-time isolation may
provision the branch/worktree before Step 0; that provisioning is allowed, but
the implementer may not edit or commit before describe-back approval. Adapters
that can delay isolation may run Step 0 first and provision the worktree after
approval. If tool names differ, map these capabilities explicitly rather than
weakening the contract.

## Dispatch Record

Before spawning, record:

```yaml
arc_id: "<stable id>"
skill: "arc | sentry"
brief: "<path or rendered prompt>"
base_branch: "<configured primary branch>"
feature_branch: "<configured branch>"
architect_model: "<configured model>"
implementer_model: "<configured model>"
worktree_isolated: true
background: true
token_cost_reporting: true
```

## Protocol

1. **Prepare**
   - Read config and render the complete implementer prompt.
   - Run the front-loaded question gate.
   - Bake approved answers and convention defaults into the prompt.
   - Confirm a clean ownership boundary; do not discard unrelated work.

2. **Spawn for Step 0**
   - Start a cold implementer context.
   - Give it only the prompt, project root, config path, and required read list.
   - Require the exact Step 0 output from `method.md`.
   - Do not authorize edits.

3. **Review**
   - Compare the describe-back with the brief and current repository.
   - Approve a clean read.
   - Correct and require a new describe-back after any misread.
   - Escalate human-owned divergence.

4. **Isolate or verify isolation**
   - Create the feature branch/worktree after approval when the adapter permits.
   - Otherwise verify the spawn-time isolated branch/worktree after approval.
   - Verify `git config --get core.hooksPath` in the worktree.
   - Verify the branch name and base commit.
   - Confirm the base commit's configured test lanes are green before
     authorizing edits; a red baseline is a defect to report, not something
     this arc builds on.
   - Supply an approval token or explicit resume message.

5. **Run**
   - Resume the same implementer context in the isolated worktree.
   - Permit in-scope edits, tests, branch commits, and configured pushes.
   - Route mid-run questions through the decision classifier.
   - Enforce the scope STOP gate.

6. **Collect**
   - Receive the ship report, test evidence, commit list, remote-tip evidence,
     smoke checklist, and token-cost summary.
   - Confirm the implementer did not touch `main`.
   - Remove the worktree only after evidence is retained.

7. **Stop**
   - Return control to the architect for independent verification.
   - Never continue directly into merge.

## Parallelism

The adapter supports parallel dispatch, but policy decides whether it is safe:

- Arc defaults to one implementation arc at a time.
- Sentry may parallelize read-only categorical sweeps.
- Sentry fixes require a touched-file and dependency graph; serialize
  interacting fixes.
- Forge runtime is collaborative and is not dispatched.

## Failure Handling

- Missing hook path: stop before the first commit and repair setup.
- Dirty or wrong base: stop and report; never reset user work.
- Red baseline: stop and report before authorizing edits; do not fix
  pre-existing failures as part of this arc's scope.
- Lost resumable context: spawn a new cold context and repeat Step 0.
- Consistent test failure: report evidence; do not label a first flaky failure
  as a product decision.
- Product/scope divergence: pause and escalate.
- Worker merged or pushed `main`: mark the run invalid and require human audit.

When an adapter does not expose numeric token usage, report
`token usage: unavailable from adapter`; never estimate or silently omit it.
