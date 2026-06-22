# Pen Test Method

The method separates authorization, discovery, execution, proof, and closure.
The tester may choose technical mechanics from repository and environment
evidence, but the authorizing human owns scope, timing, safety permissions,
third-party access, data handling, and emergency authority.

## 1. Authorization

Create an engagement record from `schemas/engagement.schema.json` and
`assets/rules-of-engagement.md`. Require:

- authorizing owner and approval evidence;
- exact target allowlist and exclusions;
- environment, testing window, source identity, and test accounts;
- permitted safety classes and explicitly prohibited actions;
- request-rate and resource ceilings;
- data handling, evidence storage, retention, and disclosure rules;
- emergency contact, stop conditions, and cleanup owner;
- third-party and shared-infrastructure boundaries.

Hash the approved scope inventory, applicable-test catalog, and Rules of
Engagement. Resolve relative references from the engagement bundle. Every later
artifact records those hashes. A mismatch or expired window returns the
engagement to `AUTH`; `abort` remains available outside the window and during
scope, catalog, or Rules of Engagement drift so target interaction can stop.

## 2. Inventory

Build the attack surface before selecting tests:

1. actors and privilege levels;
2. public, authenticated, administrative, machine, agent, callback, and
   asynchronous entry points;
3. state-changing operations and consequential actions;
4. data stores, secrets, models, tools, identities, queues, and external
   dependencies;
5. trust boundaries, deployment boundaries, and third-party ownership;
6. controls that may distort testing, including WAFs, rate limits, feature
   flags, sandboxes, and monitoring.

Record inventory confidence and unresolved unknowns. A final report cannot
claim complete public-surface coverage while unknown public entry points remain.

## 3. Plan

Select applicable profiles and import versioned test identifiers from the
configured standards cache into an approved, hashed catalog. Derive the plan
from that catalog rather than generating an unbound denominator. For each test:

- bind it to a target, actor, entry point, and expected control;
- set the safety class and permitted tool class;
- define evidence, success, stop, and cleanup criteria;
- mark dependencies and required human checkpoints;
- justify `not-applicable` using inventory evidence.

Require 100 percent planned coverage for critical controls. Planning coverage
does not count as executed coverage.

## 4. Execute

Recheck authorization immediately before each active batch. Prefer the least
impactful technique that can prove or disprove the hypothesis:

1. source, configuration, and architecture evidence;
2. passive observation and recorded traffic;
3. low-impact active requests;
4. authenticated tests with disposable data;
5. separately approved higher-impact proof.

Use bounded concurrency, rates, payload sizes, recursion, and timeouts. Capture
only the minimum request, response, code, configuration, or telemetry needed to
reproduce the result. Redact at collection time where practical.

`S3` execution additionally requires line-item approval for the exact catalog
test, a named service-health observer, a recovery plan, and an immediate stop
path.

## 5. Validate

Separate discovery from confirmation. Independently validate claims and
minimized PoCs. For each suspected finding:

1. restate the exact claim, root cause, trigger, actor, and impact;
2. trace the source-to-control-to-impact path and counter-evidence;
3. reproduce with the smallest safe PoC;
4. verify the PoC proves the claim rather than a nearby symptom;
5. challenge environmental assumptions and compensating controls;
6. search for root-cause variants across the full authorized scope;
7. assign `confirmed`, `likely`, `needs-review`, or `rejected`.

Only `confirmed` findings enter the fix queue automatically. `likely` and
`needs-review` remain visible and require human disposition.

## 6. Report

Report:

- engagement identity, authorization and scope hashes, dates, and limitations;
- inventory completeness and unresolved unknowns;
- coverage by domain, critical-control coverage, and stale evidence;
- confirmed and unresolved findings with redacted reproduction artifacts;
- rejected findings when their exclusion affects interpretation;
- remediation direction, owner, and retest requirement;
- cleanup and evidence-disposition status.

Coverage describes executed test cases, not the probability that the system is
secure. Reconcile every ledger row with the approved catalog, target and
entry-point inventory, retained evidence file, current authorization, and the
engagement-approved evidence-freshness interval.

## 7. Retest And Cleanup

Retest the original exploit path and allowed behavior using the minimum
authorized steps. Then search for the validated root-cause variants. Close a
finding only when evidence shows the original and variant paths are resolved.

Remove test accounts, data, files, callbacks, tokens, payloads, and temporary
access. If immediate cleanup is unsafe or impossible, record an owner, deadline,
and compensating control. Preserve only evidence authorized by the Rules of
Engagement.

## 8. Sentry Handoff

Normalize confirmed findings into Sentry IDs and fingerprints. Include
authorization metadata, affected inventory items, standard mappings, evidence
digest, exploit preconditions, remediation direction, regression test, and
retest requirement. Sentry owns acceptance and remediation; Pen Test owns the
assessment evidence.
