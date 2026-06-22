# Sentry Method

Sentry separates discovery, remediation, and proof. It resolves technical
conventions autonomously, while humans own risk acceptance, compliance,
destructive migration, and operational authority.

## 1. Policy

Apply the shared decision classifier:

- Human-owned: recommend options and wait before affected work.
- Convention: resolve from repository evidence, record the default, proceed.
- Recorded risk decision: honor it until its expiry or trigger is reached.
- Adjacent security issue: assign a separate finding ID and invoke the scope
  STOP gate.

Do not equate a tool's severity with the project's final severity. Evidence,
reachability, data class, tenancy, controls, and compliance bindings determine
the recommendation; the human owns acceptance.

## 2. Session Order

1. **BIND**
   - Read config, guidance, security memory, enabled surfaces, tools, and
     standards cache metadata.
2. **SWEEP**
   - Walk every enabled category.
   - Gather evidence without changing product code or configuration.
   - Dedupe related symptoms into root-cause findings.
3. **TRIAGE**
   - Rate impact and likelihood in plain language.
   - Reconcile with accepted risks and past-finding regressions.
   - Batch human-owned decisions.
4. **FIX**
   - Select one approved finding.
   - Require Step 0, isolated ownership, tests, and atomic commits.
   - Follow `../core/debugging.md` to find the root cause and
     `../core/tdd.md` to land the fix test-first.
   - Hand off to Arc when the configured complexity boundary is crossed.
5. **VERIFY**
   - Independently review the original finding, full diff, tests, and
     regression catalog at the exact feature tip.
6. **STOP**
   - Produce a ship report and any physical or operational smoke checklist.
   - End `STOP BEFORE MERGE`.
7. **MERGE**
   - Run only after human approval.
   - Revalidate exact-tip evidence and reuse the shared ceremony.

## 3. Initialization

`init` inspects:

- enabled backend, web, mobile, AI/agentic, dependency, supply-chain, cloud,
  container, infrastructure, and edge surfaces;
- stack, authentication, authorization, tenancy, public exposure, and data
  classification;
- compliance declarations and whether CVSS is required;
- dependency, static-analysis, secret, and runtime security commands;
- security document, accepted-risk, and regression-catalog paths;
- deployment, database, backup, signing, edge, and operational ownership;
- external live-site scanner bindings, target authorization, evidence
  directories, report freshness, and privacy acknowledgement;
- browser evidence bindings, including Playwright commands, browser matrix,
  traces, screenshots, console/page errors, failed requests, CSP violations,
  network logs, authentication state, and redaction rules;
- penetration-test authorization, target, evidence, safety, emergency, and
  cleanup bindings;
- monthly cadence and digest destination.

Infer only directly evidenced mechanics. Never infer compliance posture, data
classification, risk appetite, backup authority, or operational ownership.

On a cold repository, populate missing shared-base bindings from evidence or
approved answers. Preserve every existing shared-base value. Preserve Forge and Arc sections byte-for-byte. Mark `ready` only when tenancy, compliance,
enabled surfaces, memory destinations, applicable test commands, hooks, and
merge policy resolve.

While `uninitialized`, only `/sentry init` is allowed. `disabled` rejects all
Sentry commands.

## 4. Sweep

`sweep` is read-only with respect to product code, config, and risk memory.
Reports may be written to the configured report destination.

When `sweep` follows an Arc before merge, bind it to the exact independently
verified feature tip through the expected-tip input. Record the target SHA and
reject a dirty worktree, mismatched tip, or tip change during that bound sweep.
Compare tracked worktree bytes to the target commit and reject assume-unchanged,
skip-worktree, or other special index state; porcelain status alone is not
sufficient proof of exact-tip content.
An ordinary exploratory sweep may inspect a dirty worktree but still cannot
change it. A clean result is an explicit empty finding set, not a missing report.

For each enabled catalog category:

1. inventory relevant entry points, trust boundaries, stores, and actors;
2. inspect implementation context, not isolated grep hits;
3. record evidence and counter-evidence;
4. classify confirmed, needs-human-review, accepted, stale-accepted, deferred
   runtime test, or clean;
