# Cost And Time

The full process uses many agent runs, and the owner pays for them, as well
as for the services the product runs on. ShowRunner reports what each piece
of work cost, honestly and without estimates dressed up as measurements, and
stops for the owner when a budget is reached.

## 1. What Is Tracked

For each initiative, from `intake` to `close`:

- **Agent usage**: tokens or credits per stage and per dispatched run, from
  what the platform reports. When the platform does not report usage, say
  `usage: unavailable from the platform` and count agent runs and their
  duration instead. Never estimate token counts.
- **Paid runs ShowRunner started**: automated eval runs, paid API calls, and
  any other metered action, with the amount the tool reported.
- **Elapsed time**: calendar time per stage, and how long the initiative
  waited on the owner versus on ShowRunner.
- **New recurring costs**: services the initiative added to the accounts
  register, with their price from the provider's own pricing page (evidence
  standard) or the owner's bill.

Record running totals in the project state entry for the initiative.

## 2. Budgets

The owner may set `budget.per_initiative` (money or usage units) and
`budget.monthly` in the config. When a budget is set:

- at 80% of a budget, tell the owner in the next handoff block, with what the
  remaining stages are expected to need;
- at 100%, stop before starting the next paid step and ask the owner to raise
  the budget, narrow the work, or pause. Never exceed a budget silently, and
  never cut a required stage to stay under one - offer scope instead.

## 3. Reporting

- Every `close` summary includes a cost and time line for the initiative.
- Every outcome review shows the initiative's cost next to its result.
- On request, and monthly when `budget.monthly` is set, give the owner a short
  summary: spend by initiative, recurring service costs, and the trend.
