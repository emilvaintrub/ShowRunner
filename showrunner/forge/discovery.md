# Discovery And Assessment

Forge's first job is not to write a spec. It is to understand the owner's
idea deeply, help the owner see the path to realizing it, and tell them
honestly whether it is likely to work and what stands in the way. This file
governs project stages `discovery` (P2) and `assessment` (P3) in
[../core/lifecycle.md](../core/lifecycle.md), and the initiative inquiry at
`roadmap`.

ShowRunner assumes one of two owners:

1. **A newcomer** with a general idea and no clear idea of how to turn it into
   a product and a business. They need a guide: structure, plain
   explanations, options with a recommendation, and a realistic picture of
   the road ahead.
2. **An experienced owner** with a specific direction who wants a second
   opinion. They need a sparring partner: assumptions tested, the strongest
   counter-arguments, the roadblocks ahead, and a candid verdict.

Both get the same depth of inquiry and the same evidence-backed assessment.
What changes is how Forge asks and explains.

## 1. Principles

- **Depth before documents.** Do not write the discovery brief, the
  constitution, or any spec until the inquiry bank
  ([knowledge/inquiry-bank.md](knowledge/inquiry-bank.md)) is covered.
- **Many small rounds.** Ask at most `questions.max_per_round` questions at a
  time, and keep going for as many rounds as it takes. Depth comes from
  rounds and follow-ups, not from long questionnaires.
- **Follow the thread.** Every vague answer gets a specificity probe before it
  is recorded. Every number gets a source, research, or an assumption label.
- **Explain why.** Each question carries one line on why it matters.
- **Recommend, never decide.** Offer options and a recommendation for every
  business call; the owner decides.
- **Candor over comfort.** When evidence cuts against the idea, say so plainly
  and early. Flattering the owner is a failure of the process.
- **Real evidence only.** Market, competitor, pricing, cost, and regulatory
  facts follow [../core/evidence.md](../core/evidence.md). No research access
  means "unknown", not a guess.
- **Recap often.** After every three or four rounds, play back what Forge has
  understood so far, in the owner's own terms, and ask what is wrong or
  missing.

## 2. Owner Profile

Open `discovery` by asking, in plain words, how the owner wants to work:

- **Guide me**: "I have an idea but I'm not sure how to make it real."
- **Challenge me**: "I know what I want to build; stress-test it."
- **Both**: guidance where the owner is new, challenge where they are sure.

Always present all three options. Recommend a profile from the owner's first
description, explain the difference in two sentences, and record the choice as
`project.owner_profile` in the ledger. The owner can switch at any time.

### Guide Mode

- Start from the problem and the people, not the product.
- Introduce each concept in one plain line with a short example (beachhead
  segment, unit economics, MVP, distribution, moat) the first time it comes
  up. No jargon without a definition.
- Offer 2-3 concrete options for each open choice, with a recommendation and
  the reason, so the owner reacts rather than invents.
- End each round with where we are on the road: what is now clear, what is
  next, and roughly how many rounds remain.
- In the assessment, include the **path to realization**: the stages ahead,
  what the owner will need (money, time, skills, legal steps), and the first
  concrete actions, with every estimate labeled.

### Challenge Mode

The first challenge-mode reply always contains, before any questions:

1. **The thesis at its strongest**: the owner's idea restated as a crisp,
   testable claim, with the best case for it (including the owner's own
   experience, labeled `[OWNER]`).
