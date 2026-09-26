# Changelog

All notable public changes to ShowRunner are documented here.

## v1.5.0 - 2026-09-26

ShowRunner can take over work already under way, and works with a team.

- Added adoption and rescue mode (`core/adoption.md`): when ShowRunner
  arrives at an existing product, a stalled project, or work done outside the
  lifecycle, it stabilizes first (incidents, account control, secrets,
  backups, reproducibility), inventories read-only (as-built architecture,
  security, test health, every branch and uncommitted change, unverified
  figures in existing documents), reconstructs intent with the owner, gives an
  honest health report with keep / finish / fix / rebuild / drop
  recommendations, records a baseline, and adopts kept work as initiatives
  whose stages are reconstructed from what exists. Nothing is discarded;
  nothing is trusted until verified.
- Added named delegates: the owner can let named people approve specific
  gates; the constitution, the assessment verdict, release, waivers, and risk
  acceptance stay with the owner; disagreements go to the owner.
  `showrunner check` enforces delegate rows.
- Added customer feedback intake (`core/feedback.md`): a feedback log with
  personal data removed, themes, and routing to incident mode, a new
  initiative, the ideas log, or assessment evidence.
- Added cost and time reporting (`core/cost.md`): every close reports agent
  usage (or "unavailable"), paid runs, new recurring costs, and elapsed time;
  optional budgets warn at 80% and stop for the owner at 100%.
- Eval suite: 27 cases, adding rescue, delegates, feedback, and budget
  scenarios.

## v1.4.0 - 2026-09-25

The process now checks what happened after release, protects the owner's
control of the product, and knows what to do when production breaks.

- Added outcome reviews (`core/outcomes.md`): every initiative sets a metric,
  target, source, and review date at `roadmap`; the review is scheduled at
  `close`, surfaced when due, reported honestly (met, partly met, missed,
  inconclusive), checked against the success measures and stop rule, and
  followed by the owner's decision.
- Added account ownership checks (`core/ownership.md`, accounts register
  template): setup inventories every external service, the owner confirms who
  holds each account, login, billing, and recovery; new services block build
  until owner-confirmed; at-risk accounts block release; temporary access is
  revoked at close; ShowRunner never creates accounts or holds secrets.
- Added legal steps: name clearance searches (trademark registers, domains,
  stores), dependency licence policy in Sentry (copyleft and unknown licences
  stop for an owner decision), a legal launch pack in Pitch (drafts for lawyer
  review), and a legal preflight before public releases.
- Added incident mode (`core/incident.md`): stabilize with the pre-approved
  rollback or owner-approved actions only, then fix through the full
  lifecycle and write a blameless review.
- Added an automated eval suite (`evals/`) covering 23 of the 26 behavioral
  scenarios in `docs/SCENARIOS.md`, graded with `claude plugin eval` against
  disposable fixture repositories, plus a weekly/on-demand `evals` GitHub
  Actions workflow and a cheap structural check in `sh tests/run.sh`, so
  prose edits and new model generations can no longer silently regress a
  scenario that was previously verified only by hand.

## v1.3.0 - 2026-09-25

The owner's picture can grow during the work.

- Added Forge steering (`forge/steering.md`): any new idea or change of mind,
  at any stage, is captured verbatim in the ideas log, triaged the same turn
  (level, impact map across every approved artifact and the running build),
  and put to the owner as one choice: explore now, fold in, queue, or park.
- A steer session explores the idea with the owner in guide or challenge mode,
  researches it under the evidence standard, and appends a steer assessment;
  the owner adopts now, adopts later, or drops it.
- Adopted steers flow back through the normal gates as dated revisions:
  decision log, discovery brief, assessment, constitution amendment, business
  document refresh, roadmap, and the active initiative.
- Unaffected build work keeps moving during a steer session; affected work
  pauses at a commit boundary with the reason named.
- Parked ideas return at session start and at every close when their trigger
  arrives.
- Added CI: the enforcement suite on Linux (`sh` and `dash`) and the
  installer on Windows PowerShell 5.1.
- CI checkout moved to `actions/checkout@v5` (Node 24 runtime) after GitHub's
  Node 20 deprecation warning.
- From scenario re-runs: the waiver rule is now one fixed sentence with no
  example skip wording, and ShowRunner never tells the owner they approve
  Step 0.

## v1.2.0 - 2026-09-25

ShowRunner now examines the idea before building it, and can produce the
owner's business documents without made-up numbers.

- Added project stages `discovery`, `assessment`, and `business-docs`
  (P2, P3, P5) around the constitution (now P4).
- Forge discovery is a deep, adaptive interview across twelve business
  domains (`forge/knowledge/inquiry-bank.md`), in guide, challenge, or both
  modes, with specificity probes and a running discovery brief. It cannot
  close until every domain is answered, researched, marked to validate, or
  deferred by the owner.
- Forge assessment gives a candid, researched verdict - proceed, validate
  first, pivot, or stop - with an assumptions map, roadblocks, pre-mortem,
  alternatives, unit-economics sketch, validation experiments, and a path to
  realization for newcomers.
- Every initiative now answers an initiative inquiry at `roadmap`.
- Added the Pitch policy: business decisions document, competitor analysis,
  financial research and plan (with a spreadsheet model), and investor
  presentation. The owner selects none, some, or all, now or later.
- Added the evidence standard (`core/evidence.md`): every figure is labeled
  as a cited source, owner input, named assumption, or shown derivation;
  research uses sources actually opened, with excerpts and access dates;
  assumptions never stand in for researchable facts; no research access means
  `EVIDENCE PENDING`, never memory.
- Added `showrunner-sources lint [--fetch]`, which rejects unlabeled figures
  and unknown ids and re-fetches sources to confirm their excerpts, plus an
  independent citation audit before owner approval.
- Tightened the conductor from scenario runs: one owner gate at a time with
  no drafting ahead, no suggested waivers, compliance and data classification
  always confirmed at setup, and a defined first challenge-mode reply.
- Fixed `showrunner check` ignoring an approved Step 0 digest.
- Hardened the PowerShell installer for Windows PowerShell 5.1 JSON arrays.

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
