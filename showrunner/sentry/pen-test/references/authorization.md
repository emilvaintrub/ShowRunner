# Authorization And Safety

## Safety Classes

| Class | Meaning | Examples |
| --- | --- | --- |
| `S0` | Offline or passive | Source/config review, architecture analysis, supplied traffic |
| `S1` | Low-impact active | Normal requests, header checks, bounded enumeration with test identities |
| `S2` | State-changing in disposable scope | Test-account workflows, controlled uploads, isolated callback tests |
| `S3` | Elevated-impact proof | Exact line-item approval, recovery plan, observer, and immediate stop path required |

Authorization for a class is a ceiling, not a requirement to use it. Select the
lowest class that can answer the test question.

Use numeric ceilings for request rate, concurrency, and payload size. Terms
such as `unlimited` or `reasonable` are not limits.

Each `S3` authorization names one approved catalog test, approving owner,
approval evidence, service-health observer, recovery plan, and stop path. A
general `S3` ceiling does not authorize any individual `S3` action.

## Generic Workflow Prohibitions

Do not execute:

- denial of service or resource exhaustion;
- persistence, lateral movement, or privilege use beyond the proof required;
- real sensitive-data extraction or transfer;
- destructive production actions or irreversible state changes;
- social engineering, physical access, or wireless testing;
- credential stuffing, broad password attacks, or third-party account testing;
- log deletion, artifact concealment, or evasion of the engagement audit trail.

Record those prohibitions as explicit machine-readable tokens in every active
engagement; descriptive prose alone does not satisfy the runtime gate.

A separate specialist engagement may define different permissions, but those
permissions do not flow into this workflow.

## Stop Conditions

Stop active testing when:

- the approved window or credentials expire;
- a target, redirect, integration, or data owner is outside scope;
- service health degrades or monitoring indicates instability;
- unexpected personal, regulated, customer, or production data appears;
- the emergency contact or configured kill switch requests a stop;
- evidence handling cannot follow the approved rules;
- the required observer or recovery mechanism is unavailable for `S3`.

Record the last completed test, target state, cleanup work, and notification.
