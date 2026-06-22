# Finding Validation

## Claim Record

For every suspected finding record:

- exact claim and root cause;
- authorized target, actor, and entry point;
- attacker-controlled source and affected sink or control;
- required state and preconditions;
- concrete confidentiality, integrity, availability, privacy, or trust impact;
- evidence and counter-evidence;
- compensating controls and environment assumptions;
- smallest safe reproduction;
- related variants.

## Confidence Gate

`confirmed` requires:

1. a reachable authorized path;
2. attacker influence over the trigger;
3. a missing or bypassed control;
4. a reproducible security impact;
5. a PoC or equivalent evidence independently checked against the claim.

Use `likely` when impact is strongly supported but safe reproduction is
incomplete. Use `needs-review` for ambiguous context or insufficient evidence.
Use `rejected` when a control, precondition, or PoC failure disproves the claim.

## PoC Rules

- Minimize requests, payload, privileges, and data.
- Use synthetic identifiers and disposable accounts.
- Prove the impact without collecting real sensitive records.
- Make expected and observed results explicit.
- Include cleanup and retest instructions.
- Keep the validator independent from the original discovery reasoning.

## Variant Analysis

After confirmation, identify the root-cause pattern and search the full
authorized scope. Generalize one element at a time and review every added
match. Stop broadening a query when false positives overwhelm useful signal.

Do not close the finding until the original path and confirmed variants have
been retested.
