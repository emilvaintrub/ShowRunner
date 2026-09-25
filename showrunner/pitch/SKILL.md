---
name: pitch
description: Produce the owner's business documents - a business decisions document, competitor analysis, financial research and plan, and investor presentation - from the product definition and the owner's decisions, with every market, competitor, price, and cost fact backed by a real, dated, re-checked source. Use at the ShowRunner business-docs stage, when the owner asks for any of these documents, or when an approved document needs a refresh.
---

# Pitch

Turn the owner's idea and decisions into business documents they can act on
and show to others. Pitch writes nothing it cannot back: every fact about the
world outside the repository follows `../core/evidence.md`.

## Load

1. Read `../core/lifecycle.md`, `../core/method.md`, and
   `../core/evidence.md`.
2. Read the project's `.claude/showrunner/config.md` and
   `.claude/showrunner/state.md`.
3. Read [method.md](method.md).
4. Load only the template for the document in progress.

## Route

Pitch runs project stage P5, `business-docs`, and re-opens it whenever the
owner asks for a document or a refresh.

| Command | Output |
| --- | --- |
| `/pitch init` | the `business` config section and `pitch.status` (part of `setup`) |
| `/pitch select` | the owner's choice of documents: none, some, or all |
| `/pitch decisions` | [templates/business-decisions.md](templates/business-decisions.md) |
| `/pitch competitors` | [templates/competitor-analysis.md](templates/competitor-analysis.md) |
| `/pitch financials` | [templates/financial-plan.md](templates/financial-plan.md) and the financial model |
| `/pitch deck` | [templates/investor-deck.md](templates/investor-deck.md), rendered in `business.formats.deck` |
| `/pitch refresh <document>` | a dated revision of an approved document |
| `/pitch audit <document>` | lint and citation audit only |

## Hard Stops

- Never produce a document the owner did not select.
- Never state a market, competitor, price, cost, salary, benchmark, funding,
  or regulatory fact without a register source opened in this project; never
  use model memory as a source.
- Never put an unlabeled figure in a document; never invent precision.
- Never let the deck introduce a fact that is not already cited in an
  approved Pitch or assessment document.
- Never present an owner-supplied figure (traction, team, raise amount,
  valuation) as independently verified.
- Never mark a document approved before lint passes, the citation audit is
  recorded, and the owner approves it in their own words.
- Never soften a finding to please the owner.
- Never import facts or wording from another project.
