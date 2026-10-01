# Model Routing

ShowRunner runs many agents, and most of their work does not need the
strongest model. Routing each piece of work to the cheapest model tier that
can do it well lowers cost and wait time without lowering the bar: judgment
stays with the strongest tier, and nothing a cheaper tier produces is trusted
without the same verification any other output gets.

## 1. Tiers

| Tier | Config key | Default | Work |
| --- | --- | --- | --- |
| Judgment | `roles.architect_model` | the session's own model | Talking with the owner; discovery, assessment, constitution, spec, and design synthesis; classifying decisions; the Arc plan and implementer prompt; Step 0 review; the verify verdict; security triage, severity, and accepted risk; research synthesis and claims; merge and release ceremony; steering; incident decisions; adoption health report. |
| Execution | `roles.implementer_model` | `sonnet` / `gpt-6.1-sol` | The dispatched implementer (Arc `run`, Sentry `fix`); read-only Sentry category sweeps; the independent citation audit; Bible section drafting from collected evidence; debugging inside the implementer's run. |
| Light | `roles.light_model` | `haiku` / `gpt-6-luna` | Web search and page fetching that returns verbatim excerpts; file, route, dependency, and account inventories; locating paths and symbols; collecting test, lint, and CI output; checking links and source freshness dates; formatting tables, changelog lines, and ledger text the judgment tier has already decided. |

Defaults are given as Claude Code / Codex; section 6 has the full mapping.
The judgment tier is the conductor's own session; ShowRunner does not switch
it. The other tiers apply to every agent ShowRunner spawns.

## 2. Choosing A Tier

Pick the lowest tier whose column describes the task, then check the task
against these signals:

- **Light** fits when the answer is a lookup or a copy: find, list, fetch,
  quote, count, collect, format. The output can be checked mechanically
  against the repository or the source.
- **Execution** fits when the task changes code or reasons over code: build,
  fix, refactor, test, debug, sweep for a vulnerability class, audit a claim
  against a source.
- **Judgment** fits when the task decides something: approve, classify,
  recommend, weigh trade-offs, set severity, design, or speak to the owner.
  When a task mixes a lookup with a decision, split it: the lookup goes to
  the light tier, the decision stays here.

When unsure between two tiers, use the higher one.

## 3. Never Downgraded

These stay on the judgment tier regardless of config or budget:

- every question, recommendation, and handoff block shown to the owner;
- Step 0 approval and the verify verdict;
- security finding classification, severity, and accepted-risk review;
- any claim written into a spec, business document, or Bible; the light tier
  fetches sources, the judgment tier decides what they support;
- merge, release, incident, and waiver handling.

The implementer never runs on the light tier.

## 4. Light-Tier Output Is Not Evidence

A light-tier agent returns raw material, not conclusions:

- A fetch returns the URL, the retrieval date, and verbatim excerpts. The
  judgment tier opens the register entry and decides what the source supports
  ([evidence.md](evidence.md)); a light-tier summary is never cited.
- An inventory returns paths and line numbers. A sweep, audit, or Bible
  section re-reads the files it relies on.
- A collected test or CI result returns the exact command and output. A
  verdict quotes that output, not the agent's description of it.

A light-tier agent never edits product files, commits, or writes the ledger.

## 5. Escalation

Escalating a task to a higher tier is ShowRunner's technical call, never an
owner question. Escalate when:

- a light-tier result is incomplete, contradictory, or fails a mechanical
  check twice - re-run the task on the execution tier;
- `verify` returns `FIX` twice in a row for the same failure, or the
  implementer's [debugging.md](debugging.md) work concludes the cause is
  architectural - run the next fix in a new cold implementer on the judgment
  tier with the failure evidence, repeating Step 0. The fix-loop limit and its
  owner stop ([lifecycle.md](lifecycle.md) section 8) apply unchanged;
  escalation does not reset `fix_loops`;
- a task turns out to need a decision from section 3.

Record every escalation in the ship report or stage notes: the task, the tier
it moved from and to, and why. Escalated runs count against the budget like
any other ([cost.md](cost.md)); when a budget is set and escalating would
cross it, stop for the owner as cost.md requires.

Never downgrade a task mid-run to save cost. Never route around a stage to
save cost.

## 6. Adapters

Each adapter maps the three tiers to its own models. `init` fills
`roles.*_model` from the adapter's model list; these are technical defaults,
not owner questions.

| Tier | Claude Code | Codex |
| --- | --- | --- |
| Judgment | session model (Opus recommended) | session model (`gpt-6-astra` recommended, effort `high`) |
| Execution | `sonnet` | `gpt-6.1-sol`, effort `medium` |
| Light | `haiku` | `gpt-6-luna`, effort `low` |

The Codex names are the catalog as of 2026-10. When a newer generation
appears, pick by role rather than by name: the current "workhorse for
coding" model for execution, the current "fast and affordable" model for
light, and the frontier model for judgment.

### Claude Code

Pass the tier's model on each spawn (the Agent tool's `model` parameter:
`opus`, `sonnet`, or `haiku`). Prefer these aliases over dated model
identifiers so routing follows new model generations. Claude Code has no
per-spawn reasoning effort; `roles.reasoning_effort` is ignored there.

### Codex

Pass the tier's model and effort on each `spawn_agent` call (its `model` and
`reasoning_effort` parameters), using `roles.*_model` and
`roles.reasoning_effort`. Codex has no model aliases, so the config holds
full model names. Effort is part of the tier: higher effort spends more
tokens and time on the same task, so light work stays at `low` and the
implementer at `medium` unless section 5 escalates it. On Codex, the first
escalation of a task may raise effort one step on the same model instead of
moving up a tier; record which.

When `spawn_agent` does not offer `model` (an older Codex or a disabled
feature), routing falls back to the user's own Codex config: the
`[agents]` table in `~/.codex/config.toml` sets
`default_subagent_model` and `default_subagent_reasoning_effort` for every
spawned agent. Recommend the execution tier there - light work then runs on
the execution tier, which is safe - and never edit the user's global Codex
config without asking. Record `model routing: adapter default` in the
dispatch record.

### Other adapters

When an adapter cannot choose a model per spawn, every agent runs on the
session's model: record `model routing: unavailable from adapter` in the
dispatch record and continue - routing is a cost measure, not a gate.

`roles.routing: single` turns routing off and runs every agent on
`architect_model`; use it when the owner prefers one model or the platform
bills per seat rather than per token.

## 7. Reporting

The cost line at `close` ([cost.md](cost.md)) splits agent usage by tier when
the platform reports it, and lists every escalation. When usage by tier is
unavailable, count agent runs per tier instead.
