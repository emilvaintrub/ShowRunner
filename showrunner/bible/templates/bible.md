# Bible - <project name>

Generated at commit: `<sha>`

Audience: `<engineering | capabilities | combined>`

Sources: `<Forge spec path>`, `<Arc ship report path(s)>`, `<Sentry sweep
report path(s)>`, `<Sentry security document path>`, `<pen-test report
path(s) or none>`

Every row below cites the repository path, interface, or named report that
backs it. A row with no citation is not rendered.

# Part I - Architecture

## 1. System Overview

<one paragraph, what the system is and does>

Source: `<Forge spec path>` S1 (Intent)

## 2. Component Map

| Component | Responsibility | Path |
| --- | --- | --- |
| <name> | <responsibility> | `<path>` |

## 3. Data Model

| Entity | Relationships | Ownership / Tenancy | Source |
| --- | --- | --- | --- |
| <entity> | <relationships> | <ownership or tenancy> | `<schema or migration path>` |

## 4. Interfaces & Contracts

| Interface | Kind | Path |
| --- | --- | --- |
| <name> | <endpoint, API, or contract> | `<defining file>` |

## 5. Dependencies

| Dependency | Version | Source |
| --- | --- | --- |
| <name> | <version present in the repository> | `<manifest path>` |

## 6. Deploy Topology

<environments and edge/DB/deploy targets>

Source: Sentry config block (`sentry.deploy`, `sentry.edge_provider`,
`sentry.database`)

## 7. Key Decisions

| Decision | Source |
| --- | --- |
| <material architectural decision> | `<decision log or ship report path>` |

# Part II - Capabilities

## 1. What The System Does

| Capability | Implementing Surface | Source |
| --- | --- | --- |
| <capability, in user terms> | `<path or interface>` | `<Forge spec section or Arc ship report>` |

## 2. Surfaces

| Surface | Type | Source |
| --- | --- | --- |
| <screen, flow, or endpoint> | <ui or api> | `<path>` |

## 3. Limits & Non-Goals

| Boundary | Source |
| --- | --- |
| <explicit out-of-scope item> | `<Forge spec section>` |

## 4. Security & Accepted Risks

<one-paragraph summary of the protection layers and posture>

See `<Sentry security document path>` for the full threat model. This section
is a summary with a pointer, not a restatement.

| Accepted Risk | Source |
| --- | --- |
| <id and summary> | `<accepted-risk memory path>` |

## 5. Intent-Not-Shipped

| Spec-Promised Capability | Spec Source | Status |
| --- | --- | --- |
| <capability named in the spec but absent from the extraction> | `<Forge spec section>` | not found in repository extraction |
