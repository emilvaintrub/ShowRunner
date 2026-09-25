# Outcome Reviews

Shipping is not the goal; the result is. Every initiative promised, at its
`roadmap` stage, how the owner would know it worked. Every validation
experiment named a pass and a fail threshold. The discovery brief named the
project's success measures and the owner's stop rule. An outcome review checks
those promises against what actually happened, and feeds the answer back into
the plan.

## 1. Setting It Up (At Roadmap)

The Initiative Inquiry's question 3 ("How will we know it worked?") must end
with a measurable outcome, recorded in the project state entry for the
initiative:

- **Metric**: what is measured, in plain words (for example "loans recorded
  per active user per week").
- **Target**: the value that counts as working, and the value that counts as
  not working.
- **Source**: where the number will come from - an analytics export, a
  dashboard, the database, a payment provider report, customer interviews, or
  the owner's own count. Name it; "we'll see" is not a source.
- **Review date**: when enough time or usage will have passed to judge,
  recommended by ShowRunner and approved by the owner with the roadmap gate.

When an outcome cannot be measured directly (a copy fix, a security fix,
an internal refactor), say so and name the observable result instead (the
footer shows 2026; the finding no longer reproduces). Those reviews close at
`close` with the evidence already in hand.

Validation experiments from the assessment carry the same four fields, with
their pass and fail thresholds as the target.

## 2. Scheduling (At Close)

At `close`, add a row to the ledger's Outcome Reviews table
([state.md](state.md)) with the metric, target, source, and review date. When
the agent platform can schedule a reminder, offer to set one for the review
date. Every session start lists reviews that are due or overdue before new
work (lifecycle section 9).

## 3. Running The Review

When a review is due:

1. **Gather the number** from the named source. Record it under the evidence
   standard ([evidence.md](evidence.md)): an owner-supplied export or
   screenshot is registered as an `owner` source; a figure the owner states is
   labeled `[OWNER]`. Never estimate a result that was not measured.
2. **Compare** it with the target: `met`, `partly met`, `missed`, or
   `inconclusive` (not enough data, or the source failed). Say plainly what
   the evidence shows, including when it disappoints.
3. **Explain** in two or three sentences what most likely drove the result,
   separating evidence from judgment.
4. **Check the project-level promises**: does this result move the discovery
   brief's success measures (D12) or trigger the owner's stop rule (D1)? Does
   it confirm or weaken an assessment assumption? Name the assumption.
5. **Recommend** one follow-up: keep as is; iterate (a new initiative, with
   the result as its evidence); remove or roll back (a new initiative); extend
   the review (only when `inconclusive`, with a new date and the reason); or,
   when the stop rule is met, re-open `assessment`.
6. **Owner gate**: the owner confirms the number and chooses the follow-up.
   Record it verbatim in the Outcome Reviews table.

A missed outcome is not a failure of the process; an unreviewed one is.

## 4. Feeding Back

- An assessment assumption the review confirmed or broke gets a dated note in
  the assessment's revision section and, when material, re-opens
  `assessment`.
- A follow-up initiative is opened at `intake` with the review as its
  evidence.
- Pitch documents that quote a projection the review contradicts are listed
  for refresh.
- Parked ideas whose trigger was the result ("after 50 users") are surfaced.
- The Bible records shipped capability; the outcome review records whether it
  mattered. Both are cited at the next `roadmap`.
