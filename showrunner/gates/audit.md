# Audit

Run a config-driven code audit before Arc merge. Report evidence; do not treat
grep matches as confirmed violations without reading their context.

## Universal Checks

1. Hardcoded values that violate configured token sources.
2. User-facing copy outside configured locale/copy systems.
3. Data access outside repository query/service boundaries.
4. Duplicated domain logic instead of configured canonical helpers.
5. Missing empty, loading, error, and end states.
6. Prohibited product or technology language.
7. Inline timing or motion values forbidden by config.
8. Authentication, authorization, validation, and privacy regressions.
9. Time-dependent tests using real clocks with historical fixtures.
10. Runtime-state changes lacking a physical or operational smoke plan.
11. Migration coverage that tests only a fresh schema.
12. Project facts leaked into the user-level Showrunner engine.

## Project Checks

Load additional rules from:

- `design.no_hardcode`;
- `quality_gates.audit`;
- Arc test and migration bindings;
- Sentry auth, tenancy, compliance, and public-surface bindings;
- repository guidance files.

Disabled categories are reported as `NOT APPLICABLE`, not silently omitted.

## Severity

- **Critical**: security, privacy, data-loss, main-branch, or locked product
  invariant violation. Blocks shipping.
- **Warning**: maintainability or incomplete-state issue required before merge
  by config.
- **Info**: evidence or follow-up that does not block the current arc.

## Output

```text
AUDIT REPORT - <date>

CRITICAL:
  <path:line> - finding, impact, required fix

WARNINGS:
  <path:line> - finding, impact, required fix

INFO:
  evidence and non-blocking follow-up

CLEAN:
  checked categories with no findings

VERDICT: CLEAN | FIX
```

Order findings by severity and cite real files and lines. A clean audit still
states test gaps and residual risk.
