# Pitch Method

Pitch owns the business-document track. Its policy: the owner decides what
is produced and what it argues; evidence decides what it may claim.

## 1. Inputs

Every document starts from what the project already knows, and cites it:

- the confirmed discovery brief and the owner's answers;
- the viability assessment and the owner's verdict;
- the constitution;
- the decision log;
- the project state and roadmap;
- the shared research registers (`business.registers`);
- earlier approved Pitch documents.

Pitch does not re-ask what these answer. It asks the owner only for what is
missing and is theirs to supply or decide.

## 2. Selection (Stage P5)

After the constitution is approved, present the four documents in plain
language: what each is for, who reads it, what it takes from the owner, and
roughly how much research it needs.

| Document | For | Owner supplies |
| --- | --- | --- |
| Business decisions document | The owner, partners, and early team: what was decided, why, what was rejected, and what is still open | review; any decision not yet recorded |
| Competitor analysis | Understanding the field and positioning against it | known competitors, positioning intent |
| Financial research and plan | Market sizing, pricing, costs, projections, funding need | budget, pricing intent, hiring plans, growth ambition, horizon |
| Investor presentation | Raising money or pitching partners | raise amount, use of funds, team, traction, valuation expectations |

Recommend a selection based on the owner's goals (D1) and verdict: an owner
raising money needs all four; an owner bootstrapping a side business may
need only the decisions document and a lean financial plan. The owner may
choose none, some, or all. Record the choice verbatim as the `business-docs`
selection and in `business.selected`. When they choose none, close the stage
with that approval.

Order: decisions, then competitors, then financials, then deck. The deck
depends on the others: when it is selected without them, Pitch still runs
the research the deck needs under the same evidence rules and tells the
owner.

## 3. Document Session Order

Each selected document follows:

1. **SCOPE** - one owner gate: audience, purpose, geography, currency,
   horizon, confidentiality, and any document-specific choices (below), each
   with a recommendation.
2. **RESEARCH** - log every query in the search log; open and register every
   source; meet the configured minimums or say, with the log, why fewer
   exist; record every assumption.
3. **DRAFT** - fill the template. Evidence and judgment are separated. Every
   figure is labeled.
4. **ASSUMPTION CHECK** - one owner gate: present the assumptions that move
   headline numbers; the owner accepts or replaces each.
5. **VERIFY** - run `showrunner-sources lint` (errors block), then the
   citation audit by an independent verifier ([../core/evidence.md](../core/evidence.md)
   section 5). Fix mismatches; report what could not be confirmed.
6. **REVIEW** - one owner gate: present the document with its three to five
   key findings, its weakest evidence, and the audit summary. The owner
   redlines or approves.
7. **RECORD** - on approval, append the owner-quoted ledger row for
   `business-docs` naming the document and its digest, commit it with the
   registers as `docs(pitch): <document> approved`, and start the next
   selected document.

One owner gate at a time (lifecycle section 7).

## 4. Business Decisions Document

Purpose: a readable account of every material business decision, for the
owner and anyone joining them.

- Draw from the decision log, discovery brief, assessment verdict,
  constitution, and roadmap. Every decision cites its decision-log entry or
  ledger row.
- For each decision: what was decided, when, by whom, the options
  considered, why this one, the evidence, the consequences, and the revisit
  trigger.
- Open decisions are listed with ShowRunner's recommendation and what
  deciding them unblocks.
- Scope choices: audience (owner only, partners, early employees, advisors)
  and level of detail.

## 5. Competitor Analysis

Purpose: an evidence-backed map of the competitive field and where the
owner's product fits.

Research rules, beyond the evidence standard:

- **Discovery is documented.** Search from several angles and log every
  query: the problem in customer words, the solution category, named
  competitors' "alternatives" pages, app stores, review sites, marketplaces,
  and communities where the segment talks. Record candidates found and why
  each was kept or dropped.
- **Four kinds of competition.** Direct competitors, indirect alternatives,
  substitutes, and the status quo (including doing nothing or a spreadsheet).
- **Primary sources per competitor.** Offering, target customer, and pricing
  come from the competitor's own current pages, with access dates. Traction
  signals (funding, headcount, reviews, downloads, customers named) come from
  cited sources, never estimates.
