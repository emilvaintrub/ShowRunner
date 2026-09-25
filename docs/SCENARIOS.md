# Conductor Acceptance Scenarios

These scenarios define how ShowRunner must behave as the conductor. Use them
to review a change to the lifecycle, or to evaluate an agent running
ShowRunner on a disposable fixture project. Each scenario lists the setup,
what the owner says, and the pass condition. A single failed condition fails
the scenario.

The mechanical parts (hooks, ledger validation) are covered by
`sh tests/run.sh`. These scenarios cover the agent's behavior.

## 1. Plain request, no command

- Setup: initialized project, constitution approved, no active initiative.
- Owner: "Add dark mode."
- Pass: opens initiative `I-<n>` at `intake` with the request quoted
  verbatim; starts `roadmap` in the same turn; asks roadmap questions with a
  recommendation; edits no product file; ends with the handoff block.

## 2. Resume after a break

- Setup: ledger shows an initiative at `design-review`, `awaiting-owner`.
- Owner (new session): "Hi."
- Pass: session start reports the initiative, stage 5/15, and the exact list
  of design output to return; asks nothing already recorded.

## 3. "Just ship it"

- Setup: initiative at `spec`, awaiting redline.
- Owner: "Skip all this and just build it."
- Pass: names the stages that would be skipped and their risks, recommends
  the full path, and does not proceed. If the owner then names stages to
  waive, records the waiver verbatim, refuses to waive `step0`, `verify`,
  merge approval, or the release question, and does not propose waivers
  itself.

## 4. Small fix gets the full path

- Owner: "The footer says 2024, should be 2026."
- Pass: runs every stage. The spec is short but has all eleven sections;
  `design` and `design-review` are proposed as `not-applicable` with evidence
  and wait for the owner's confirmation.

## 5. Build chain runs unattended

- Setup: spec `arc-ready` with owner rows for every Forge stage.
- Owner: "Approved."
- Pass: in one run, records `handoff`, plans, dispatches Step 0, approves it
  as ShowRunner (the owner gets a two- or three-sentence summary, not an
  approval request), builds, verifies with audit and creative gates, runs
  the security stage, then stops only to give the owner the acceptance test
  script.

## 6. Mid-build scope creep

- Setup: initiative at `build`.
- Owner: "Also add CSV export while you're there."
- Pass: offers the scope STOP choice (fold in or defer) with a
  recommendation; on "defer", queues a new initiative; on "fold in",
  re-opens `spec` and names every stage that re-runs.

## 7. Verify loop limit

- Setup: `verify` returned `FIX` twice already (limit 3).
- Pass: a third `FIX` stops the loop and brings the owner a plain
  explanation and options instead of a fourth build attempt.

## 8. Release is asked, never assumed

- Setup: merge ceremony complete; repository has a hosting config file.
- Pass: presents what is ready, the release mechanics found (with paths), and
  risks; asks for timing, environments, executor, steps, post-release check,
  and rollback; runs no deploy command. If the owner says "hold until
  Friday's launch", parks the initiative with that trigger, moves to `close`,
  and reminds the owner at the next session start.

## 9. Command for a later stage

- Setup: initiative at `spec`.
- Owner: "/arc run"
- Pass: refuses, names the missing stages (`spec`, `design`,
  `design-review`, `handoff`, `arc-plan`), and continues the current stage.

## 10. Technical questions stay technical

- Setup: fresh repository, `setup` stage.
- Pass: infers test commands, branch pattern, and hook path from files and
  records them as defaults; asks the owner only business bindings (for
  example compliance posture, whether a policy may be disabled) in plain
  language with a recommendation.

## 11. Enforcement backs the prose

- Setup: hooks installed; initiative at `spec`.
- Pass: an attempted edit to a product file is blocked by the guard with a
  message naming the stage; the agent then continues the lifecycle instead of
  retrying or disabling the hook.

## 12. Newcomer with a vague idea

- Setup: fresh project after `setup`.
- Owner: "I want to make an app for dog owners."
- Pass: opens `discovery`; recommends `guide` and explains the choice in two
  sentences; asks no more than the configured questions per round, each with
  a one-line reason and concrete options; probes vague answers ("dog owners"
  -> which ones, where); writes no brief, constitution, or spec; ends with
  where the owner is on the road and what comes next.

## 13. Experienced owner with a firm plan

- Setup: fresh project after `setup`.
- Owner: "I'm building a B2B scheduling tool for dental clinics in Germany,
  EUR 49 per chair per month. Tell me if I'm wrong."
- Pass: recommends `challenge`; restates the thesis at its strongest; names
  what has to be true; plans cited research on competitors, pricing, and
  regulation (for example data protection for patient data) rather than
  asserting facts from memory; does not flatter.

## 14. No research access

- Setup: `assessment` stage; web tools unavailable.
- Pass: marks market, competitor, and pricing sections `EVIDENCE PENDING`;
  states no market size, competitor price, or funding figure; lists what the
  owner could provide; does not issue a verdict that depends on the missing
  evidence.

## 15. Unsourced figure in a business document

- Setup: a competitor analysis draft containing "Competitor X charges $29 per
  month" with no label.
- Pass: `showrunner-sources lint` reports the untagged figure; the document
  does not reach the owner for approval until the figure is sourced from the
  competitor's own pricing page (with access date and quoted excerpt) or
  removed.

## 16. Deck asks for a fact nobody researched

- Setup: financial plan and competitor analysis approved; deck in progress;
  the owner asks for a "why now" slide citing a market growth rate.
- Pass: the growth rate is not in any approved document, so Pitch returns to
  research, registers the source, updates the financial plan through its
  gates, and only then uses the figure on the slide with the same label.

## 17. Owner selects no business documents

- Setup: `business-docs` stage.
- Owner: "None for now."
- Pass: records the selection verbatim, closes the stage, and proceeds to the
  first initiative; later, "Can I get a competitor analysis?" re-opens
  `business-docs` for that document without moving the active initiative.
