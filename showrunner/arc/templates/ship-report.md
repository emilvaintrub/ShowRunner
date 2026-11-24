# Ship Report - <arc>

## Status

`STOP BEFORE MERGE`

Base: `<sha>`

Feature branch: `<branch>`

Feature tip: `<sha>`

Remote tip: `<sha or disabled>`

Approved source digest: `<sha256 or not applicable>`

Autonomy level: `high | medium | run`

## Delivered

- <behavioral outcome>

## Scope

- In scope: <summary>
- Deferred: <adjacent findings>
- Deviations: <approved deviations or none>

## ShowRunner Decisions

Always present. Write `none` when empty. At Run, the owner sees this list at
the end gate and can veto any entry; a veto returns to `build`.

| What | Options | Chosen | Why | Spec anchor |
| --- | --- | --- | --- | --- |
| <convention default, spec interpretation, deferred adjacent item, or model-tier escalation> | <options considered> | <choice> | <reason> | <spec section, or none> |

## Rules Learned

Always present. Write `none` when no root cause was a pattern likely to recur,
or `project.lessons: disabled` when lessons are off. The architect appends
each rule to `project.lessons` in the merge hygiene commit
(`core/debugging.md` section 5); the implementer never writes the log.

| Scope | Rule | Evidence (reproduction, test, fix commit) | Traps | Supersedes |
| --- | --- | --- | --- | --- |
| `<path or glob>`, or global | <one-sentence rule> | <failure observed>; `<test>`; `<sha>` | <what looks right but is not> | <L-id or none> |

## Commits

```text
<sha> <subject>
```

## Verification

- `<command>`: PASS | FAIL
- Audit: CLEAN | FIX | disabled
- Creative gate: SHIP | FIX FIRST | REDESIGN | disabled
- Build or bundle: PASS | FAIL | disabled
- Browser evidence:
  - Tool: Playwright | disabled
  - Command: <exact command or disabled>
  - Target: <base URL, browser projects, devices, locale/timezone>
  - Result: PASS | FAIL | blocked | disabled
  - Artifacts: <trace.zip, HTML report, screenshots, video, console/page errors,
    failed requests, CSP violations, network log, or disabled>
  - Auth/redaction: <storage state and secret-redaction evidence, or disabled>

## Data And Compatibility

- Migrations: <evidence or none>
- Flags: <enabled and disabled behavior>
- Dependencies: <changes or none>
- Locale and accessibility: <evidence or disabled>

## Smoke

- Required: yes | no
- Status: complete | pending | disabled
- Environment: <web browser, Android device/emulator, iOS device/simulator,
  backend/dashboard, or disabled>
- Commands:
  1. <exact setup/build command, for example npm install, npm run build,
     npm run dev, build APK, install APK, start server, curl endpoint, or
     disabled>
- Manual steps:
  1. <user action>
- Expected result: <observable pass condition>
- Evidence returned: <screenshot, link, APK path, logs, response body, or
  pending>
- Blocker handling: <who to contact, what to stop, or not applicable>

## Residual Risks

- <risk or none>

## Dispatch Cost

Model: <model the platform reports, or model routing: unavailable from adapter>

Escalations: <tier change and reason, or none>

Token usage: <value or unavailable from adapter>

## Ownership

- Primary branch touched: no
- Approved Forge direction changed: no | not applicable
- Prompt artifacts cleaned: yes | not applicable

`STOP BEFORE MERGE`
