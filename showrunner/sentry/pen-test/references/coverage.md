# Coverage Contract

## Meaning

The target is 98 to 99 percent **executed coverage of applicable test cases**.
It is not a percentage claim about security, attack resistance, or absence of
unknown vulnerabilities.

## Test States

- `pass`: executed; expected control held.
- `finding`: executed; a confirmed or unresolved weakness exists.
- `accepted`: executed; outcome maps to an active Sentry risk decision.
- `rejected`: executed; suspected finding disproved with evidence.
- `blocked`: applicable but execution could not proceed.
- `deferred`: applicable but assigned to a later environment or human test.
- `not-run`: planned but not executed.
- `not-applicable`: excluded with inventory-backed justification.

Only `pass`, `finding`, `accepted`, and `rejected` count as executed.

## Formula

```text
applicable = total - justified_not_applicable
executed = pass + finding + accepted + rejected
coverage_percent = 100 * executed / applicable
```

Do not remove blocked or deferred tests from the denominator.

## Completion Gates

- Overall executed coverage is at least 98 percent.
- Every applicable critical control is executed.
- Each enabled domain meets at least 95 percent so one broad domain cannot hide
  a neglected one.
- No applicable critical test is blocked, deferred, or not run.
- Every `not-applicable` decision cites inventory evidence and reviewer.
- Every public target and entry point maps to at least one executed test.
- Evidence is within the configured freshness window.
- Any remaining 1 to 2 percent has an owner, reason, date, and explicit
  limitation in the report.

## Integrity Rules

- Pin identifiers to a version, for example `WSTG-v42-*`.
- Hash and approve the applicable catalog after inventory.
- Reconcile every ledger identifier, target, entry point, critical flag,
  domain, and safety class with that catalog.
- Require the ledger to contain every approved catalog test exactly once.
- Verify that retained evidence paths exist and execution timestamps are not
  stale or in the future.
- Keep raw counts beside percentages.
- Report unknown inventory separately; do not convert unknowns into
  `not-applicable`.
- Compute domain and critical-control floors before the overall score.
