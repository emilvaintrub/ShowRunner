# ShowRunner User Guide

ShowRunner is a workflow for building software with an AI coding agent while
keeping product decisions, implementation, security, and architecture evidence
separate.

## The Four Policies

| Policy | Use it when | It produces |
| --- | --- | --- |
| Forge | You need product direction, a plan, a spec, a design brief, or a durable decision. | Constitution, project plan, spec, design brief, decision log. |
| Arc | You have approved direction and want implementation. | Step 0 contract, implementation plan, branch work, verification, ship report. |
| Sentry | You need security review, dependency triage, scanner ingestion, pen-test governance, or a fix. | Sweep reports, findings, accepted-risk records, fix prompts, security ship reports. |
| Bible | You need the current architecture and capability map. | A read-only architecture/capabilities document bound to evidence. |

## First-Time Setup In A Project

1. Download ShowRunner into its own folder.
2. Run `install.ps1` from the ShowRunner folder.
3. If you use Cursor or VS Code, pass your real project folder as
   `-ProjectRoot`. This is the folder that contains the app, website, or tool
   you want the agent to work on.
4. Open that target project folder in your agent/editor.
5. Ask: `Initialize ShowRunner for this repository.`
6. The agent should create or update `.claude/showrunner/config.md` in your
   project folder.
7. Answer only the project-specific questions it cannot infer from files.

The config is the project binding. It records where decisions, plans, tests,
smoke, browser evidence, context hygiene, security memory, and Bible output
live.

Simple folder rule:

- Run ShowRunner install commands from the downloaded `ShowRunner` folder.
- Run normal project work from your own project folder.
- Use `-ProjectRoot` only when an editor needs instruction files written into
  that project.

## Normal Flow

### 1. Forge

Use Forge before implementation.

Useful prompts:

```text
/forge discover
/forge plan
/forge spec
/forge design
/forge decide
```

Forge should ask clear questions, recommend options, and wait for your
approval on product, scope, brand, privacy, monetization, or risk decisions.

Design is not limited to graphical UI. It can cover workflow, content,
operations, accessibility, service design, and interaction states. Sparse input
triggers an expert research pass, not a thin brief.

### 2. Arc

Use Arc after direction is approved.

```text
/arc plan
/arc run
/arc verify
/arc merge
```

Arc starts with Step 0 describe-back. The agent must explain what it will do,
which files it verified, what tests it will run, what smoke is required, and
which decisions are already approved. No edits happen until Step 0 is approved.

When configured, Arc includes Playwright/browser evidence for UI, routing,
auth, CSP, hydration, and browser-runtime changes.

### 3. Sentry

Use Sentry for security posture and remediation.

```text
/sentry sweep all
/sentry deps
/sentry pen-test init
/sentry fix <finding-id>
/sentry verify <finding-id>
/sentry accept <finding-id>
/sentry monthly
```

Sentry treats scanners as evidence, not truth. It normalizes dependency tools,
external live-site scanner reports, Playwright traces, and pen-test findings
into confirmed findings, ops-security actions, non-security backlog, or
needs-review artifacts.

Active penetration testing and external live-site scanning require explicit
authorization and target scope.

### 4. Bible

Use Bible after the project has evidence to synthesize.

```text
/bible init
/bible sync
/bible merge
```

Bible is read-only over product code. It maps architecture and capabilities
from Forge, Arc, Sentry, pen-test reports, and repository structure.

## Merge Rule

Every implementation or fix stops before `main`.

Merge requires:

- approved Step 0;
- scoped commits on the feature branch;
- exact tests and gates;
- independent verification on the current tip;
- required smoke or explicit pending status;
- human approval.

## Plain-Language Status Words

- `committed`: saved as a named Git checkpoint. Not deployed, not merged, not released.
- `SHIP`: independently verified and ready to ask for merge approval.
- `FIX`: return to branch work and re-verify the new exact tip.
- `REDESIGN`: approved direction is inadequate or unsafe; go back to Forge.
- `STOP BEFORE MERGE`: the agent must not touch `main` until you approve merge.

## Smoke And Browser Evidence

Human smoke must be specific: commands, build artifacts, manual steps,
expected result, and evidence to return.

Browser evidence, usually Playwright, can add traces, screenshots, videos,
console errors, page errors, failed requests, CSP violations, and network logs.
It supports verification but does not replace human smoke or security judgment.

## Context Hygiene

For long sessions, ShowRunner can call or suggest a configured context
optimizer before the work gets hard to track. This is useful before large Arc
runs, full Sentry sweeps, Bible syncs, or after compaction.

Token Optimizer can be used as a companion if the project owner installs it
separately. In config, enable it like this:

```yaml
context_optimizer:
  enabled: true
  provider: token-optimizer
  commands:
    health: "/token-optimizer quick"
    audit: "/token-optimizer"
    coach: "/token-coach"
```

If the optimizer is not installed, the agent should say so plainly and continue
with the normal ShowRunner gates. Context hygiene does not replace source
reading, Step 0 approval, tests, smoke, security review, or merge approval.

## Good User Prompts

```text
Use ShowRunner to initialize this repo.
Forge a plan for the next release.
The UI is not designed yet. Run the design phase properly.
Arc this approved spec, one phase at a time.
Run a Sentry sweep and triage external scanner findings.
Create the Bible for this repo from current evidence.
Run context hygiene before this long arc.
```

## What To Avoid

- Do not ask Arc to invent missing product direction.
- Do not treat a scanner report as a confirmed vulnerability without Sentry triage.
- Do not merge because tests passed; merge only after independent verification and approval.
- Do not put project-specific facts into the reusable ShowRunner skill package.
