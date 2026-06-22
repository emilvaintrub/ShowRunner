# Accepted-Risk Rules

Accepted-risk memory is append-only. Match by stable fingerprint, not title
alone.

Required fields:

- finding ID and fingerprint;
- status and severity at acceptance;
- evidence and affected scope;
- rationale and compensating controls;
- approving human and owner;
- accepted date and review date;
- expiry date or objective revisit trigger;
- trigger status and material-change state;
- digest of the evidence and conditions accepted;
- superseded entry, when applicable.

Re-sweep states:

- `accepted`: fingerprint and material conditions still match.
- `stale-accepted`: expired, triggered, ownerless, or materially changed.
- `open`: no valid matching decision.

Never delete history or silently suppress a match.