5. map confirmed findings to standards identifiers;
6. compare with the regression catalog;
7. recommend another pass when interactions or incomplete evidence justify it.

Parallel category sweeps are allowed because they are read-only. The
orchestrator merges and deduplicates their output.

### Browser Evidence Pass

When `browser_evidence.enabled` is true, Sentry may use the configured
Playwright lane as runtime browser evidence for web frontend, auth, CSP,
headers-as-observed, client-side routing, storage, cross-origin, and failed
resource findings.

Record:

- exact command, target URL, browser projects, devices, locale/timezone, and
  whether the run is local, CI, or deployed;
- trace, HTML report, screenshots, video, and artifact directory;
- console errors, page errors, failed requests, CSP violations, and network
  observations;
- authentication state used, data boundaries, and secret-redaction evidence.

Playwright evidence can confirm reproduction or counter-evidence for a browser
finding, but it is not a full penetration test, dependency audit, external
scanner, accessibility audit, or manual device smoke. Do not submit real user
credentials or privileged sessions unless the configured owner explicitly
authorizes that storage state and evidence handling.

### External Live-Site Scanner Pass

When `sentry.external_scanners.code_quality_check.enabled` is true, Sentry may
use the configured Code Quality Check service URL as a read-only public surface
evidence source. It is not a replacement for the catalog sweep, pen test,
dependency checks, or independent verification.

Before running or requesting a scan:

- require explicit authorization for every target URL in `allowed_targets`;
- require acknowledgement that an external service may store scan results or
  report links, even when the target content is publicly visible;
- never submit authenticated sessions, private preview URLs, secrets,
  non-public admin URLs, staging environments, or customer data unless the
  configured owner explicitly authorizes that exact target and evidence
  handling;
- when `run_mode` is `manual` or `browser`, instruct the user to run the scan
  and return the report link, PDF, or pasted report text; do not pretend the
  scan was run by Sentry;
- when `run_mode` is `api`, use only the configured API or command binding and
  record exact command, time, target, and report digest;
- reject stale reports older than `evidence_freshness_days` unless the report
  is explicitly retained as historical evidence.

Normalize each scanner item before triage:

- **Security finding candidates:** exposed secrets or files, TLS/HTTPS
  configuration, HSTS, CSP, CORS, cookies, browser security headers, runtime
  CSP or unsafe-eval violations, form protection, exposed configs, and
  publicly reachable sensitive resources.
- **Ops-security actions:** DNSSEC, CAA, CDN or edge header overrides,
  certificate authority policy, WAF/CDN toggles, compression or cache settings
  with security relevance, and registrar/dashboard tasks. These require an
  action plan and human evidence; do not claim dashboard changes from repo
  diffs alone.
- **Non-security backlog:** performance, SEO, accessibility, HTML lint, JS
  lint, and general code-quality items unless they create a concrete security
  impact. Route them to Arc, Forge, UX/SEO, or a project backlog instead of
  opening Sentry fixes.
- **Scanner artifacts or needs-review:** resource-load failures, generated
  framework globals, bot challenges, transient fetch failures, missing metadata
  contradicted by server-rendered evidence, and bundle-count complaints from
  intentional code-splitting. Reproduce or collect counter-evidence before
  creating a finding.

Deduplicate related scanner symptoms into root causes. For example, a blocked
analytics beacon and a CSP violation may be one CSP decision, while DNSSEC and
CAA are separate edge/DNS actions. Do not equate the scanner's category or
severity with the final Sentry severity.

## 5. Finding Lifecycle

Every finding carries:

- stable ID and fingerprint;
- surface, category, affected locations, and evidence;
- plain-language impact and exploit preconditions;
- severity recommendation and standards mappings;
- exact remediation direction and tests;
- related findings and accepted-risk match;
- state: open, fixing, fixed-unverified, verified, accepted, or superseded.

Severity uses [knowledge/severity-rubric.md](knowledge/severity-rubric.md).
Finding IDs remain stable across passes. A reintroduction becomes a regression
of the original ID rather than an unrelated new issue.

## 6. Accepted-Risk Memory

Risk acceptance is append-only and requires:

- explicit human approval;
- the finding fingerprint, current evidence, and evidence digest;
- rationale and compensating controls;
- owner;
- acceptance and review dates;
- expiry or objective revisit trigger.

