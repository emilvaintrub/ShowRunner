---
name: forge
description: Conceive products and features with an inventor without silently making product decisions. Use when initializing product bindings, discovering a product constitution from a raw idea, planning phases, writing a decision-complete feature specification, or appending an evidence-backed product decision before implementation begins.
---

# Forge

Turn intent into approved direction. Collaborate with the inventor; do not
dispatch Forge runtime work.

## Load

1. Read `../core/lifecycle.md` and `../core/method.md`.
2. Read the active project's `.claude/showrunner/config.md` and
   `.claude/showrunner/state.md`.
3. Read [method.md](method.md).
4. Load only the template required by the requested command.

## Route

Forge runs project stages P2-P4 and initiative stages 2-6. The conductor
starts each one; the owner never has to name it. For `discovery` and
`assessment`, load [discovery.md](discovery.md) and
[knowledge/inquiry-bank.md](knowledge/inquiry-bank.md); for `assessment`,
also load `../core/evidence.md`.

| Stage | Command | Output |
| --- | --- | --- |
| `setup` (Forge part) | `init` | Forge config section |
| `discovery` | `discover` | owner profile; [templates/discovery-brief.md](templates/discovery-brief.md) after full inquiry coverage |
| `assessment` | `assess` | [templates/assessment.md](templates/assessment.md) with cited research and the owner's verdict |
| `constitution` | `discover` (constitution) | [templates/soul.md](templates/soul.md) drawn from the confirmed brief and assessment, then automatic `init` re-validation |
| `roadmap` | `plan` | initiative inquiry answers, then [templates/project.md](templates/project.md) with `## Surfaces` |
| `spec` | `spec` | [templates/spec.md](templates/spec.md) sections 1-8 |
| `design` | `design` | [templates/designer-brief.md](templates/designer-brief.md) rendered through `templates/adapters/<forge.designer_helper.tool>.md` |
| `design-review` | `design-review` | returned design output reviewed against the brief's Design Review Package |
| `handoff` | `spec` (sections 9-11) | spec marked `arc-ready` |

`decide` is not a separate stage: every gate proposes the decision-log
entries its answers create, and the owner's gate reply approves them. The
command remains for recording a standalone decision the owner raises.

`design` requires the plan's `## Surfaces` inventory and approved spec
sections 1-8; if either is missing, the conductor re-opens that stage instead.

Use [templates/questions.md](templates/questions.md) for every decision gate.

## Hard Stops

- Never start a stage whose predecessors lack terminal ledger rows.
- Never close `discovery` while an inquiry domain lacks a coverage state, or
  write the constitution before the owner's `assessment` verdict.
- Never state a market, competitor, price, cost, or regulatory fact without
  following `../core/evidence.md`; unknown stays unknown.
- Never mark a constitution `approved`, a brief `inventor-approved` or
  `design-output-approved`, or a spec `arc-ready` without the matching
  owner-quoted ledger row.
- Never write directions before the decision gate resolves.
- Never choose a product, scope, brand, privacy, or emotional-framing call for
  the inventor.
- Never overwrite decision history.
- Never treat a stale or superseded state file as current.
- Never declare a specification ready for Arc before creative-gate and inventor
  redline approval.
- Never import facts or wording from another project.
