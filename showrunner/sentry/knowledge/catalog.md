# Security Catalog

Load only categories enabled by project config. Each category requires an
inventory, contextual evidence, counter-evidence, and an explicit clean or
deferred result.

## Backend And API

- Authorization: object, property, function, tenant, role, and administrative
  boundaries.
- Authentication: enrollment, recovery, session lifecycle, token handling,
  brute-force resistance, and identity-provider trust.
- Input and output: injection, unsafe deserialization, file handling, SSRF,
  redirect, template, and response disclosure.
- Data: classification, encryption, secrets, retention, backups, logs, export,
  deletion, and migration states.
- Design and operations: abuse cases, rate and resource limits, errors,
  inventory, third-party consumption, monitoring, and fail-safe defaults.

Primary mappings: `owasp-top-10`, `owasp-api-top-10`, `owasp-asvs`,
`cwe-top-25`, and `nist-digital-identity`.

## Web Frontend

- DOM injection and unsafe rendering.
- CSRF, CORS, cookies, browser storage, tokens, and cross-origin messaging.
- CSP, Trusted Types, framing, transport, referrer, permissions, and cache
  headers.
- Sensitive data in bundles, source maps, telemetry, errors, or local state.
- Dependency loading, integrity, redirects, uploads, and service workers.

## Native Mobile

- Storage, cryptography, authentication, network, platform, code, privacy, and
  resilience controls.
- Deep links, WebView bridges, exported components, screenshots, backups,
  logging, clipboard, signing, and update policy.
- Mark device-only checks `deferred-runtime-test`; static evidence cannot pass
  them.

Primary mappings: `owasp-masvs` and `owasp-mobile-top-10`.

## AI And LLM

- Inventory every model input, audience, data source, tool, output sink, and
  consequential action.
- Check prompt injection, cross-audience disclosure, supply chain, data or
  model poisoning, unsafe output handling, excessive agency, prompt leakage,
  embedding isolation, misinformation, and unbounded consumption.
- Prefer audience separation, least privilege, deterministic validation, and
  bounded resources over claims that prompting alone provides isolation.

Primary mapping: `owasp-llm-top-10`.

## Agentic Systems And Machine Identities

- Inventory goals, instructions, models, memory, retrieval sources, tools,
  agent-to-agent channels, machine identities, output consumers, and every
  consequential action.
- Check goal hijack, tool misuse, action authorization, identity lifecycle,
  privilege and least-agency boundaries, supply-chain provenance, code
  execution, memory poisoning, message integrity, replay, cascading failure,
  human trust exploitation, rogue behavior, revocation, kill switches, and
  recovery.
- Require per-action authorization, scoped and short-lived credentials,
  bounded resources and egress, observable goal/tool transitions, and human
  checkpoints for high-impact actions.

Primary mappings: `owasp-agentic-top-10`, `owasp-nhi-top-10`, and
`owasp-llm-top-10`.

## Dependencies And Build

- Audit direct and transitive dependencies, lockfiles, registries, build
  scripts, release provenance, CI permissions, and update policy.
- Evaluate package admission, maintainer and provenance risk, signatures,
  artifact attestations, SBOM completeness, reachability, and reproducibility.
- Record reachability and runtime exposure.
- Never dismiss development tooling without checking where and how it runs.

Primary mappings: `osv`, `owasp-top-10`, and `cwe-top-25`.

## CI, Supply Chain, And AI Inventory

- Inventory source, action, package, image, model, dataset, tool, plugin,
  protocol server, build, and release inputs.
- Check untrusted input into automation, workflow permissions, secret exposure,
  package and image admission, repository ownership, build isolation,
  provenance, signatures, release integrity, and dependency confusion.
- Generate or validate SBOM and AIBOM artifacts. Record components that cannot
  be identified, scanned, or traced to an approved source.
- Treat inventories as point-in-time evidence and regenerate them after
  dependency, model, dataset, or build changes.

Primary mappings: `cyclonedx`, `owasp-agentic-top-10`, `osv`, and
`nist-ssdf`.

## Cloud, IaC, Containers, And Orchestration

- Reconcile intended infrastructure, plans, deployed state, and unmanaged
  resources.
- Check IAM and workload identity, secrets, network boundaries, storage,
  encryption, logging, KMS, backup and restore, serverless permissions, and
  environment isolation.
- Check IaC modules and plans, cluster admission, RBAC, service accounts,
  network policy, workload restrictions, image provenance, registry policy,
  runtime permissions, and resource limits.
- Record drift and unsupported resource types; absence from a scanner is not
  evidence of a secure configuration.

Primary mappings: `nist-ssdf`, `owasp-nhi-top-10`, and applicable provider or
orchestrator baselines configured by the project.

## Detection, Response, Recovery, And Privacy

- Verify security logging, alert ownership, incident response, token and key
  rotation, revocation, kill switches, backup restoration, fail-safe behavior,
  and recovery exercises.
- Check data minimization, classification, consent where applicable, retention,
  export, deletion, telemetry, evidence access, and disposal.
- Require operational or physical evidence for controls that cannot be proven
  from code or configuration.

## Edge, DNS, Email, And Deployment

- TLS, HSTS, DNS ownership, origin exposure, WAF and rate policy, cache keys,
  certificate lifecycle, security contact, sender authentication, secrets,
  environment isolation, and administrative access.
- Produce an action plan and verification commands. Do not claim a dashboard
  change occurred without human-supplied evidence.

## Evidence Rule

A confirmed finding states:

1. reachable entry point and actor;
2. missing or bypassed control;
3. affected asset or data class;
4. concrete impact;
5. exact file, symbol, endpoint, configuration, or external evidence;
6. counter-evidence considered;
7. remediation and regression test.

Pattern matches without this context remain `needs-human-review`.

## Coverage Rule

Sweeps are categorical. Penetration tests use versioned test-case ledgers. A
test counts as executed only when retained evidence supports `pass`, `finding`,
`accepted`, or `rejected`. `blocked`, `deferred`, and `not-run` remain
applicable gaps; `not-applicable` requires inventory-backed justification.
