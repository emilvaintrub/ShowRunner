# Steering

An inventor does not have the whole picture at the start. New ideas, second
thoughts, and changes of direction arrive in the middle of building, and they
are often the most valuable input the owner gives. ShowRunner welcomes them at
any stage, never loses one, and routes each back through Forge before it
changes anything that was approved.

This file governs every owner idea or steer that arrives after `discovery`,
whatever the current stage. The conductor classifies it (lifecycle section 4)
and Forge runs the steps below.

## 1. What Counts

- **Idea**: something new the owner thought of: a feature, a customer group,
  an integration, a business angle. Often half-formed ("what if we also...").
- **Steer**: a change of mind about something already decided: the segment,
  the problem, pricing or model, positioning, scope, voice, a constitution
  truth, a roadmap priority, or an approved spec or design.
- **Correction**: a fix to a detail of the artifact at the current stage
  (wording, a number, a missed state). Handled in place by that stage, not
  here.

When in doubt between a correction and a steer, treat it as a steer: the cost
is one short triage; the cost of the opposite mistake is building on a
direction the owner has moved away from.

## 2. Capture - Always, Immediately

Record every idea and steer verbatim in the ideas log
(`forge.ideas_log`, from [templates/ideas-log.md](templates/ideas-log.md))
the moment it arrives, with an id (`IDEA-<n>`), the date, the stage and
initiative it arrived during, and the owner's exact words. Commit it with the
ledger. Nothing the owner says is lost, even if it is parked for months.

Acknowledge it to the owner in one line and continue with triage in the same
turn.

## 3. Triage - The Same Turn

Without stopping the active build, Forge works out:

1. **Level**, with a one-line reason:
   - *feature idea* within the current direction;
   - *change to the active initiative* (its spec, design, or scope);
   - *product steer*: it changes a discovery answer, an assessment finding
     or assumption, a constitution passage, or a business document;
   - *exploration*: the owner is thinking aloud and it is not yet clear what
     it would change.
2. **Impact map**: every approved artifact it touches, named precisely:
   discovery-brief domains, assessment findings and assumptions, constitution
   passages, decision-log entries, business documents and the figures they
   rely on, roadmap items, the active spec's sections and design surfaces, and
   the build in progress (files or phases already built that it would change).
3. **Effect on the active build**:
   - *unaffected*: the build continues while Forge explores;
   - *affected later*: the build continues to its next commit boundary, then
     pauses before the affected phase;
   - *invalidated*: the build pauses now at a commit boundary, and work on the
     affected part stops until the steer is decided.
4. **Fit**: how it sits with the constitution and the assessment verdict,
   in plain words, without verdicts that need research not yet done. Anything
   about markets, customers, buyers, or competitors that has not been
   researched is phrased as a question for the steer session ("Do libraries
   and schools require due dates?"), never as a remembered fact ("they
   typically want due dates"), per [../core/evidence.md](../core/evidence.md).

## 4. The Owner's Choice - One Gate

Present the triage and ask the owner to choose, with a recommendation:

- **Explore now**: run a Forge steer session (section 5) before deciding.
- **Fold in**: add it to the active initiative (only for a change to the
  active initiative whose impact map stays inside that initiative); the
  affected stages re-open as in lifecycle section 4.
- **Queue**: open it as a new initiative after the active one; its `roadmap`
  stage will run the full initiative inquiry.
- **Park**: keep it in the ideas log with a revisit trigger (a date, a
  milestone, or "when <condition>").

Record the choice verbatim in the ideas log and ledger. A product steer
cannot be folded in or queued without exploring it first, because it changes
what was approved at project level; the owner may park it.

## 5. The Steer Session - Forge Explores With The Owner

A steer session is a focused re-run of Forge for this one idea, at the depth
the idea deserves:

1. **Inquire**: the inquiry-bank domains the impact map names, in the owner's
   profile mode. In guide mode, explain what the idea would change and what it
   would take. In challenge mode, restate the idea at its strongest, list what
   has to be true, and test it against the current direction: is it better,
   an addition, or a distraction?
2. **Research** what the idea depends on, under
   [../core/evidence.md](../core/evidence.md): the same rules, registers, and
   audit as the assessment.
3. **Steer assessment** (a dated section appended to the assessment): what
   the idea changes, whether it strengthens or weakens the verdict, new and
   changed assumptions, new risks and roadblocks, effect on unit economics,
   and the cheapest way to validate it. Recommend one of: **adopt now**,
   **adopt later** (queue, with the trigger), or **drop** (with the reason
   recorded, so it can be reconsidered with new evidence).
4. **Decide**: the owner chooses. One gate.

Steer sessions are conversations with the owner; they run while a dispatched
implementer keeps building work the impact map marks unaffected. Forge never
edits product code, and a steer never reaches the build except through the
stages it re-opens.

## 6. Applying An Adopted Steer

When the owner adopts a steer, apply it through the normal gates, in
lifecycle order, recording each as a dated revision so the history of the
owner's thinking stays readable:

1. **Decision log**: a new entry citing `IDEA-<n>`, the prior decision it
   changes, and the evidence.
2. **Discovery brief** and **assessment**: revision sections for the changed
   domains and findings; the owner confirms them (new `discovery` /
   `assessment` ledger rows).
3. **Constitution**: when a durable truth, voice rule, or "never be" item
   changes, an amendment through the constitution gate. A steer that
   contradicts the constitution is surfaced as exactly that; the owner may
   amend the constitution or reshape the steer.
4. **Business documents**: list each approved document and the figures or
   claims the steer affects; ask which to refresh (Pitch refresh).
5. **Roadmap**: add, reorder, or retire initiatives; the owner approves the
   updated plan (`roadmap` gate for the affected initiative or a project-state
   revision).
6. **Active initiative**: according to the impact map - continue unchanged,
   re-open `spec` (and every later stage whose inputs change), or stop and
   close it as superseded with the owner's approval. Work already built and
   still valid is kept; work the steer invalidates is named in the re-opened
   spec's non-goals or removed in the next build.

## 7. Parked Ideas Come Back

- At every `close`, list parked ideas whose trigger has arrived, and any
  queued ideas, and ask whether to explore, queue, or keep parked.
- At every `roadmap`, check the ideas log for ideas related to the new
  initiative and mention them.
- At session start, mention the count of parked ideas with arrived triggers.

## 8. Guardrails

- Never implement an idea directly, however small or urgent it sounds.
- Never let an unexplored product steer change code, specs, or documents.
- Never discard an idea; "drop" keeps the record and the reason.
- Never re-litigate a steer the owner decided unless new evidence appears; then
  bring the evidence, not the argument.
- Never pause or invalidate a build without naming what in the impact map
  requires it.
