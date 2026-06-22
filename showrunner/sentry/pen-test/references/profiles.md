# Assessment Profiles

Select only evidenced surfaces. Each profile augments the shared authorization,
inventory, validation, reporting, and cleanup lifecycle.

## Web And API

Import versioned WSTG test IDs and map them to discovered routes, roles, state
changes, browser contexts, APIs, uploads, callbacks, and business workflows.
Cover information gathering, deployment configuration, identity,
authentication, authorization, sessions, input/output handling, errors,
cryptography, business logic, client behavior, and APIs.

## Native Mobile

Map MASVS and MASTG cases to storage, cryptography, authentication, network,
platform integration, code quality, privacy, and resilience. Separate static,
emulator, and physical-device evidence. Device-only checks remain `deferred`
until executed; static review cannot pass them.

## Agentic And AI

Inventory goals, instructions, memory, retrieval sources, models, tools,
machine identities, agent-to-agent messages, output consumers, and
consequential actions. Exercise:

- goal and instruction integrity;
- tool authorization, parameter validation, rates, and egress;
- identity lifecycle, audience binding, and least agency;
- model, prompt, plugin, tool, MCP, dataset, and dependency provenance;
- unsafe code execution and output interpretation;
- memory and context poisoning;
- inter-agent authentication, authorization, integrity, and replay;
- cascade containment, budgets, timeouts, and circuit breakers;
- human approval and trust boundaries;
- rogue behavior detection, revocation, kill switches, and recovery.

Never treat prompt wording as the sole control for authorization or isolation.

## Cloud, IaC, Containers, And Kubernetes

Reconcile declared infrastructure with deployed state. Cover IAM, machine
identities, secrets, network boundaries, storage, encryption, logging, KMS,
backup/recovery, serverless permissions, IaC plans, cluster policies, workload
identity, admission, image provenance, runtime restrictions, registries,
orchestration, and drift.

## Supply Chain And CI/CD

Inventory source, build, package, model, dataset, image, action, and deployment
inputs. Cover lockfiles, package admission, maintainer and provenance risk,
SBOM/AIBOM completeness, signatures, build isolation, artifact attestations,
CI permissions, untrusted input into automation, secret exposure, release
integrity, and dependency reachability.

## Network And Infrastructure

Use only when explicitly enabled. Cover exposed services, segmentation,
administrative protocols, patch/configuration state, identity boundaries,
monitoring, and recovery. Network discovery remains bounded to the allowlist.

## Operational Resilience And Privacy

Cover logging and detection, alert ownership, incident response, key and token
rotation, backup restore, fail-safe behavior, data minimization, retention,
export, deletion, telemetry, and evidence handling.
