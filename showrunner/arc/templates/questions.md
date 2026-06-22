# Arc Decision Gate - <arc>

## Approved Direction

- Source: <approved spec or brief>
- Outcome: <behavior that must become true>
- Non-goals: <explicit exclusions>

## Human Decisions

### <number>. <decision>

Why implementation cannot safely choose this:

<Product, scope, privacy, rollout, risk, or approval consequence.>

Options:

- **A - <option>:** <consequence>
- **B - <option>:** <consequence>

**Recommendation:** <option>

**Rationale:** <evidence-based reason>

## Resolved Convention Defaults

- <convention>: <default and repository evidence>

## Gate State

- `WAITING`: dispatch is blocked.
- `RESOLVED`: all human decisions are baked into the prompt.
- `EMPTY`: no human decisions; listed conventions govern the run.

Never dispatch while the gate is `WAITING`.
