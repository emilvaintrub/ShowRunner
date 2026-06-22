# Sentry Ship Report - <finding-id>

## Status

`STOP BEFORE MERGE`

Base: `<sha>`

Feature branch: `<branch>`

Feature tip: `<sha>`

Remote tip: `<sha or disabled>`

## Finding

- ID and fingerprint:
- Original exploit path:
- Approved remediation:

## Scope

- Changed:
- Deferred adjacent findings:
- Deviations:

## Verification

- Vulnerable-case regression: PASS | FAIL
- Allowed-case regression: PASS | FAIL
- Security commands: PASS | FAIL
- Browser evidence:
  - Tool: Playwright | disabled
  - Command: <exact command or disabled>
  - Target: <base URL, browser projects, devices, locale/timezone>
  - Result: PASS | FAIL | blocked | disabled
  - Artifacts: <trace.zip, HTML report, screenshots, video, console/page errors,
    failed requests, CSP violations, network log, or disabled>
  - Auth/redaction: <storage state and secret-redaction evidence, or disabled>
- Audit: CLEAN | FIX
- Regression catalog: PASS | FAIL

## Data And Operations

- Migration:
- Dependencies:
- Logs and telemetry:
- Runtime or operational smoke:
  - Required: yes | no
  - Environment: <service, dashboard, web browser, mobile device, cloud
    console, or disabled>
  - Commands:
    1. <exact setup/build/security command, for example npm install, npm run
       build, build APK, install APK, start server, curl endpoint, scan
       command, or disabled>
  - Manual steps:
    1. <human action>
  - Expected result: <observable pass condition>
  - Evidence returned: <screenshot, link, APK path, logs, response body,
    dashboard event, or pending>
  - Blocker handling: <kill switch, rollback, contact, or not applicable>

## Residual Risk

- <risk or none>

## Dispatch Cost

Token usage: <value or unavailable from adapter>

## Ownership

- Primary branch touched: no
- Prompt artifacts cleaned: yes | not applicable

`STOP BEFORE MERGE`
