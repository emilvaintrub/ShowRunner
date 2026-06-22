---
name: forge
description: Conceive products and features with an inventor without silently making product decisions. Use when initializing product bindings, discovering a product constitution from a raw idea, planning phases, writing a decision-complete feature specification, or appending an evidence-backed product decision before implementation begins.
---

# Forge

Turn intent into approved direction. Collaborate with the inventor; do not
dispatch Forge runtime work.

## Load

1. Read `../core/method.md`.
2. Read the active project's `.claude/showrunner/config.md`.
3. Read [method.md](method.md).
4. Load only the template required by the requested command.

## Route

- `init`: inspect existing product memory and fill the Forge config section.
- `discover`: interview for a constitution using
  [templates/soul.md](templates/soul.md).
- `plan`: define phases and current state using
  [templates/project.md](templates/project.md).
- `spec`: resolve the decision surface, then write
  [templates/spec.md](templates/spec.md).
- `decide`: append one evidence-backed entry using
  [templates/decision.md](templates/decision.md).
- `design`: requires an existing `/forge plan` surface inventory
  (`## Surfaces`); if absent, refuse and recommend `plan`. Request optional
  user examples, run or record the configured research sprint, synthesize
  2-3 expert directions with tradeoffs and a recommendation, resolve brand and
  creative gates, then write
  [templates/designer-brief.md](templates/designer-brief.md) and render it
  through the adapter named by `forge.designer_helper.tool` under
  [templates/adapters/](templates/adapters/).

Use [templates/questions.md](templates/questions.md) for every decision gate.

## Hard Stops

- Never write directions before the decision gate resolves.
- Never choose a product, scope, brand, privacy, or emotional-framing call for
  the inventor.
- Never overwrite decision history.
- Never treat a stale or superseded state file as current.
- Never declare a specification ready for Arc before creative-gate and inventor
  redline approval.
- Never import facts or wording from another project.
