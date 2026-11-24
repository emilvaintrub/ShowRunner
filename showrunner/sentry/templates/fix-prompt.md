# Sentry Fix Prompt - <finding-id>

Own only `<feature branch>`. Do not merge or push `main`.

## Finding Contract

- ID and fingerprint:
- Approved severity and disposition:
- Evidence and exploit path:
- Exact remediation direction:
- Non-goals:
- Related findings that remain separate:

## Verified Surface

- <paths, symbols, and current behavior>

## Lessons

- In scope: `<L-ids from the index of project.lessons whose scope overlaps
  the paths this fix touches>`, or "none in scope", or
  `project.lessons: disabled`. Read those entries and their traps. Never edit
  the lessons log.

## Tests And Gates

- Vulnerable-case regression:
- Allowed-case regression:
- Security commands:
- Audit:
- Migration:
- Runtime or operational smoke:

## Step 0

Describe back the risk, verified paths, fix sequence, ownership, tests, smoke,
and scope boundary. End:

`STOP: awaiting describe-back approval`

Use the scope STOP gate for adjacent findings. Commit and push only the feature
branch, write the ship report with its Rules Learned section (`none` when
empty, or `project.lessons: disabled`), report the remote tip, and end:

`STOP BEFORE MERGE`