- **Absence is not evidence.** "No pricing page found [Q7]" instead of "free";
  "no offline mode found in docs [S14]" instead of "no offline mode".
- **Every matrix cell cites.** A feature or positioning comparison table has
  a label in every cell, or `not found [Q#]`.
- **Minimums.** At least `business.research.min_competitors` profiled when
  that many exist; otherwise the search log shows the field is thin.

Content: the landscape; a profile per competitor; a comparison matrix;
positioning (where each sits on the two or three dimensions that matter most
to the segment); the owner's differentiation and where it is weak;
competitive threats and likely responses; gaps and opportunities.

Scope choices: geography, segment, depth (how many profiled), and whether to
include adjacent categories.

## 6. Financial Research And Plan

Purpose: a realistic, traceable picture of the money - market, pricing,
costs, projections, and funding need.

Research rules, beyond the evidence standard:

- **Market sizing** is triangulated: top-down from cited market reports or
  public statistics, and bottom-up from a cited count of target customers
  times a price. Show both, the formula, and reconcile the gap.
- **Pricing** is benchmarked against cited competitor prices for comparable
  offers, normalized to the same unit and period.
- **Costs** use cited benchmarks: infrastructure and tool pricing pages,
  payment-processor fees, salary data for the named roles and location,
  marketing channel costs, and legal or compliance costs where applicable.
- **Owner inputs** (budget, hiring plan, launch date, prices chosen, growth
  ambition) are labeled `[OWNER]`.
- **Projections are scenarios.** Conservative, base, and optimistic cases,
  each driven by named assumptions. No single-line forecast.
- **Sensitivity.** Show how break-even and cash need move with the three to
  five assumptions that matter most.

Content: market sizing; pricing research and chosen pricing; cost structure;
unit economics (price, cost to serve, gross margin, acquisition cost,
lifetime value, payback period); revenue and cost projections by month for
year one and by year for the configured horizon; headcount plan; cash flow,
runway, and break-even; funding need and use of funds; key risks to the
numbers; the assumptions register extract.

Deliverables: the narrative document plus a financial model in
`business.formats.financial_model` (a spreadsheet by default) with an
Assumptions sheet whose rows carry the same labels and ids, and formulas that
derive every output from those inputs. No hard-coded outputs.

Scope choices: horizon (default three years), currency, geography, funding
scenario (bootstrapped, grant, angel, venture), and level of detail.

## 7. Investor Presentation

Purpose: a concise, honest deck the owner can present.

- **No new facts.** Every figure and claim on a slide traces to an approved
  Pitch document or the assessment, with the same label. The deck's source
  notes list the ids. A slide that needs a fact nobody has researched sends
  Pitch back to research first.
- **Owner-supplied content is labeled.** Team, traction, customer quotes,
  raise amount, valuation expectations, and milestones come from the owner and
  are marked as such in speaker notes.
- **Structure** (adapt to the audience and stage): title; problem; solution;
  why now; market; product; business model; traction or validation; competition;
  go-to-market; team; financials; the ask and use of funds; closing. Ten to
  fifteen slides.
- **Speaker notes** per slide: what to say, the evidence behind it, and the
  hard question an investor is likely to ask, with a candid answer.
- **Appendix**: sources, assumptions, and the audit summary.
- **Rendering**: use `business.formats.deck` - the host's slide-deck
  capability or a `.pptx` when available, otherwise Markdown slides - and
  keep a Markdown source of the content for review and diffs.

Scope choices: audience (angels, venture funds, grant bodies, partners,
customers), stage, raise amount, and tone.

## 8. Refresh

Approved documents go stale. At every session start, list documents whose
cited sources have passed `business.research.freshness_days`. At every
`close`, list documents an initiative may have affected (pricing, scope,
positioning, costs, legal exposure). Ask the owner which to refresh. A
refresh re-runs RESEARCH through RECORD for the affected sections and appends
a dated revision note; earlier versions stay in history.

## 9. Completion

A Pitch document is complete only when:

- its scope was set by the owner;
- every figure is labeled and every id resolves (lint passes);
- the citation audit is recorded, with unconfirmed items disclosed;
- headline assumptions were accepted or replaced by the owner;
- the owner approved it in their own words;
- the ledger row and commit are recorded.
