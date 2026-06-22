---
name: pen-test
description: Plan, execute, validate, retest, and report authorized penetration tests under Sentry with explicit rules of engagement, safety-classed actions, versioned test-case coverage, reproducible evidence, independent finding validation, and cleanup. Use when testing an owned or explicitly authorized web, API, mobile, cloud, infrastructure, supply-chain, or agentic system; importing an external penetration-test report; measuring assessment coverage; or verifying remediation.
---

# Pen Test

Run a bounded security assessment whose authorization, coverage, evidence, and
cleanup can be audited. Treat penetration testing as one implementation
technique inside Sentry, not as proof of complete security.

## Load

1. Read `../../core/method.md`.
2. Read the active project's `.claude/showrunner/config.md`.
3. Read `../method.md`.
4. Read [method.md](method.md).
5. Read [references/authorization.md](references/authorization.md) before any
   active request.
6. Read [references/coverage.md](references/coverage.md) while planning or
   reporting.
7. Load only the applicable sections of
   [references/profiles.md](references/profiles.md).
8. Read [references/validation.md](references/validation.md) before confirming
   findings.
9. Load only the required asset template or schema.

## Route

- `init`: create a draft engagement, scope manifest, and Rules of Engagement;
  perform no target interaction.
- `plan`: inventory actors, entry points, assets, trust boundaries, and
  applicable versioned test cases; produce the coverage ledger.
- `run`: execute only approved tests at or below their authorized safety class.
- `validate`: independently challenge evidence, exploit preconditions, impact,
  and the PoC before confirming a finding.
- `retest`: execute the minimal approved reproduction against the remediated
  target and record closure or residual risk.
- `report`: assemble limitations, coverage, findings, retest state, and cleanup
  status; never translate coverage into a security guarantee.
- `abort`: stop target interaction, preserve minimal evidence, execute cleanup,
  and record the stop reason.
- `ingest <report-path>`: normalize external findings for Sentry triage without
  treating their severity or conclusions as authoritative.

## Required Sequence

`AUTH -> INVENTORY -> PLAN -> RUN -> VALIDATE -> REPORT -> RETEST -> CLEANUP`

Do not skip a stage. A report may be issued before retest only when it states
that remediation verification is pending.

## Hard Stops

- Never interact with a target until authorization is complete, approved, in
  its testing window, and bound to the exact scope and Rules of Engagement.
- Never infer permission from ownership, repository access, credentials, a bug
  bounty, or a broad phrase such as "test everything."
- Never cross a target allowlist, third-party boundary, rate limit, test-data
  boundary, or authorized safety class.
- Never execute an active test that is absent from the approved, hashed
  applicable-test catalog.
- Never run denial of service, persistence, lateral movement, destructive
  production actions, real data exfiltration, social engineering, physical
  access, wireless attacks, or concealment through this generic workflow.
- Never place secrets, credentials, personal data, or unrestricted response
  bodies in prompts, reports, logs, or PoCs.
- Never confirm a finding from a scanner label or plausible pattern alone.
- Never count `blocked`, `deferred`, `not-run`, or unjustified `not-applicable`
  cases as covered.
- Never modify product code or merge fixes. Hand confirmed findings to Sentry.
- Stop immediately on instability, unexpected sensitive data, scope ambiguity,
  authorization expiry, emergency contact instruction, or kill-switch use.

## Completion

An engagement is complete only when:

- authorization and scope hashes match the executed run;
- every target and entry point is reconciled with the inventory;
- the coverage ledger truthfully reports every applicable test;
- confirmed findings passed independent validation;
- limitations and untested areas are explicit;
- retest state is recorded for remediated findings;
- temporary accounts, payloads, files, tokens, and test data are cleaned up or
  assigned to an owner with a deadline;
- evidence disposition is recorded.
