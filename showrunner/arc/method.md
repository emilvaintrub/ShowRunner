# Arc Method

Arc owns implementation after product direction is approved. Its policy is
maximum safe autonomy over conventions and zero authority to merge by itself.
It runs lifecycle stages `arc-plan`, `step0`, `build`, and `verify`
([../core/lifecycle.md](../core/lifecycle.md)) back to back; the only reasons
to stop between them are a non-empty Arc decision gate, an escalation, or the
fix-loop limit.

## 1. Policy

Apply the shared decision classifier, then:

- Human-owned decision: recommend options and wait before affected work.
- Convention: resolve from repository evidence, record the default, proceed.
- Recorded decision: follow it; do not reopen it as an implementation choice.
- Adjacent work found during the build: invoke the scope STOP gate.
- A new idea or change of mind from the owner mid-arc: hand it to Forge
  steering ([../forge/steering.md](../forge/steering.md)). Keep building what
  its impact map marks unaffected; pause at a commit boundary when it is
  affected; re-open `spec` only through an adopted steer.

Arc may choose implementation composition. It may not change behavior, scope,
privacy, rollout, voice, risk acceptance, or approval policy.

## 2. Session Order

Every Arc follows:

1. **BIND**
   - Read config, approved direction, repository guidance, and current state.
   - Verify Arc is ready and identify required test, gate, migration, locale,
     smoke, hook, branch, remote, and cleanup bindings.

2. **PLAN**
   - Preserve approved product direction.
   - Verify named implementation surfaces instead of assuming paths.
   - Inventory the complete decision surface.
   - Resolve conventions and record them.
   - Gate human-owned decisions before rendering the final prompt.

3. **DESCRIBE**
   - Dispatch a cold implementer using the shared protocol.
   - Require the exact Step 0 describe-back.
   - Approve, correct and re-describe, or escalate.

4. **IMPLEMENT**
   - Verify isolation, base commit, branch, and hook path.
   - Authorize only the approved scope.
   - Run configured tests, gates, migration checks, and build checks.
   - Commit and push only the feature branch.

5. **VERIFY**
   - Collect the ship report and exact feature tip.
   - Independently review base-to-tip behavior and evidence.
   - Issue `SHIP`, `FIX`, or `REDESIGN`.
   - A `FIX` resumes branch work and requires a new exact-tip verdict.

6. **STOP**
   - Present required smoke and merge checklist.
   - End with `STOP BEFORE MERGE`.

7. **MERGE**
   - Run only as a separate command after human approval.
   - Revalidate verdict tip, remote tip, smoke, hooks, and clean ownership.
   - Reuse the shared two-commit ceremony.

## 3. Input Contract

### Forge specification

When input is an Arc-ready Forge specification:

- Treat sections 1-8 as approved product direction.
- Consume section 9 as the Step 0 contract.
- Refine section 10 into executable phases and commit boundaries.
- Turn section 11 into tests and an observable passing condition.
- Record a digest of the approved source and its 1-8, 9, 10, and 11 boundaries
  in the plan and implementer prompt.
- Reject planning or execution when the source is not explicitly `arc-ready`,
  its approval markers are absent, or any bound section changes after planning.
  The approval markers are the owner-quoted ledger rows for `spec`, `design`,
  `design-review`, and `handoff`, whose recorded digests must match the
  source's current bytes. A status line alone is not an approval marker.
- Before implementation, require the planned base commit, a clean worktree,
  ordinary index flags, and tracked bytes that hash to that base tree.
- During independent verification, reconstruct the Forge binding from the
  unchanged base-commit source and require every inspected byte to match the
  exact feature tip.
- Return product changes to Forge or the human; do not rewrite them in Arc.

### Raw briefs

A raw brief, ticket, or chat request never enters Arc directly. The conductor
opens it at `intake` and runs the Forge stages first, however small the
change.

### Design readiness gate

Before planning implementation, classify whether the work depends on visual,
interaction, content, or surface-level design. If it does, require an approved
design source: a Forge spec section 8 with enough detail, an approved
`/forge design` brief plus returned design-engine output, or an equivalent
recorded project design artifact.

If the user says the work is "not designed", the plan has no surface
inventory, or UI/UX states are missing, Arc stops and directs the user back:

- use `/forge plan` when the phase has no approved surface inventory;
- use `/forge design` when surfaces exist but layout, states, visual
  direction, copy, or design-output approval is missing;
- use `/forge spec` when behavior or scope is still undecided.

Arc must not design the missing experience itself. It may identify the gap,
explain why implementation would otherwise invent product direction, and carry
the approved result forward after the design stage returns. The lifecycle
normally prevents this state; reaching it means a Forge stage closed
incorrectly, so re-open that stage and record why.

Arc owns the implementer prompt. Forge does not.

## 4. Initialization

`init` inspects:

