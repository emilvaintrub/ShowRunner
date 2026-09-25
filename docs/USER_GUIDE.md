# ShowRunner User Guide

ShowRunner is a workflow for building software with an AI coding agent while
keeping product decisions, implementation, security, and architecture evidence
separate.

ShowRunner is the conductor: it runs the whole process from your idea to
release, and you act as the business owner.

## The Four Policies

ShowRunner uses four policies as instruments. You do not pick between them;
the stage decides.

| Policy | Stages | It produces |
| --- | --- | --- |
| Forge | Constitution, roadmap, spec, design, design review, handoff | Constitution, project plan, spec, design brief, decision log. |
| Arc | Build plan, Step 0, build, verify | Step 0 contract, implementation plan, branch work, verification, ship report. |
| Sentry | Security, plus read-only sweeps and monthly cycles | Sweep reports, findings, accepted-risk records, security ship reports. |
| Bible | Close | A read-only architecture/capabilities document bound to evidence. |

## First-Time Setup In A Project

1. Download ShowRunner into its own folder.
2. Run `install.ps1` from the ShowRunner folder.
3. If you use Cursor or VS Code, pass your real project folder as
   `-ProjectRoot`. This is the folder that contains the app, website, or tool
   you want the agent to work on.
4. Open that target project folder in your agent/editor.
5. Ask: `Initialize ShowRunner for this repository.`
6. The agent creates `.claude/showrunner/config.md` and the state ledger
   `.claude/showrunner/state.md`, and installs the safety hooks.
7. Answer only the business questions it cannot infer from files.
8. If the product has no constitution yet, ShowRunner interviews you for it
   next. After that, just tell it what you want.

The config is the project binding. It records where decisions, plans, tests,
smoke, browser evidence, context hygiene, security memory, and Bible output
live.

Simple folder rule:

- Run ShowRunner install commands from the downloaded `ShowRunner` folder.
- Run normal project work from your own project folder.
- Use `-ProjectRoot` only when an editor needs instruction files written into
  that project.

## How You Work With ShowRunner

You are the business owner. You bring the idea, the product IP, and the
business decisions. ShowRunner runs the whole process, from your first
request to release, and tells you at every stop what it needs from you.

You do not need to know any command. Say what you want in plain words:

```text
I want customers to be able to pay by invoice.
The onboarding feels confusing - let's fix it.
What's the status?
```

ShowRunner opens the request as an initiative, runs every stage in order, and
moves on by itself. It pauses only when a stage needs your decision, your
approval, or something only you can supply.

## The Stages

Every initiative goes through every stage. There is no shortcut for small
changes: a one-line fix gets a short spec, not a skipped one.

| # | Stage | What happens | What you do |
| --- | --- | --- | --- |
| P1 | Setup (once) | ShowRunner reads your repository, fills its config, installs its safety hooks. | Answer only the business questions it cannot work out. |
| P2 | Constitution (once) | ShowRunner interviews you about the product's purpose, people, voice, and limits. | Approve each lasting claim. |
| 1 | Intake | Your request is recorded in your own words. | Nothing. |
| 2 | Roadmap | The request is placed in the plan: phase, success evidence, screens and flows affected. | Approve. |
| 3 | Spec | Product decisions are laid out with options and a recommendation, then written up. | Decide, then redline. |
| 4 | Design | ShowRunner researches, proposes 2-3 directions, recommends one, and writes a design brief. | Choose and approve. Confirm "not applicable" if nothing is design-dependent. |
| 5 | Design review | You run the brief in your design tool and return the output; ShowRunner reviews it. | Return the output; approve it. |
| 6 | Handoff | The build contract is written and the spec is marked ready to build. | Approve. |
| 7 | Build plan | ShowRunner plans the implementation. | Only if a business question comes up. |
| 8 | Step 0 | A separate worker describes back what it will build; ShowRunner checks and approves it. | Nothing - you get a short summary. |
| 9 | Build | The worker builds on its own branch, test-first. | Nothing. |
| 10 | Verify | ShowRunner independently reviews the actual changes, audit, and design quality. | Nothing. |
| 11 | Security | Sentry checks the change for security issues. | Only if a risk needs your acceptance. |
| 12 | Acceptance | You get a step-by-step test script for a real build. | Run it; report the result. |
| 13 | Merge | The change joins the main branch through a fixed two-commit ceremony. | Approve the merge. |
| 14 | Release | ShowRunner asks how, when, and where to release. It never decides this for you. | Tell it: now, scheduled, or hold; where; who runs it; how to check and roll back. |
| 15 | Close | The architecture document and project state are updated; the next item is proposed. | Approve the close. |

## Who Decides What

You decide: product direction, scope, brand, voice, privacy, pricing, design,
risk acceptance, the acceptance test result, merging, releasing, and whether
to skip anything.

ShowRunner decides: technical setup, implementation approach, code
conventions, the pre-build check (Step 0), verification verdicts, security
review, and housekeeping. It will not ask you technical questions it can
answer from the repository.

## Skipping A Stage

ShowRunner never proposes skipping. If you ask it to hurry or skip, it tells
you which stages would be skipped and what could go wrong, and recommends the
full path. If you still want to skip, you say so in your own words and it is
recorded. Some stages can never be skipped: setup, Step 0, verification, your
merge approval, and the release question.

## Release And Deploy

Release is always your call. After a merge, ShowRunner shows you what is
ready, what it found about release in the repository, and the risks, then
asks you for: release now, schedule, or hold; target environments; who runs
the steps; the exact steps; the post-release check; and the rollback plan. It
runs release steps only when you authorize the exact steps, and its safety
hooks block deploy commands at any other time.

## The State Ledger

`.claude/showrunner/state.md` in your project records where every initiative
stands and every approval, with your exact words. It is how ShowRunner resumes
after a break without asking you to repeat yourself, and how you can audit
what was approved. A stage is complete only when the ledger says so.

## Safety Hooks

Setup installs Git hooks and, for Claude Code, session hooks:

- product code can change only in the build stage, after Step 0, on the
  feature branch;
- commits on the main branch are limited to planning documents, except during
  an approved merge;
- hook bypasses, force-pushes to main, and unauthorized deploy commands are
  blocked;
- every session starts with a reminder of the current stage.

Codex, Cursor, and VS Code follow the same process from written instructions
and the Git hooks.

## Commands (Optional)

Commands still exist for power users. They run inside the process: a command
for a stage whose earlier stages are not done is refused with the reason.

```text
/showrunner status | next | resume
/forge init | discover | plan | spec | design | design-review | decide
/arc init | plan | run | verify | merge
/sentry init | sweep | fix | verify | accept | deps | pen-test | monthly | refresh-knowledge | merge
/bible init | sync | merge
```

Sentry and Bible can also run read-only at any time (for example
`/sentry sweep all`). Active penetration testing and external live-site
scanning require explicit authorization and target scope.

## Merge Rule

Every change stops before `main`. Merge requires:

- ShowRunner's approved Step 0;
- scoped commits on the feature branch;
- exact tests and gates;
- independent verification on the current tip;
- a completed security stage;
- your acceptance test result;
- your merge approval.

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
Initialize ShowRunner for this repository.
Here's my idea: ...
What's the status?
Continue.
I approve the spec.
Hold the release until the marketing launch on the 3rd.
```

## What To Avoid

- Do not ask for code directly; describe the outcome and let the process run.
- Do not ask Arc to invent missing product direction.
- Do not treat a scanner report as a confirmed vulnerability without Sentry triage.
- Do not merge because tests passed; merge only after independent verification and approval.
- Do not put project-specific facts into the reusable ShowRunner skill package.
