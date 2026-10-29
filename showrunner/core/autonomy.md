# Autonomy Levels

The owner chooses how much visibility and control they want over the build.
There are three levels: `high`, `medium`, and `run`. The level governs the
stages `arc-plan` through `close` of one initiative. Forge stays fully
interactive at every level: `intake` through `handoff`, and every project
stage, behave identically whatever the level.

The level never decides whether a gate exists. It decides who clears
ShowRunner-owned checkpoints and how owner gates are batched and reported.

## 1. Invariants

These hold at every level and are never relaxed. There is no config key that
relaxes any of them.

- Every stage runs; only a ledger row completes a stage.
- Decisions in the owner column of [lifecycle.md](lifecycle.md) section 1 stay
  owner decisions. Any product, scope, privacy, pricing, brand, or rollout call
  that the approved spec does not already settle is asked: ask, do not guess.
- Non-waivable stages stay non-waivable. Non-delegable decisions stay with the
  owner. Choosing a level is not a waiver and skips no stage.
- Merge to `main` needs the owner's merge approval. The owner's acceptance
  smoke is required wherever it is required without this file. Release needs
  the owner's explicit release instructions.
- Risk acceptance is always the owner's.
- Escalations stop at every level: reaching `lifecycle.fix_loop_limit`,
  behavior, scope, privacy, rollout, or risk divergence, and an uncertain
  classification (which is human-owned).
- Only the owner may choose or change a level. A delegate may not.

## 2. Medium

Medium is the default and is exactly the lifecycle described in
[lifecycle.md](lifecycle.md). A project that never chooses a level, and any
ledger without an `active.autonomy` key, runs at Medium. Nothing in this file
changes Medium behavior.

## 3. High

High adds owner checkpoints on top of Medium. A checkpoint is a pause in which
the owner sees a plain-language summary and says "go". It never replaces the
ShowRunner gate row.

| After | The owner sees | On "go" |
| --- | --- | --- |
| `arc-plan` | the plan in plain words, even when the Arc decision gate is `EMPTY` | dispatch for Step 0 |
| `step0` | what will be built, which files and areas it touches, and the tests | `build` |
| `verify` | the verdict, what was checked, and the audit and creative results | `security` |
| `security` | the sweep result and every finding with its disposition | `acceptance` |

Mechanics:

- ShowRunner records its own `passed` row for `arc-plan`, `step0`, `verify`,
  and `security` exactly as at Medium. The owner's "go" is never recorded as an
  outcome on a ShowRunner-owned stage (that stays an enforcement error). It is
  recorded in the append-only Owner Checkpoints table
  ([state.md](state.md)), with the owner's words verbatim.
- The owner's "go" at the `step0` checkpoint is a checkpoint, not a Step 0
  approval. Step 0 approval stays ShowRunner's.
- Until the checkpoint row exists, `active.stage` stays on the checkpointed
  stage with `status: awaiting-owner` and `awaiting` naming the "go". The next
  stage does not start in the same turn. This is the one exception to
  lifecycle section 3 step 6.
- A `FIX` loop that repeats `verify` or `security` needs a fresh checkpoint
  each time. `showrunner check` tests only that one checkpoint row exists per
  initiative and stage; it cannot tell which cycle a row belongs to.
- Verbose reporting: every ShowRunner-owned stage explains what it did and why,
  in plain language.

## 4. Run

From the approved `handoff` to the end gate, ShowRunner runs without stopping
except for the invariants in section 1.

1. **Release question pre-asked at `handoff`.** The single `handoff` gate
   message offers the three levels and states that choosing Run also needs the
   owner's release instructions now, listing what the owner supplies
   ([release.md](release.md) section 3, prepared as far as it can be at
   handoff). If the reply chooses Run without them, ShowRunner sends exactly
   one follow-up asking for them. "Ask me later" is a valid answer. The owner's
   answer is recorded verbatim, with its date, in the Evidence of the
   `handoff` gate row, and is quoted again at `release`
   ([release.md](release.md) section 3a). The `handoff` row and the first
   Autonomy Changes row are written once the gate is answered.
2. **Adjacent work is deferred automatically.** A scope STOP that arises between
   `arc-plan` and `verify` is not brought to the owner mid-run. ShowRunner
   defers it (a new queue item or an ideas-log entry, with the finding and its
   evidence captured verbatim) and continues the unaffected work. Fold-in is
   never chosen at Run; only the owner can fold in, at the end gate or later
   through steering. Deferring never widens scope, so no owner decision is
   taken. Security findings outside the diff keep their own finding-ID rule.
   When the adjacent work blocks the in-scope work, deferral is impossible:
   treat it as a scope escalation (stop, ask the owner, and count it).
