# Security Sweep - <scope>

Date: `<date>`

Pass: `<number>`

Standards cache as of: `<date and status>`

Target tip: `<sha>`

Product code modified: `no`

Config or risk memory modified: `no`

## Coverage

| Surface | Category | Result | Evidence |
| --- | --- | --- | --- |
| <surface> | <category> | clean / findings / deferred | <paths or reason> |

## External Scanner Evidence

| Scanner | Target | Report date | Fresh | Evidence |
| --- | --- | --- | --- | --- |
| Code Quality Check | <public URL> | <date> | yes / no | <report link, PDF, pasted text digest, or not configured> |

### External Scanner Triage

- Security finding candidates:
  - <headers, CSP, CORS, TLS, exposed files/secrets, cookies, runtime browser
    protection issue, or none>
- Ops-security actions:
  - <DNS, CDN, edge, registrar, certificate-authority, or dashboard task, or
    none>
- Non-security backlog:
  - <performance, SEO, accessibility, HTML/JS lint, or quality item routed
    outside Sentry, or none>
- Scanner artifacts or needs-review:
  - <transient/browser/framework/scanner artifact and required counter-evidence,
    or none>

## Browser Evidence

| Tool | Target | Browser/device | Result | Artifacts |
| --- | --- | --- | --- | --- |
| Playwright | <base URL> | <browser/device/locale/timezone> | pass / fail / blocked / disabled | <trace, HTML report, screenshots, video, logs> |

- Console errors:
- Page errors:
- Failed requests:
- CSP violations:
- Network observations:
- Auth/storage state and redaction:
- Security relevance:

## Findings

| ID | Severity | State | Summary | Accepted-risk match |
| --- | --- | --- | --- | --- |
| <id> | <tier> | open | <summary> | none |

## Accepted And Stale Risks

- `<id>`: accepted | stale-accepted, with reason.

## Regression Check

- `<past id>`: clear | reintroduced as `<id>-R<n>`.

## Deferred Runtime Tests

- <device or operational check and owner>

## Decision Gate

- Human-owned decisions:
- Convention defaults:

## Next Pass

<Recommendation and reason, or not recommended.>