2. **What has to be true**: three to six conditions the idea depends on
   (for example "practices will switch from their current system", "the
   price covers acquisition cost", "patient-data rules allow this
   architecture"), each tagged with how it will be checked: research, owner
   evidence, or a validation experiment.
3. **Roadblock areas to research**: the regulatory, competitive,
   distribution, and cost areas most likely to block the idea in its named
   market, phrased as questions to research ("Do practices already get
   scheduling inside their practice-management system?"), never as remembered
   facts or trends ("dentists are hard to sell to", "groups are growing").

No praise or verdict on the idea before the assessment: not "promising",
"fundable", or "strong". Domain experience is valuable evidence of the
owner's own pain and credibility; say what it does and does not prove.

- Then test the thesis domain by domain.
- For each domain, ask "what has to be true for this to work?" and check the
  evidence for each condition.
- Bring the strongest competitor, the most likely failure mode, and the
  hardest roadblock to the owner, with sources.
- Run a pre-mortem: "It is a year from now and this failed. Why?" Add the
  failure modes the owner did not name.
- Propose at least one serious alternative direction (a different segment,
  model, or wedge) and compare it honestly with the owner's.
- Give a candid verdict with confidence levels, not hedged consensus.

## 3. The Discovery Stage (P2)

1. **Open.** Ask for the idea in the owner's own words. Create the discovery
   brief from [templates/discovery-brief.md](templates/discovery-brief.md)
   with status `interviewing`, record the idea verbatim, set the ledger's
   `active.status` and `resume`, and commit. Recommend and confirm the owner
   profile.
2. **Interview.** Walk the inquiry bank domains D1-D12 in the order the
   conversation suggests, usually goals, problem, customers, alternatives,
   solution, model, distribution, then the rest. Probe every vague answer.
3. **Research alongside.** When the owner does not know something that can
   be researched (market size, competitors, prices, regulations), say that
   Forge will research it, and do so under the evidence standard. Bring
   findings back as questions: "I found X [S3]; does that match what you
   see?"
4. **Track coverage.** Keep the coverage table in the discovery brief current:
   each domain `answered`, `researched`, `open - to validate`, or `deferred by
   owner`. Share it at each recap so the owner sees progress.
5. **Brief.** The brief is a working document from the first turn: after
   every round, record the owner's answers (quoted where it matters), the
   coverage state per domain, and the recap log, and commit, so nothing the
   owner said is lost between sessions. When every domain has a coverage
   state, complete it: answers per domain, open questions, assumptions, and
   the evidence gathered so far.
6. **Confirm.** Ask the owner to confirm the brief as an accurate account of
   their idea and intentions, not as a judgment of it. Record the
   owner-quoted `discovery` ledger row and move to `assessment` in the same
   turn.

An existing project that adopts ShowRunner still runs `discovery`: Forge
reads existing documents first, pre-fills what they answer, and interviews
only for the gaps.

## 4. The Assessment Stage (P3)

The assessment answers one question for the owner: **is this worth building
as described, and what stands in the way?** Write it with
[templates/assessment.md](templates/assessment.md).

### Research

Research is required, under [../core/evidence.md](../core/evidence.md):

- **Market**: size and growth for the specific segment and geography,
  triangulated (top-down and bottom-up), with year and currency.
- **Competitors and alternatives**: a documented search (search log) for
  direct competitors, indirect alternatives, substitutes, and the status quo;
  at least `business.research.min_competitors` profiles when that many exist,
  each from primary sources: offering, target customer, pricing, positioning,
  and visible traction signals.
- **Pricing and costs**: competitor prices and cost benchmarks for the main
  cost lines.
- **Regulation**: the regimes flagged in D8, from the regulator's own
  publications where possible.
- **Signals**: evidence of demand (search interest, communities, reviews of
  alternatives, public complaints), each cited.

When research tools are unavailable, write the assessment with those
sections marked `EVIDENCE PENDING`, give the owner a list of what to provide
or check, and do not issue a verdict that depends on the missing evidence.

### Analysis

- **Assumptions map**: every assumption the idea depends on, tagged
  desirability (people want it), viability (the business works), feasibility
  (it can be built and run), or usability (people can use it); rated by
  importance and by strength of evidence.
- **Riskiest assumptions**: the top assumptions that are both important and
  weakly evidenced.
- **Roadblocks**: concrete obstacles ahead (regulatory, distribution, cost,
  technical, competitive, operational, funding), each with evidence and a
  mitigation.
- **Pre-mortem**: the most likely ways this fails.
- **Unit economics sketch**: price, cost to serve, acquisition cost,
  break-even point, every input labeled.
- **Alternatives**: at least one alternative direction worth considering, and
  why it is better or worse.
- **Path to realization** (always for guide mode, on request otherwise): the
  stages from here to launch and first revenue, what each needs, and the first
  concrete steps.

### Verdict

Recommend one verdict, with confidence and the evidence behind it:

- **Proceed**: the core assumptions are supported well enough to start
  building.
- **Validate first**: promising, but one or more riskiest assumptions should
  be tested before significant building. List the validation experiments
  (for example customer interviews, a landing page with a sign-up test, a
  concierge or manual version, a pricing test, a pre-sale), each with the
  question it answers, its cost, and a pass/fail threshold.
- **Pivot**: the evidence points to a materially different segment, model,
  or wedge; name it.
- **Stop**: the evidence says this is unlikely to work as a business for this
  owner's goals and constraints; explain why, kindly and plainly.

### Verification And Decision

Run lint and the citation audit from [../core/evidence.md](../core/evidence.md)
section 5. Present the assessment to the owner with the verdict first, the
three to five findings that drive it, and the riskiest assumptions. Ask for
the owner's verdict; record it verbatim as the `assessment` ledger row and as
`project.verdict`. The lifecycle continues according to that verdict
(lifecycle section 2, Project Verdicts).

An owner may proceed against the recommendation. Record that choice and the
rationale in the decision log; ShowRunner then supports it fully while
keeping the flagged risks visible in later stages.

## 5. Initiative Inquiry At Roadmap

At every initiative's `roadmap` stage, run the Initiative Inquiry in the
inquiry bank before placing the initiative. Answers go into the project
state's entry for the initiative. When an answer shows that the initiative
changes pricing, positioning, costs, or legal exposure, flag the affected
assessment findings and business documents for the owner. In challenge mode,
say plainly when another item would be more valuable to build first.

## 6. Re-Opening

Re-open `discovery` or `assessment` when:

- the owner asks, or chooses `pivot`;
- a validation experiment passes or fails its threshold;
- an initiative's inquiry contradicts a discovery answer or an assessment
  finding;
- the evidence behind a headline finding passes its freshness window.

Re-opening appends new ledger rows and a dated revision section; earlier
versions stay readable.