3. **Combined end gate.** `acceptance` and `merge` are presented in one owner
   message: the smoke playbook, the merge disposition, the ShowRunner
   decisions digest (section 6), the deferred-work list, and every Sentry
   finding of High or Critical severity. ShowRunner reads the ship report and
   the security sweep report before writing it; the full content list is in
   [merge.md](merge.md) Human Gate. One reply can approve both and
   ShowRunner records two rows. A reply that approves only one approves only
   that one. A failed smoke or a vetoed ShowRunner decision returns to
   `build` (the failed-acceptance loop) and approves neither.
4. **Quiet running.** No intermediate status reports between `arc-plan` and the
   end gate unless something stops the run. The handoff block is still written
   whenever a turn ends. A Forge steer from the owner is still handled at once
   ([../forge/steering.md](../forge/steering.md)).
5. **Run-churn auto-downgrade.** When the initiative's escalations exceed
   `lifecycle.autonomy.run_escalation_limit` (default 3; exceed means strictly
   greater, so the fourth at the default), the initiative drops to Medium for
   the rest of the initiative. The over-limit escalation is still brought to
   the owner, and the downgrade is recorded in the same turn as an Autonomy
   Changes row with reason `auto-downgrade: <n> escalations`. The owner is told
   why: the spec was not ready for Run.

Not changed at Run: `security` (capped at Medium, section 7), `close` (the Bible
merge approval stays an owner gate), every escalation, and `fix_loop_limit`.

### What counts as an escalation

Counted in `active.escalations`:

- `lifecycle.fix_loop_limit` reached;
- behavior, scope, privacy, rollout, or risk divergence found at Step 0 or
  during the run, brought to the owner;
- an uncertain classification resolved to human-owned;
- a non-empty Arc decision gate for a decision the approved spec does not
  settle;
- adjacent work that blocks in-scope work (section 4 item 2).

Not counted: a single `FIX` verdict, a failed acceptance smoke, a veto at the
end gate, a risk acceptance, a licence decision, or an owner steer.

`active.escalations` is not validated by `showrunner check`, because the limit
lives in the config. It resets to 0 at `close`.

## 5. Stops after `handoff`

For a typical feature with no escalations:

| Level | Owner stops after `handoff` |
| --- | --- |
| High | `arc-plan`, `step0`, `verify`, `security` checkpoints, then `acceptance`, `merge`, `release`, `close`: 8 |
| Medium | `acceptance`, `merge`, `release`, `close`: 4 (plus `arc-plan` when its gate is not empty) |
| Run | the end gate (`acceptance` and `merge`) and `close`: 2 (plus `arc-plan` only for a decision the spec does not settle) |

## 6. ShowRunner Decisions Digest

Arc's ship report always has a **ShowRunner decisions** section. An empty
section is stated, never omitted. It lists every convention default resolved,
every interpretation of an approved spec point, every deferred adjacent item,
and every model-tier escalation. Each entry gives: what, options, chosen, why,
and the spec anchor.

At Medium and High the digest is informational. At Run it is shown in the end
gate and each entry can be vetoed. A veto returns to `build` and approves
neither `acceptance` nor `merge`.

## 7. Sentry Cap

Sentry inherits the level but is capped at Medium. No Run delta applies to the
`security` stage: every owner stop that exists at Medium remains. High adds the
checkpoint in section 3. At Run, every finding of High or Critical severity is
named to the owner in the end gate, whatever its disposition. There is no
configuration to lift the cap.

## 8. Choosing And Changing The Level

- **Choice.** The level is chosen at `handoff`, inside the same gate that marks
  the spec `arc-ready`. The config default (`lifecycle.autonomy.default`,
  `medium` unless set) is preselected. `active.autonomy` is `medium` until a
  level is chosen. The first Autonomy Changes row for an initiative is written
  at `handoff`, with `From` equal to the config default and the owner's words
  verbatim.
- **Reset.** At `close`, `active.autonomy` returns to `medium` and
  `active.escalations` to 0, so the next initiative never inherits a level.
- **Downgrade** (`run` to `medium` to `high`): at any time, on the owner's
  words, recorded as an Autonomy Changes row.
- **Upgrade** (towards less control): only while `active.stage` is before
  `step0`. A later upgrade row dated at or after the initiative's `step0`
  ledger row is an enforcement error.
- **Auto-downgrade:** Run only (section 4 item 5). It is the only row that may
  carry a reason instead of owner words.
- After any downgrade from Run, `release` asks the release question as it does
  at Medium. The words the owner gave at `handoff` are shown only as a
  recommendation, never executed.
- Initiatives that were reconstructed under adoption mode, or opened before
  this feature, have no level and run at Medium. Incident-mode and Sentry-fix
  initiatives choose a level at their own `handoff` like any other.

## 9. Enforcement

`showrunner check` validates the level and the two tables
([enforcement.md](enforcement.md), [state.md](state.md)), and `showrunner
context` prints the active level. Ledgers written before this feature, with no
`autonomy` key and no tables, pass unchanged.