- repository identity, primary branch, remote, and guidance;
- established branch and commit conventions;
- test lanes and working directories;
- migration mechanics and representative pre-migration fixtures;
- design and locale constraints;
- audit and creative gates;
- runtime, device, and operational smoke;
- browser evidence bindings, including Playwright commands, target browsers,
  devices, traces, screenshots, console/page errors, failed requests, CSP
  violations, report artifacts, and secret-redaction rules;
- hook installation;
- prompt cleanup and hygiene destination.

On a cold repository, populate missing shared-base bindings from repository
evidence or approved answers. Preserve every existing shared-base value and
preserve Forge and Sentry sections byte-for-byte. Set `arc.status: ready` only
when branch ownership, hooks, at least one applicable test lane, merge policy,
and all required smoke or approval bindings resolve. Otherwise use
`uninitialized` and report exactly what remains.

While `uninitialized`, only `/arc init` is allowed. `disabled` rejects all Arc
commands until the project explicitly enables it.

## 5. Planning

`plan` produces:

1. an Arc plan using `templates/spec.md`;
2. a decision gate, even when empty;
3. a rendered prompt using `templates/impl-prompt.md`.

### Plan Quality Bar

A plan must be followable by an engineer with no project context and no
judgment calls left to make: exact file paths, complete code, and an explicit
verification step for every task.

- **Map files to responsibilities first.** Before writing tasks, enumerate
  every file to be created or modified and its single responsibility. One
  responsibility per file; files that change together belong to the same
  task.
- **Bite-sized tasks.** Size each task to 2-5 minutes of work. Split a task
  that is larger instead of writing it as one step.
- **Per-task RED/GREEN/REFACTOR.** Each implementation task names the failing
  test it adds first, per [../core/tdd.md](../core/tdd.md): RED (the test and
  its expected failure), GREEN (the minimal code that passes it), and
  REFACTOR when applicable. Do not defer tests to a later phase.
- **Plan-as-directory.** When the files-and-responsibilities map or task count
  makes one document unwieldy, split the plan into
  `<arc.planning.plans_directory>/YYYY-MM-DD-<feature>/overview.md` plus one
  `task-N.md` per task, so a dispatched implementer reads only the files it
  needs.

The prompt must include:

- role and branch ownership;
- complete read list, approved source, and source digest;
- outcome and explicit non-goals;
- design readiness source, or a statement that no design-dependent surface is
  in scope;
- verified paths, symbols, and existing behavior;
- files-and-responsibilities map;
- implementation phases, bite-sized per-task RED/GREEN/REFACTOR steps, and
  commit boundaries;
- resolved decisions and convention defaults;
- flags, migrations, compatibility, locale, and accessibility;
- exact tests, gates, smoke, and passing condition;
- browser evidence commands and required artifacts when UI, browser runtime,
  CSP, auth flow, routing, or client-side integration changes;
- Step 0 stop;
- scope STOP behavior;
- ship-report and remote-tip requirements;
- `STOP BEFORE MERGE`.

Do not dispatch a prompt containing unresolved human decisions.

## 6. Run And Escalation

`run` reuses `../core/dispatch.md`. It also follows `../core/tdd.md` when
producing code and `../core/debugging.md` when a failure is hit.

- Use one implementation arc at a time by default.
- Require a cold context and isolated worktree or equivalent index.
- Compare the describe-back with the approved brief and repository evidence.
- Include the execution-contract digest in the describe-back and require
  approval of that exact digest before implementation.
- Resolve convention discrepancies from evidence.
- Escalate behavior, scope, privacy, rollout, risk, or approval divergence.
- If the resumable context is lost, repeat Step 0 in a new cold context.
- Reject generic Arc-type approval or approval transferred from another source,
  plan, prompt, or describe-back.
- Report numeric token cost when exposed; otherwise use the core unavailable
  statement.

### Batch-Execution Alt Path

When the adapter cannot provide `../core/dispatch.md`'s required runtime
capabilities (no isolated background worktree, no resumable spawn), `run` may
execute the approved plan directly, bounded by the plan's phase and commit
boundaries. This path has no cold context, so it must not claim one:

- Record `isolation: reduced (same context)` in the `step0` ledger row and
  the ship report.
- Write the Step 0 describe-back from the rendered prompt and a fresh read of
  every listed path, not from planning memory. Re-verify each path and symbol
  with a tool call; a claim not re-read in this step is not verified.
- ShowRunner reviews that describe-back against the prompt's checklist and
  records `APPROVED` with the contract digest before the first edit, as in a
  dispatched run.
- Create the feature branch before the first edit; never edit on the primary
  branch.
- Execute one implementation phase at a time. After each phase: commit, run
  that phase's configured tests, and check the phase against the plan before
  starting the next. The checkpoint is ShowRunner's, recorded in the ship
  report; it does not wait for the owner.
- A checkpoint is not a new Step 0; it confirms the just-completed phase
  matches the plan and the next phase remains unchanged.
