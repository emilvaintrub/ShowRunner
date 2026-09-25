# Changelog

All notable public changes to ShowRunner are documented here.

## v1.1.0 - 2026-09-25

ShowRunner becomes the conductor of the whole process, from the owner's idea
to release.

- Added `core/lifecycle.md`: every initiative runs 15 ordered stages (plus
  one-time setup and constitution) and moves to the next one by itself,
  stopping only at owner gates. There are no shorter tracks.
- Added a role split: the owner makes business calls; ShowRunner approves
  Step 0, verification, and other technical gates itself.
- Added the state ledger (`.claude/showrunner/state.md`): stage position and
  every approval, with the owner's exact words. Only a ledger row completes a
  stage, and sessions resume from it.
- Added a mandatory `release` stage (`core/release.md`): release and deploy
  details always come from the owner.
- Added Forge `design-review` for returned design output; the spec is now
  approved as sections 1-8 at `spec` and 9-11 at `handoff`.
- Wired the audit and wow-check gates into Arc `verify`, chained
  plan, run, and verify, and added a fix-loop limit. The fallback build mode
  now records reduced isolation instead of claiming a fresh context.
- Added a mandatory Sentry `security` stage on the verified tip; security
  fixes run the full lifecycle.
- Added a Bible-driven `close` stage that updates project state and proposes
  the next initiative.
- Added mechanical enforcement (`core/enforcement.md`): a portable
  `showrunner` script with Git `pre-commit` and Claude Code hooks, plus
  `showrunner check` for validating the ledger.
- Cursor rules now always apply and, with VS Code instructions, carry the
  full lifecycle.
- Added `docs/SCENARIOS.md` with acceptance scenarios for the conductor's
  behavior.

## v1.0.0 - 2026-06-22

Initial public release.

- Added the four-policy ShowRunner workflow: Forge, Arc, Sentry, and Bible.
- Added governed penetration-test workflow support under Sentry.
- Added browser evidence and smoke-test guidance.
- Added optional context hygiene support for separately installed context
  optimizer tools.
- Added install support for Codex, Claude Code, Cursor, and VS Code/GitHub
  Copilot instruction surfaces.
- Added public user guide, Claude Code metadata, Codex plugin metadata, and
  release metadata.
- Added installer support for comma-separated target lists such as
  `-Target codex,claude`.
