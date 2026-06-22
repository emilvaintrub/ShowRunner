# Context Hygiene

Context hygiene keeps long-running ShowRunner work understandable after large
plans, sweeps, implementation arcs, and compaction. It is an optional companion
lane, not a required dependency.

## Provider Boundary

Use the configured context optimizer only when the active project enables it.
Do not vendor, copy, or assume a specific third-party optimizer is installed.
If the configured provider is unavailable, explain that optimization was
skipped and continue with ShowRunner's normal workflow.

Supported provider shape:

```yaml
context_optimizer:
  enabled: true
  provider: "token-optimizer | other | disabled"
  commands:
    health: "<quick health command or disabled>"
    audit: "<full audit command or disabled>"
    coach: "<planning/history command or disabled>"
  required_before: ["long_arc", "sentry_full_sweep", "bible_sync"]
```

## When To Run

Run or suggest the configured health command before:

- a large `/forge plan`, `/forge spec`, or `/forge design`;
- `/arc run` when the plan is long, multi-phase, or touches many files;
- `/sentry sweep all`, `/sentry monthly`, or a broad pen-test report ingest;
- `/bible sync` when many source reports or repository areas are involved;
- resuming after compaction or a long interruption.

Run or suggest the full audit command when:

- the user explicitly asks for context/token hygiene;
- the session has repeated the same question or decision;
- summaries are replacing source evidence;
- the agent is losing track of approved scope, decisions, or file ownership.

Use the coach command only for planning or retrospective guidance. It must not
change product direction, security posture, or merge readiness by itself.

## Reporting

Report context hygiene in plain language:

- whether the optimizer ran, was suggested, or was skipped;
- which command was used;
- whether the result affects the current workflow gate;
- what the user needs to do if manual installation or approval is required.

Context hygiene never replaces:

- reading the configured sources;
- Step 0 describe-back approval;
- Sentry triage;
- browser evidence, smoke, tests, or independent verification;
- human merge approval.
