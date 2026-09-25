---
name: arc
description: Plan, dispatch, verify, and merge isolated software implementation arcs with maximum safe autonomy and an unconditional stop before main. Use when initializing repository build bindings, consuming an approved Forge specification or brief, rendering an implementer prompt, running a cold-context worker in an isolated worktree, independently reviewing a feature branch, or performing the approved two-commit merge ceremony.
---

# Arc

Turn approved direction into verified branch work. Resolve conventions from
evidence, escalate product or scope calls, and never merge automatically.

## Load

1. Read `../core/lifecycle.md` and `../core/method.md`.
2. Read the active project's `.claude/showrunner/config.md` and
   `.claude/showrunner/state.md`.
3. Read [method.md](method.md).
4. For `run`, load `../core/dispatch.md`.
5. For `verify` or `merge`, load `../core/merge.md`. For `verify`, also load
   `../gates/audit.md`, and `../gates/wow-check.md` when the arc touches UI
   and the creative gate is enabled.
6. Load only the templates required by the requested command.

## Route

Arc runs lifecycle stages 7-10 (`arc-plan`, `step0`, `build`, `verify`) and
executes the `merge` ceremony. The conductor chains them: `plan` flows into
`run`, `run` into `verify`, and `verify` `SHIP` into the Sentry `security`
stage, without the owner asking.

- `init`: inspect repository mechanics and fill the Arc config section.
- `plan`: consume approved direction, resolve conventions, and render an
  implementation prompt.
- `run`: execute `plan`, dispatch a cold implementer, review Step 0, collect
  evidence, and stop before merge.
- `verify`: independently review the exact feature tip and issue
  `SHIP`, `FIX`, or `REDESIGN`.
- `merge`: after `SHIP`, required smoke, and explicit approval, execute the
  shared two-commit ceremony.

Use [templates/questions.md](templates/questions.md) for human decisions,
[templates/spec.md](templates/spec.md) for Arc-owned planning,
[templates/impl-prompt.md](templates/impl-prompt.md) for dispatch,
[templates/ship-report.md](templates/ship-report.md) for completion, and
[templates/merge.md](templates/merge.md) for merge readiness.

## Hard Stops

- Never plan from a source whose `handoff` ledger row is missing; a raw brief
  goes to `intake`, not to Arc.
- Never rewrite approved Forge sections 1-8 while consuming sections 9-11.
- Never dispatch before the front-loaded decision gate resolves.
- Never authorize edits before Step 0 approval.
- Never widen scope silently.
- Never accept static inspection as required physical or operational smoke.
- Never issue `SHIP` without binding the verdict to the exact feature tip.
- Never merge without independent `SHIP`, required smoke, and explicit human
  approval.
- Never import facts or wording from another project.
