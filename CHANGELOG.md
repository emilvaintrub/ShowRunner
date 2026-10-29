# Changelog

All notable public changes to ShowRunner are documented here.

## Unreleased

### Follow-ups

- Incident: record INC-n in the same turn as an early rollback (1 of 3 live
  runs waited for the owner's confirmation before recording).
- Release gate on an unresolved account: 1 of 3 runs still previewed release
  mechanics; consider a sharper example in `core/release.md` section 2.
- `handoff-offers-autonomy-level` fixture: give the spec real sections 3-8.
- Rescue criterion still says "for the owner's decision" beside the rule that
  fate decisions wait for the health report; watch it in full-suite runs.
- Document for users: interactive sessions get one sensitive-file prompt for
  the default ledger path; `claude -p` and CI need `lifecycle.state_file`
  outside `.claude/`.
- Windows: run `tests/windows-powershell.ps1` against the `install.ps1`
  wording change.

## v1.7.0 - 2026-10-29

The owner can now choose how closely to follow the build.

- Added autonomy levels (`core/autonomy.md`): at `handoff` the owner chooses
  High, Medium (default, unchanged), or Run. High adds owner "go" checkpoints
  after `arc-plan`, `step0`, `verify`, and `security`. Run takes the release
  instructions up front, defers adjacent work instead of asking, presents
  `acceptance` and `merge` as one end gate with a ShowRunner decisions digest
  the owner can veto, runs quietly, and drops to Medium after
  `lifecycle.autonomy.run_escalation_limit` escalations. No level skips a
  stage, relaxes an owner decision, or lifts the Sentry cap at Medium.
- `showrunner check` validates `active.autonomy`, the new Autonomy Changes and
  Owner Checkpoints ledger tables, upgrades after `step0`, and High
  checkpoints; `showrunner context` prints the level. Ledgers written before
  this change keep passing.
- New config keys `lifecycle.autonomy.default` and
  `lifecycle.autonomy.run_escalation_limit`; ship reports gain an always
  present ShowRunner decisions section.
- Eval suite: 31 cases, adding autonomy scenarios 31-34.
- The `showrunner` plugin skill now triggers on short owner messages ("go
  ahead", "what's next?", "just build it") in a ShowRunner repository: the
  plugin wrapper, which is what Claude Code lists, shares the engine's full
  description, and `tests/run.sh` keeps the two identical.
- At High and Run, ShowRunner loads `core/autonomy.md` whenever it runs or
  reports a stage from `arc-plan` to `close`, and the Run end gate's contents
  (smoke, disposition, decisions digest, deferred work, High and Critical
  findings) are listed in `core/merge.md`.
- Eval suite: forbidden-tool graders declare `min: 0` (the harness defaults
  `min` to 1, so they could never pass) and match the tool's path argument
  instead of the whole input; `tests/run.sh` enforces both and ignores the
  local `evals/results/` directory.
- The ledger location is configurable: `lifecycle.state_file` (default
  `.claude/showrunner/state.md`, relative, no `..`) is now honoured by
  `showrunner` and the engine prose. `showrunner check` rejects an invalid
  value and a custom path not in `guard.writable_before_build`. Claude Code
  asks before every write under `.claude/`, and non-interactive runs refuse,
  so projects can keep the ledger elsewhere.
- When the host refuses a ledger write, ShowRunner says so, never routes
  around it, finishes the work that does not depend on it, shows the pending
  rows, and asks the owner (`core/state.md`).
- Eval fixtures keep the ledger at `.showrunner/state.md`: `claude plugin
  eval` runs in dontAsk mode, which denied every write under `.claude/`, so
  no eval could open an initiative or record an incident.
- Skip requests name each stage that would be skipped with its risk.
- A new request opens its initiative with the owner's words quoted back in
  the reply, not only in the ledger.
- At High, a reply that reports on a pending checkpoint repeats that
  checkpoint's summary (for Step 0: what will be built, files, tests).
- Incident mode starts the rollback the owner approved at the last release in
  the first reply (run, or handed over as the recorded checklist) and drafts
  the customer message there; with no recorded rollback it still asks.
- The release question is not listed or pre-filled while an account is at
  risk.
- Adoption's first report names the mode, says existing work is verified
  before it counts, and asks the owner's intent for every in-flight branch
  and uncommitted change; the keep / finish / fix / rebuild / drop decision
  still waits for the health report.
- The Claude Code plugin ships a `UserPromptSubmit` routing hook
  (`.claude-plugin/hooks.json`), silent outside ShowRunner repositories and
  where the project hook from `install-hooks --claude` is installed. Codex
  does not load it.

## v1.6.0 - 2026-10-01

ShowRunner spends less on agents by routing each one to the cheapest model
that can do the work, on Claude Code and Codex.

- Added model routing (`core/models.md`): every spawned agent runs on the
  cheapest tier that can do the work well. Judgment (the conductor's own
  model) keeps owner conversations, approvals, verdicts, security triage, and
  every claim; execution (`sonnet` by default on Claude Code) runs the
  implementer, Sentry sweeps, and the citation audit; light (`haiku`) runs web
  fetches, inventories, and output collection, whose results are raw
  material, never evidence. Stuck runs escalate a tier and are recorded; cost
  reports split usage by tier. New config keys `roles.light_model`,
  `roles.routing` (`tiered | single`), and `roles.reasoning_effort`.
- Codex model routing: tiers map to `gpt-6.1-sol` (execution, effort
  `medium`) and `gpt-6-luna` (light, effort `low`) through `spawn_agent`'s
  `model` and `reasoning_effort` parameters, with the `[agents]` defaults in
  `~/.codex/config.toml` as the fallback when per-spawn models are
  unavailable.

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