- `verify` still runs as a separate pass that re-reads the diff from Git, not
  from memory of writing it.
- The scope STOP gate, escalation rules, and `STOP BEFORE MERGE` apply
  identically to the dispatched path.
- Record in the ship report that this run used the batch-execution alt path
  and why (adapter limitation, not a scope shortcut).

A first flaky failure is evidence, not a product question. Re-run according to
repository policy. Consistent red blocks completion.

### Responding To A FIX Verdict

When `verify` returns `FIX`, record a `fix` ledger row, increment
`active.fix_loops`, and resume `run` on the same branch in the same turn. When
`fix_loops` reaches `lifecycle.fix_loop_limit`, stop and give the owner a
plain account of what keeps failing and the options (re-scope, re-open the
spec, or accept a narrower passing condition).

- Reproduce the finding before changing anything; do not patch a behavior you
  have not observed.
- Fix at the root per [../core/debugging.md](../core/debugging.md), not a
  surface patch that only satisfies the reported symptom.
- Re-verify with [../core/method.md](../core/method.md)'s revert-to-confirm:
  show the behavior before and after the fix.
- Report what changed and how it addresses the finding, then request a new
  exact-tip verdict.

## 7. Verification

`verify` is independent of implementation. Apply
[../core/method.md](../core/method.md)'s verification technique:
diff-not-report and revert-to-confirm. Run two ordered passes.

### Spec-Compliance Pass

Check the diff against the approved direction:

- exact reviewed SHA equals current local and configured remote feature tip;
- diff stays within approved scope;
- behavior and non-goals match the source direction;
- any Forge source digest still matches the approved direction and handoff;
- `main` was untouched.

A scope or non-goal violation returns `FIX` regardless of how small it seems.

### Code-Quality Pass

Independent of scope conformance, check the code itself:

- tests and gates are real and complete;
- time fixtures and migrations follow core rules;
- flags are inert when disabled;
- locale and accessibility ceremonies are complete;
- smoke is performed or truthfully pending;
- no prompt artifacts or project bindings leaked into the engine.

Classify each code-quality finding using
[../sentry/knowledge/severity-rubric.md](../sentry/knowledge/severity-rubric.md)'s
tiers, the same tiers Sentry findings use, so severity is comparable across Arc
and Sentry output.

Verdicts:

- `SHIP`: spec-compliance pass is clean and code-quality findings are Low/Info
  only.
- `FIX`: a spec-compliance violation, or a Critical/High/Medium code-quality
  finding; correct branch work, then re-run verification on the new tip.
- `REDESIGN`: approved direction is internally unsafe or no longer adequate.

Before issuing a verdict, run the audit gate
([../gates/audit.md](../gates/audit.md)) over the base-to-tip diff; a Critical
audit finding means `FIX`. For UI, interaction, or copy changes with the
creative gate enabled, run [../gates/wow-check.md](../gates/wow-check.md) on
the built result; anything other than `SHIP` means `FIX`, or `REDESIGN` when
the cause is the approved direction. Disabled gates are named as `disabled`
in the verdict.

Record `SHIP` as the `verify` ledger row (`commit:<tip>`, with the audit and
creative results in Evidence), reset `active.fix_loops`, and start the
`security` stage in the same turn.

## 8. Server And UI Policy

Server-only work may complete automated verification without physical smoke
only when config marks smoke disabled and no runtime or external state changed.

UI, device, runtime-state, deployment, or external-operation changes require a
short human checklist. Automated creative `SHIP`, tests, bundles, screenshots,
or traces do not replace that checklist.

## 9. Browser Evidence

When `browser_evidence.enabled` is true and the arc touches UI, browser
runtime, CSP, auth flow, routing, hydration, client-side state, or visual
behavior, include the configured Playwright lane in the plan and implementer
prompt.

The lane records observable browser behavior:

- exact command, base URL, browser projects, device profiles, locale/timezone,
  and whether the run is local or deployed;
- trace, screenshot, video, HTML report, and artifact directory;
- console errors, page errors, failed requests, CSP violations, and network
  evidence;
- accessibility snapshot or visual comparison expectations when configured;
- authenticated storage state and redaction rules when the test uses login.

Treat Playwright failures as evidence to triage, not automatically as product
questions. A passing Playwright run does not replace unit tests, Sentry review,
manual device smoke, or human approval. When browser evidence is configured but
not runnable in the current environment, record the blocker and the exact
human or CI command needed before merge.

## 10. Completion

After `verify` records `SHIP`, the conductor runs `security`, then asks the
owner for `acceptance`. An Arc is ready to request merge approval only when:

- Step 0 was approved;
- every commit is on the feature branch;
- configured tests and gates pass;
- ship report and remote-tip evidence are complete;
- independent verification says `SHIP` on the exact current tip;
- the `security` stage has a terminal ledger row on the same tip;
- the owner's `acceptance` smoke is recorded;
- the response ends `STOP BEFORE MERGE`.
