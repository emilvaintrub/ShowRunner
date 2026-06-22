# Implementer Prompt - <arc>

## Role And Ownership

You implement the approved arc in a fresh context. Own only
`<feature branch>`. Do not merge or push the primary branch.

## Read First

1. `<repository guidance>`
2. `<approved direction>`
3. `<decision or current-state source>`
4. `.claude/showrunner/config.md`
5. If this plan uses plan-as-directory: `<overview.md and task-N.md paths>`

Approved source digest: `<sha256>`

For a Forge specification, preserve the recorded digests for sections 1-8,
section 9, section 10, and section 11. Stop if the source changes after
planning.

## Outcome

<Approved observable outcome.>

## Non-Goals

- <explicit exclusion>

## Verified Starting Surface

- `<path or symbol>`: <current behavior>

Verify every path and symbol yourself during Step 0. Report disagreement before
implementation.

## Design Readiness

- Source: <Forge spec section 8, approved /forge design output, equivalent
  artifact, or "not design-dependent">
- Required surfaces/states: <surface and state list, or disabled>
- Stop condition: if design, copy, layout, interaction states, tokens, or
  returned design artifacts are missing for an in-scope UI surface, stop and
  report that `/forge design` is required. Do not invent the missing design.

## Resolved Decisions

- <human-approved decision>

## Convention Defaults

- <implementation default and evidence>

## Files And Responsibilities

| Path | New or modified | Single responsibility |
| --- | --- | --- |
| `<path>` | <new or modified> | <one responsibility> |

## Implementation

### Phase 1 - <name>

- Commit: `<subject>`

#### Task 1.1 - <name>

- RED: <exact test to add in `<path>`; run `<command>`; confirm it fails for
  the right reason>
- GREEN: <exact code to add in `<path>` to pass it>
- REFACTOR: <cleanup, or "none">

## Requirements

- Flags and disabled behavior: <contract>
- Migrations and fixtures: <contract>
- Locale and accessibility: <contract>
- Design, copy, and token constraints: <contract>
- Compatibility and dependencies: <contract>

## Tests And Gates

- `<exact command>`
- Audit: <required or disabled>
- Creative gate: <required or disabled>
- Browser evidence:
  - Tool: Playwright | disabled
  - Commands: <install browsers, run tests, open/report command, or disabled>
  - Target: <base URL, browser projects, devices, locale/timezone>
  - Required artifacts: <trace.zip, HTML report, screenshots, video, console
    errors, page errors, failed requests, CSP violations, network log, or
    disabled>
  - Auth/redaction: <storage state path, authenticated run, secret redaction,
    or disabled>
  - Boundary: browser evidence supports verification but does not replace
    unit tests, Sentry review, manual device smoke, or human approval.
- Human smoke:
  - Environment: <web browser, Android device/emulator, iOS device/simulator,
    backend/dashboard, or disabled>
  - Setup commands: <for example npm install/build/dev, APK build/install,
    server start, migration, curl, or disabled>
  - Manual steps: <numbered user actions>
  - Expected result: <observable pass condition>
  - Evidence to return: <screenshot, link, APK path, logs, response body, or
    disabled>

## Step 0 - Stop Before Editing

Describe back:

1. outcome and non-goals;
2. verified paths, symbols, interfaces, and current behavior;
3. implementation sequence and ownership;
4. flags, migrations, locale, tests, gates, and smoke;
5. decisions, convention defaults, ambiguities, and deviations;
6. the exact execution-contract digest this approval will authorize.

End with `Approval contract digest: <sha256>`, then
`STOP: awaiting describe-back approval`. Do not edit, format, generate, commit,
or push before approval of that exact digest.

## During Work

- Use the scope STOP gate for adjacent work.
- Escalate product or scope decisions; resolve conventions from evidence.
- Keep atomic scoped commits.
- Do not bypass hooks.
- Verify the configured remote feature tip after push.

## Completion

Use `templates/ship-report.md`. Include exact evidence, residual risks, token
cost or the adapter-unavailable statement, and end `STOP BEFORE MERGE`.
