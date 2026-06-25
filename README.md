# ShowRunner

Forge the direction. Arc the build. Sentry the risk. Bible the system.

ShowRunner is a project-neutral workflow skill for AI-assisted software
delivery. It turns fuzzy requests into approved direction, verified
implementation arcs, security posture, penetration-test governance, browser
evidence, and architecture synthesis.

![Status](https://img.shields.io/badge/status-ready-2ea44f)
![Policies](https://img.shields.io/badge/policies-Forge%20%7C%20Arc%20%7C%20Sentry%20%7C%20Bible-5B6CFF)
![Context](https://img.shields.io/badge/context-hygiene-5B6CFF)
![Codex](https://img.shields.io/badge/Codex-skill-111827)
![Claude Code](https://img.shields.io/badge/Claude%20Code-skill-111827)
![Cursor](https://img.shields.io/badge/Cursor-rules-111827)
![VS Code](https://img.shields.io/badge/VS%20Code-instructions-111827)

<img width="1024" height="572" alt="image" src="https://github.com/user-attachments/assets/9eeaf7e5-13a3-4e68-86cf-10d75dcea9dd" />

## Why It Exists

AI coding agents are fast, but speed is not the same as control. ShowRunner
adds a disciplined lifecycle around them:

- Product decisions are explicit;
- Implementation starts only after Step 0 approval;
- Security findings are triaged instead of blindly accepted from scanners;
- Design gets research and expert synthesis when the user is not a specialist;
- Browser evidence and smoke are concrete;
- Architecture docs are generated from evidence, not vibes;
- Long sessions can use an optional context optimizer before the work gets
  fuzzy;
- Every build or fix stops before `main`.

## TL;DR

In plain English: first download ShowRunner into its own folder. Then, if you
use Cursor or VS Code, point the installer at the folder of the project you
actually want to build.

Download ShowRunner:

```powershell
git clone https://github.com/emilvaintrub/ShowRunner.git
cd ShowRunner
```

Install it for Codex and Claude Code on this computer:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -Target codex,claude
```

Then open your own project folder in your agent and ask:

```text
Initialize ShowRunner for this repository.
```

For Cursor or VS Code, replace `C:\path\to\your-project` with the real folder
of the app/site/tool you want ShowRunner to manage:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -Target cursor,vscode -ProjectRoot C:\path\to\your-project
```

## What You Get

| Policy | Job | Command family |
| --- | --- | --- |
| Forge | Product direction, planning, specs, design, decisions. | `/forge init|discover|plan|spec|decide|design` |
| Arc | Implementation planning, Step 0, branch work, verification, merge stop. | `/arc init|plan|run|verify|merge` |
| Sentry | Security sweeps, fixes, dependency triage, external scanner ingestion, pen-test governance. | `/sentry init|sweep|fix|verify|accept|deps|pen-test|monthly|refresh-knowledge|merge` |
| Bible | Evidence-bound architecture and capability synthesis. | `/bible init|sync|merge` |

## Install

There are two folders involved:

- **ShowRunner folder**: where you downloaded this repository. Run
  `install.ps1` from here.
- **Your project folder**: the app, website, tool, or repository you want the
  AI agent to work on. Use this path for `-ProjectRoot`.

### Codex

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -Target codex
```

Manual install:

```powershell
Copy-Item -Recurse .\showrunner "$env:USERPROFILE\.codex\skills\showrunner"
```

The repository also includes `.codex-plugin/plugin.json` plus a plugin-facing
wrapper under `skills/showrunner/` for Codex plugin packaging workflows that
consume local plugin manifests.

### Claude Code

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -Target claude
```

Manual install:

```powershell
Copy-Item -Recurse .\showrunner "$env:USERPROFILE\.claude\skills\showrunner"
```

The repository also includes `.claude-plugin/plugin.json` and
`.claude-plugin/marketplace.json` metadata for Claude Code plugin marketplace
flows. Manual install remains the most predictable path on Windows.

### Cursor

Install project instructions into your project folder. Replace
`C:\path\to\your-project` with the folder you normally open in Cursor:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -Target cursor -ProjectRoot C:\path\to\your-project
```

This creates `.cursor/rules/showrunner.mdc` in the target project.

### VS Code / GitHub Copilot

Install project instructions into your project folder. Replace
`C:\path\to\your-project` with the folder you normally open in VS Code:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -Target vscode -ProjectRoot C:\path\to\your-project
```

This creates `.github/copilot-instructions.md` in the target project.

### Everything Local

This installs both the computer-wide skills and the project-local instruction
files. Replace `C:\path\to\your-project` with your actual project folder:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -Target all -ProjectRoot C:\path\to\your-project
```

Use `-Force` to replace an existing local install.

### Install Notes

- On Windows, run PowerShell from the repository root and keep
  `-ExecutionPolicy Bypass` on the command if local policy blocks scripts.
- `-Target codex` and `-Target claude` install reusable skills into the user's
  home directory.
- `-Target cursor` and `-Target vscode` write project-local instruction files
  into the project folder passed with `-ProjectRoot`.
- Use `-WhatIf` to preview file writes before installing.
- Use `-Force` only when you intend to replace an existing local ShowRunner
  skill or instruction file.

## Operating The Workflow

Read the full [user guide](docs/USER_GUIDE.md).

The short version:

1. Run `/forge init` or ask the agent to initialize ShowRunner.
2. Use Forge to discover, plan, specify, design, and record decisions.
3. Use Arc only after direction is approved.
4. Use Sentry for security posture, external scanner triage, dependency review,
   pen-test governance, and verified security fixes.
5. Use Bible to synthesize architecture and capabilities from current evidence.
6. Stop before merge. Always.

## Design Is Expert-Led

If the user gives sparse input, ShowRunner does more work, not less. Forge
asks for examples, researches the domain when configured, synthesizes multiple
directions, explains tradeoffs, recommends one, and writes a no-thin-design
brief.

## Security Is Evidence-Led

Sentry treats scanners as input, not truth. It can ingest:

- dependency and audit tools;
- external live-site scanner reports;
- Playwright browser evidence;
- governed penetration-test reports;
- accepted-risk memory.

It then classifies items as confirmed findings, ops-security actions,
non-security backlog, scanner artifacts, or needs-human-review.

## Browser Evidence

ShowRunner supports Playwright as a browser evidence lane. It can capture
traces, screenshots, videos, HTML reports, console errors, page errors, failed
requests, CSP violations, and network observations.

Browser evidence supports verification. It does not replace human smoke,
security triage, penetration testing, or approval.

## Context Hygiene

ShowRunner can use an optional context optimizer before long arcs, broad
security sweeps, Bible syncs, and post-compaction resumes. 
Token Optimizer (https://github.com/alexgreensh/token-optimizer) is
one supported companion when installed separately under its own license;
ShowRunner does not vendor or require it.

Example project config:

```yaml
context_optimizer:
  enabled: true
  provider: token-optimizer
  commands:
    health: "/token-optimizer quick"
    audit: "/token-optimizer"
    coach: "/token-coach"
  required_before: ["long_arc", "sentry_full_sweep", "bible_sync"]
```

Context hygiene is advisory. It does not replace reading source evidence, Step
0 approval, tests, smoke, Sentry triage, or merge approval.

## Package Contents

This repository contains the installable workflow package and public operating
instructions. Internal construction notes, acceptance fixtures, and build
history are intentionally not included.

## Repository Shape

```text
showrunner/
  SKILL.md
  core/
  forge/
  arc/
  sentry/
  bible/
  gates/
  scripts/
```

The reusable package stays under `showrunner/`. Project-specific evidence stays
inside each target project, usually under `.claude/showrunner/`.

## License

ShowRunner is released under the [MIT License](LICENSE).

See [SECURITY.md](SECURITY.md) and [PRIVACY.md](PRIVACY.md) for reporting and
data-handling guidance.
