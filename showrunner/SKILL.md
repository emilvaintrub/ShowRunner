---
name: showrunner
description: Route software work through Forge, Arc, Sentry, or Bible on one shared, config-driven workflow. Use when conceiving a product or feature, turning an approved spec into an isolated implementation arc, running a security sweep or fix, synthesizing the architecture and capabilities document, initializing Showrunner for a repository, or performing the stop-before-merge verification and two-commit merge ceremony.
---

# Showrunner

Run one lifecycle with four policies:

- `forge`: conceive with the inventor; recommend, ask, then write directions.
- `arc`: build autonomously through verification; stop before `main`.
- `sentry`: sweep and secure; preserve accepted-risk memory; stop before `main`.
- `bible`: synthesize the architecture and capabilities document from the
  repository, Forge spec, Arc reports, and Sentry posture; read-only over the
  product; stop before `main`.

## Route

1. Read the active project's `.claude/showrunner/config.md`.
2. If it is missing, run the requested skill's `init` flow before other work.
3. Load [core/method.md](core/method.md) for every command.
4. Load only the requested skill's `SKILL.md` and `method.md`.
5. For dispatched work, also load [core/dispatch.md](core/dispatch.md).
6. For implementation or fixes that produce code, also load
   [core/tdd.md](core/tdd.md) and [core/debugging.md](core/debugging.md).
7. For verification or merge, load [core/merge.md](core/merge.md).
8. For hook setup or diagnosis, load [core/commit-hooks.md](core/commit-hooks.md).
9. When `context_optimizer.enabled` is true, load
   [core/context-hygiene.md](core/context-hygiene.md) before long plans,
   dispatched work, broad Sentry sweeps, Bible syncs, or post-compaction
   resumes.

## Commands

The suite routes these command families:

- `/forge init|discover|plan|spec|decide|design`
- `/arc init|plan|run|verify|merge`
- `/sentry init|sweep|fix|verify|accept|deps|pen-test|monthly|refresh-knowledge|merge`
- `/bible init|sync|merge`

If a requested skill package is absent, report that the runtime command is not
available; do not reconstruct it from memory and claim it is available.

Forge is available when `forge/SKILL.md` exists. Route by status:

- `ready`: allow every Forge command.
- `uninitialized`: allow `/forge init` and `/forge discover`; block
  `plan|spec|decide|design` until initialization is completed.
- `disabled`: reject Forge commands until the project explicitly enables it.

`design` additionally requires a `/forge plan` surface inventory
(`## Surfaces`); a `ready` Forge without one still blocks `design` and
recommends `plan`. Before a design brief can advance, it must include the
configured research sprint or a recorded waiver, requested user examples,
expert candidate directions with tradeoffs, and a recommendation.

Arc is available when `arc/SKILL.md` exists. Route by status:

- `ready`: allow every Arc command.
- `uninitialized`: allow only `/arc init`; block `plan|run|verify|merge`.
- `disabled`: reject Arc commands until the project explicitly enables it.

Sentry is available when `sentry/SKILL.md` exists. Route by status:

- `ready`: allow every Sentry command.
- `uninitialized`: allow only `/sentry init`; block
  `sweep|fix|verify|accept|deps|pen-test|monthly|refresh-knowledge|merge`.
- `disabled`: reject Sentry commands until the project explicitly enables it.

Bible is available when `bible/SKILL.md` exists. Route by status:

- `ready`: allow every Bible command.
- `uninitialized`: allow only `/bible init`; block `sync|merge`.
- `disabled`: reject Bible commands until the project explicitly enables it.

`sync` reads whichever configured sources exist (`bible.sources`) and binds to
an exact commit; it never edits product code, configuration, schema, or risk
memory.

Do not substitute one skill's autonomy policy for another's.

## Invariants

- Keep the engine project-neutral. Put repository-specific facts in
  `.claude/showrunner/config.md`.
- Classify decisions in core; apply the response policy in the selected skill.
- Require Step 0 describe-back approval before implementation edits.
- Never widen scope silently.
- Commit and push implementation only on the feature branch.
- Stop before merging to `main`.
- Merge only after independent verification and any required human smoke.