A later sweep never silently suppresses the match:

- active and materially unchanged: report `accepted`;
- expired, triggered, ownerless, or evidence-digest changed: report
  `stale-accepted` and return
  it to human triage;
- no fingerprint match: treat it as a new finding.

Do not overwrite old decisions. Supersede them with a new entry.

## 7. Fix And Arc Boundary

Before dispatch, batch severity, acceptance, compliance, migration, rollout,
and operational questions. An empty gate is explicit.

Use direct Sentry fix dispatch for a narrow change with a known pattern and no
schema, UI, or operational coupling. Hand off to `/arc plan` when the fix:

- touches three or more production files;
- changes schema or migration behavior;
- changes user-facing UI or authentication flow;
- requires coordinated rollout, feature flags, or operational work.

The handoff includes the finding, evidence, approved risk decisions, security
tests, non-goals, and regression checks. Arc owns implementation mechanics;
Sentry owns the security acceptance contract.

Interacting fixes are serialized using a touched-file and dependency graph.

## 8. Verification

`verify` checks:

- reviewed SHA equals current local and configured remote feature tip;
- the original exploit path is closed;
- the diff does not exceed the approved finding;
- tests include the vulnerable case and allowed behavior;
- adjacent surfaces and past regressions remain safe;
- migrations use representative pre-migration fixtures;
- logs, errors, and telemetry do not introduce disclosure;
- required physical or operational smoke is complete or truthfully pending;
- product bindings and provenance did not leak into the engine;
- `main` was untouched.

Verdicts are `SHIP`, `FIX`, or `REDESIGN`. `FIX` requires a new exact-tip
verification.

## 9. Penetration Testing And External Signals

`pen-test` loads the nested Pen Test skill. Active testing requires approved
Rules of Engagement, an exact target allowlist, a current testing window,
safety-class permissions, data-handling rules, emergency contacts, and cleanup
ownership. Authorization is bound to the scope and Rules of Engagement by
digest; drift returns the engagement to authorization.

The assessment lifecycle is:

1. authorize and bind scope;
2. inventory actors, entry points, assets, identities, tools, stores, and trust
   boundaries;
3. select versioned applicable tests and create a coverage ledger;
4. execute the least-impactful authorized technique;
5. independently validate claims and minimized PoCs;
6. search for root-cause variants;
7. report limitations and coverage;
8. retest remediation and clean up all test artifacts.

The target is at least 98 percent executed coverage of applicable tests, 100
percent of critical controls, and at least 95 percent per enabled domain.
Blocked, deferred, and not-run cases remain in the denominator. This measures
assessment coverage, not the probability that the target is secure.

`pen-test ingest` treats an external rating and recommendation as input, not
truth. Normalize each item, map it to catalog categories, check duplicates and
risk memory, then require human confirmation before creating fix work. The
legacy `pen-test <report-path>` form routes to the same ingestion path.

`deps` executes configured tools and classifies each advisory:

- direct-pin fixable;
- transitive-blocked;
- override candidate;
- accepted with rationale;
- false positive or not reachable, with evidence.

Dependency commands do not apply upgrades automatically. Approved upgrades
become individual fixes.

## 10. Knowledge Refresh And Monthly

The standards manifest stores authoritative locations, expected versions,
refresh modes, and last-known evidence. It does not make cached text timeless.

`refresh-knowledge`:

1. fetches through the configured adapter;
2. records retrieval time and content digest;
3. extracts the advertised version when applicable;
4. flags fetch failure, content drift, or major-version drift;
5. preserves the previous usable cache on failure;
6. never silently rewrites method policy.

`monthly` composes refresh, all enabled sweeps, dependency checks, operational
reconciliation, and accepted-risk ageing. It writes one digest and opens no fix
arc without a human decision.

## 11. Completion

A Sentry fix may request merge approval only when:

- Step 0 was approved;
- every commit is on the feature branch;
- configured security and regression tests pass;
- ship report and remote-tip evidence are complete;
- independent verification says `SHIP` on the current exact tip;
- required smoke is complete or explicitly awaits the human;
- the response ends `STOP BEFORE MERGE`.
