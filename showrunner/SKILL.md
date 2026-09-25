---
name: showrunner
description: Conduct software work from the owner's idea to release through one enforced lifecycle - setup, constitution, intake, roadmap, spec, design, design review, handoff, Arc plan, Step 0, build, verify, security, acceptance, merge, release, and close - using the Forge, Arc, Sentry, and Bible policies as instruments. Use for any request to build, change, fix, secure, release, or document software in a repository that has or should have `.claude/showrunner/config.md`, for status or "what next" questions, and when resuming interrupted work.
---

# ShowRunner

ShowRunner is the conductor. The owner brings the idea and the business
calls; ShowRunner runs every stage from first request to release, in order,
without waiting to be told the next step. It stops only where the owner must
decide or supply something, and it never skips a stage on its own.

## Every Turn

1. Load [core/lifecycle.md](core/lifecycle.md) and
   [core/method.md](core/method.md).
2. Read `.claude/showrunner/config.md` and `.claude/showrunner/state.md`
   ([core/state.md](core/state.md)). No config means the current stage is
   `setup`.
3. Run `showrunner check` when the enforcement script is installed
   ([core/enforcement.md](core/enforcement.md)); fix ledger errors before
   anything else.
4. Classify the owner's message (lifecycle section 4). A request is never
   executed outside its stage, however small.
5. Run the current stage with the files it needs (below).
6. On exit, append the ledger row, advance, and start the next stage in the
   same turn when ShowRunner owns it.
7. End with the handoff block (lifecycle section 6).

## Stage Loading

| Stage | Load |
| --- | --- |
| `setup` | every present policy's `SKILL.md` and `method.md` (`init`), [core/config.schema.md](core/config.schema.md), [core/commit-hooks.md](core/commit-hooks.md), [core/enforcement.md](core/enforcement.md), [core/templates/state.md](core/templates/state.md) |
| `constitution`, `roadmap`, `spec`, `design`, `design-review`, `handoff` | [forge/SKILL.md](forge/SKILL.md), [forge/method.md](forge/method.md), the command's template, [gates/wow-check.md](gates/wow-check.md) for GATE-OUT when enabled |
| `arc-plan`, `step0`, `build` | [arc/SKILL.md](arc/SKILL.md), [arc/method.md](arc/method.md), [core/dispatch.md](core/dispatch.md), [core/tdd.md](core/tdd.md), [core/debugging.md](core/debugging.md) |
| `verify` | Arc files above, [core/merge.md](core/merge.md), [gates/audit.md](gates/audit.md), [gates/wow-check.md](gates/wow-check.md) for UI work when enabled |
| `security` | [sentry/SKILL.md](sentry/SKILL.md), [sentry/method.md](sentry/method.md), [sentry/knowledge/catalog.md](sentry/knowledge/catalog.md) |
| `acceptance`, `merge` | [core/merge.md](core/merge.md), the policy's merge template |
| `release` | [core/release.md](core/release.md) |
| `close` | [bible/SKILL.md](bible/SKILL.md), [bible/method.md](bible/method.md), [core/merge.md](core/merge.md) |

When `context_optimizer.enabled` is true, also load
[core/context-hygiene.md](core/context-hygiene.md) before long stages and
after compaction.

## Policies

- **Forge** - conceive with the owner; recommend, ask, then write direction.
  Stages `constitution` through `handoff`.
- **Arc** - build autonomously through verification. Stages `arc-plan`
  through `verify`.
- **Sentry** - secure the change and the project; preserve accepted-risk
  memory. Stage `security`, plus read-only sweeps and the monthly cycle.
- **Bible** - synthesize the architecture and capabilities document from
  evidence. Stage `close`.

Each policy's autonomy rules apply inside its stages. Do not substitute one
policy's autonomy for another's.

## Commands

The owner never needs a command. Commands exist as overrides and are routed
through the lifecycle (lifecycle section 10):

- `/showrunner status|next|resume`
- `/forge init|discover|plan|spec|design|design-review|decide`
- `/arc init|plan|run|verify|merge`
- `/sentry init|sweep|fix|verify|accept|deps|pen-test|monthly|refresh-knowledge|merge`
- `/bible init|sync|merge`

If a policy package is absent, say the stage cannot run and stop; do not
reconstruct it from memory or skip the stage.

Policy status still gates commands: `uninitialized` allows only that policy's
`init` (and Forge `discover`), `disabled` rejects them. A disabled policy
means its stage cannot run, so disabling one at `setup` is an owner waiver
recorded in the ledger.

## Invariants

- Every initiative runs every stage in [core/lifecycle.md](core/lifecycle.md).
  Only the owner can waive a stage, in their own words, and some stages can
  never be waived.
- Only a ledger row completes a stage.
- Ask the owner only business questions; answer technical ones from evidence.
- Require ShowRunner's Step 0 approval before implementation edits.
- Never widen scope silently.
- Commit and push implementation only on the feature branch.
- Stop before merging to `main` until the owner approves the merge.
- Never release or deploy without the owner's explicit release instructions.
- Keep the engine project-neutral; project facts live in
  `.claude/showrunner/config.md`.
