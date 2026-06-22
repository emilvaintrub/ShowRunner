---
name: sentry
description: Sweep, triage, test, fix, verify, and maintain software security posture with categorical coverage, governed penetration testing, durable accepted-risk memory, refreshable standards knowledge, isolated fixes, and an unconditional stop before main. Use when initializing security bindings, reviewing application, mobile, agentic, cloud, supply-chain, infrastructure, or operational surfaces, planning or running an authorized penetration test, ingesting an external assessment, accepting a documented risk, running a monthly security cycle, refreshing standards pins, or merging an independently verified security fix.
---

# Sentry

Find security weaknesses systematically, preserve human risk decisions, and
stop every code fix before `main`.

## Load

1. Read `../core/method.md`.
2. Read the active project's `.claude/showrunner/config.md`.
3. Read [method.md](method.md).
4. Load [knowledge/catalog.md](knowledge/catalog.md) for sweeps.
5. Load [knowledge/standards.md](knowledge/standards.md) only for mapping or
   refresh.
6. Load `../core/dispatch.md` for `fix`.
7. Load `../core/merge.md` for `verify` or `merge`.
8. Load [pen-test/SKILL.md](pen-test/SKILL.md) for `pen-test`.
9. Load only the template required by the requested command.

## Route

- `init`: infer security bindings, preserve shared and sibling config, and
  optionally create a project security document.
- `sweep <category|all>`: perform a read-only categorical review, ingest any
  configured external live-site scanner evidence such as Code Quality Check,
  collect configured browser evidence such as Playwright traces and console or
  network observations,
  and reconcile findings with accepted-risk and regression memory.
- `fix <finding-id>`: resolve human-owned decisions, dispatch one isolated fix,
  verify evidence, and stop before merge.
- `verify <finding-id>`: independently review the exact feature tip against the
  original finding and regression catalog.
- `accept <finding-id>`: append an evidence-backed risk decision with owner,
  expiry, and revisit trigger.
- `deps`: run configured dependency tools and classify direct, transitive,
  override, and accepted cases.
- `pen-test init|plan|run|validate|retest|report|abort|ingest`: route a
  governed assessment through the nested Pen Test skill.
- `pen-test <report-path>`: compatibility alias for `pen-test ingest
  <report-path>`.
- `monthly`: refresh knowledge, sweep, audit dependencies, age accepted risks,
  and write one digest without starting fixes.
- `refresh-knowledge`: fetch authoritative pins through the configured adapter,
  cache evidence, and flag drift.
- `merge`: after exact-tip `SHIP`, required smoke, and explicit approval, reuse
  the shared two-commit ceremony.

## Hard Stops

- Never modify product code during `sweep`, `deps`, `pen-test`, or `monthly`.
- Never allow active penetration testing without approved, current,
  hash-bound authorization and Rules of Engagement.
- Never represent test-case coverage as a percentage guarantee of security.
- Never treat a scanner match as a confirmed finding without contextual
  evidence.
- Never submit a target to an external live-site scanner without configured
  authorization, allowed target scope, and privacy acknowledgement.
- Never treat browser evidence as a replacement for Sentry triage, penetration
  testing, dependency review, or required human smoke.
- Never accept risk without explicit human approval and a revisit condition.
- Never hide an accepted-risk match; report it as accepted or stale.
- Never authorize fix edits before Step 0 approval.
- Never widen a fix when it exposes an adjacent finding.
- Never use cached standards without reporting their retrieval date.
- Never issue `SHIP` unless the verdict names the exact local and remote tip.
- Never merge without independent `SHIP`, required smoke, and explicit human
  approval.
- Never import facts or wording from another project.
