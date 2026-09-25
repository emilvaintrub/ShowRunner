"""Shared fixture-building helpers for the ShowRunner eval suite.

Not a case itself (no case.yaml / prompt.md here), so `claude plugin eval`
case discovery never treats this directory as a case. Each case's
`context.scaffold_script` calls `build.py <case-id>` in this directory, which
uses these helpers to build a small git repository in the run's workspace
whose `.claude/showrunner/state.md` ledger passes `showrunner check`.

Mirrors the style of the architect's reference generators
(make_fixture.py / make_state.py / make_post_setup.py) but generalized so one
library serves all cases instead of one script per scenario family.
"""
import os
import subprocess

STAGE_ORDER = [
    "setup", "discovery", "assessment", "constitution", "business-docs",
    "intake", "roadmap", "spec", "design", "design-review", "handoff",
    "arc-plan", "step0", "build", "verify", "security", "acceptance",
    "merge", "release", "close",
]
PROJECT_STAGES = STAGE_ORDER[:5]
INIT_CHAIN = STAGE_ORDER[5:]
SHOWRUNNER_ONLY = {"intake", "step0", "build", "verify"}
SHOWRUNNER_STYLE = SHOWRUNNER_ONLY | {"arc-plan", "security"}

GIT_ENV = {
    **os.environ,
    "GIT_CONFIG_GLOBAL": "/dev/null",
    "GIT_CONFIG_SYSTEM": "/dev/null",
}


def sh(root, *args):
    subprocess.run(args, cwd=root, check=True, capture_output=True, env=GIT_ENV)


def write(root, path, content):
    p = os.path.join(root, path)
    d = os.path.dirname(p)
    if d:
        os.makedirs(d, exist_ok=True)
    with open(p, "w") as f:
        f.write(content)


def git_init(root):
    sh(root, "git", "init", "-q", "-b", "main")
    sh(root, "git", "config", "user.email", "owner@example.com")
    sh(root, "git", "config", "user.name", "Owner")


def git_commit(root, msg):
    sh(root, "git", "add", "-A")
    sh(root, "git", "commit", "-q", "--allow-empty", "-m", msg)


def git_branch(root, name):
    sh(root, "git", "branch", name)


def proj_row(stage, outcome=None, approver=None, evidence=None, artifact="-",
             date="2026-09-01"):
    """One Gate Ledger row for a project stage (initiative column = "project")."""
    if outcome is None:
        if stage == "setup":
            outcome, approver = "passed", "showrunner"
        else:
            outcome, approver = "approved", "owner"
    if evidence is None:
        evidence = "config validated, hooks installed" if stage == "setup" else '"Approved."'
    return ("project", stage, outcome, approver, date, artifact, evidence)


def init_row(initiative, stage, evidence=None, artifact="-", date="2026-09-10"):
    """One Gate Ledger row for an initiative-chain stage."""
    if stage in SHOWRUNNER_STYLE:
        outcome, approver = "passed", "showrunner"
        if evidence is None:
            evidence = "see artifacts"
    else:
        outcome, approver = "approved", "owner"
        if evidence is None:
            evidence = '"Approved."'
    return (initiative, stage, outcome, approver, date, artifact, evidence)


def proj_rows_upto(stage):
    """All project-stage rows strictly before `stage`, plus `stage` itself if
    it is a project stage (used when the active stage IS a project stage)."""
    idx = PROJECT_STAGES.index(stage) if stage in PROJECT_STAGES else len(PROJECT_STAGES)
    return [proj_row(s) for s in PROJECT_STAGES[:idx]]


def proj_rows_all(business_evidence='"None for now."'):
    """All five project-stage rows, terminal (used once an initiative is active)."""
    rows = [proj_row(s) for s in PROJECT_STAGES[:4]]
    rows.append(proj_row("business-docs", evidence=business_evidence))
    return rows


def init_rows_upto(initiative, stage, overrides=None):
    """All initiative-chain rows strictly before `stage` for `initiative`.
    `overrides` maps stage -> evidence string to customize a specific row."""
    overrides = overrides or {}
    idx = INIT_CHAIN.index(stage)
    return [init_row(initiative, s, evidence=overrides.get(s)) for s in INIT_CHAIN[:idx]]


def base_active(**over):
    d = dict(
        initiative="none", title="none", stage="intake", status="in-progress",
        awaiting="none", feature_branch="none", step0_approved="no",
        fix_loops=0, release_authorized="no", resume="none",
    )
    d.update(over)
    return d


def render_state(active, initiatives=(), outcome_reviews=(), ledger_rows=(),
                  guard_extra=(), release_patterns=()):
    L = [
        "# ShowRunner State - Fixture", "",
        "```yaml", "schema_version: 1", "project:",
        '  primary_branch: "main"', '  setup: "complete"',
        '  constitution: "approved"', "active:",
    ]
    for k, v in active.items():
        L.append(f"  {k}: {v}" if k == "fix_loops" else f'  {k}: "{v}"')
    L += ["queue: []", "parked: []", "guard:", "  writable_before_build:",
          '    - ".claude/showrunner/*"']
    for g in guard_extra:
        L.append(f'    - "{g}"')
    if release_patterns:
        L.append("  release_patterns:")
        for p in release_patterns:
            L.append(f'    - "{p}"')
    else:
        L.append("  release_patterns: []")
    L.append("```")
    L += ["", "## Initiatives", "",
          "| Initiative | Title | Opened | Owner request (verbatim) | Stage | Status |",
          "| --- | --- | --- | --- | --- | --- |"]
    for row in initiatives:
        L.append("| " + " | ".join(row) + " |")
    L += ["", "## Outcome Reviews", "",
          "| Initiative | Metric | Target (works / does not) | Source | Review date | Result | Owner's follow-up (verbatim) |",
          "| --- | --- | --- | --- | --- | --- | --- |"]
    for row in outcome_reviews:
        L.append("| " + " | ".join(row) + " |")
    L += ["", "## Gate Ledger", "",
          "| # | Initiative | Stage | Outcome | Approver | Date | Artifact | Evidence |",
          "| --- | --- | --- | --- | --- | --- | --- | --- |"]
    for i, row in enumerate(ledger_rows, 1):
        L.append(f"| {i} | " + " | ".join(row) + " |")
    L.append("")
    return "\n".join(L)


def write_state(root, *args, **kwargs):
    write(root, ".claude/showrunner/state.md", render_state(*args, **kwargs))


def render_config(forge_status="ready", business_selected="[]", distribution="saas"):
    return f'''# ShowRunner Config

```yaml
schema_version: 1
project:
  name: "Shelfie"
  primary_branch: main
  remote: disabled
  guidance_files: ["README.md"]
  decision_log: "docs/decisions.md"
  project_state: "docs/project-state.md"
  hygiene_ledger: "docs/project-state.md"
questions:
  max_per_round: 5
lifecycle:
  state_file: ".claude/showrunner/state.md"
  fix_loop_limit: 3
tests:
  commands:
    unit: "npm test"
smoke:
  playbooks:
    web:
      commands: ["npm run dev"]
      manual_steps: ["open http://localhost:3000"]
      expected_result: "page renders"
      evidence: "screenshot"
release:
  owner_supplied: true
  known_mechanics: ["vercel.json found in repository root"]
  environments: ["pending"]
  executor: "pending"
  post_release_check: "pending"
  rollback: "pending"
ownership:
  register: "docs/accounts-register.md"
business:
  registers: "docs/business/research-registers.md"
  docs_directory: "docs/business"
  selected: {business_selected}
  geography: "Germany"
  currency: "EUR"
  research:
    web_required: required
    min_sources: 10
    min_competitors: 5
    freshness_days: 365
    independent_audit: true
forge:
  status: {forge_status}
  soul_file: "docs/constitution.md"
  outputs:
    specs_directory: "docs/specs"
    designer_briefs_directory: "docs/briefs"
  creative_gate:
    gate: "gates/wow-check.md"
pitch:
  status: ready
arc:
  status: ready
  planning:
    plans_directory: "docs/plans"
sentry:
  status: ready
  tenancy: {{model: "single-tenant"}}
  compliance: {{regimes: ["none"]}}
  license_policy:
    distribution: "{distribution}"
    allowed: ["MIT", "BSD-2-Clause", "BSD-3-Clause", "Apache-2.0", "ISC"]
    review_required: ["LGPL-*", "MPL-2.0", "EPL-*"]
    blocked_without_owner_decision: ["GPL-*", "AGPL-*", "SSPL-*", "unknown"]
bible:
  status: ready
  output:
    path: "docs/bible.md"
```
'''


APP_FILES = {
    "package.json": (
        '{\n  "name": "shelfie",\n  "version": "0.1.0",\n  "scripts": {\n'
        '    "test": "node --test",\n    "dev": "node src/server.js"\n  }\n}\n'
    ),
    "src/server.js": (
        "const http=require('http');\n"
        "http.createServer((q,r)=>{r.end(require('./page')())}).listen(3000);\n"
    ),
    "src/page.js": (
        "module.exports=()=>`<html><body><h1>Shelfie</h1>"
        "<p>Track the books you lend to friends.</p>"
        "<footer>(c) 2024 Shelfie</footer></body></html>`;\n"
    ),
    "test/page.test.js": (
        "const t=require('node:test');const a=require('assert');"
        "t('renders',()=>a.match(require('../src/page')(),/Shelfie/));\n"
    ),
    "README.md": "# Shelfie\n\nA tiny web app to track books you lend to friends.\n",
    "vercel.json": '{"version": 2}\n',
}

CONSTITUTION = '''# Product Constitution - Shelfie

> Authority: foundational
> Status: approved
> Approved by: owner
> Approved on: 2026-09-01

## Core Belief
Lending a book is an act of trust; getting it back should not cost the friendship.

## Product Truths
### 1. Friends, not transactions
No fines, deadlines, or shaming.

## The Job
Remember who has which book, gently.

## Voice
- Warm, brief, lightly playful.

## What This Product Will Never Be
- A marketplace or a social feed.
- Ad-supported.
'''

PROJECT_STATE = '''# Project State - Shelfie

> Authority: operational
> Status: current
> As of: 2026-09-10

## Current Phase
**MVP web**

## Completed
- Landing page skeleton.

## Next
1. Record a loan.

## Surfaces
- Home page
- Loan list

## Open Questions
- none
'''

DECISIONS = (
    "# Decision Log\n\n## Decision D-001 - Web first\n\n**Date:** 2026-09-01\n"
    "**Status:** approved\n**Decision:** Ship a web app before mobile.\n"
)

DISCOVERY_BRIEF = '''# Discovery Brief - Clinic Scheduler

> Status: owner-confirmed
> Owner profile: challenge

## The Idea In The Owner's Words

> "A B2B scheduling tool for dental clinics in Germany, EUR 49 per chair per month."

## Coverage

All twelve domains answered or open - to validate (see answers).

### D1 Owner goals
Sustainable business, EUR 60,000 own savings [OWNER], full time for 18 months [OWNER].
### D2 Problem
Front-desk staff spend hours on phone scheduling and no-shows [OWNER].
### D3 Customers
Independent dental practices with 2-6 chairs in Germany [OWNER].
### D4 Alternatives
Owner knows of Doctolib; others open - to validate.
### D6 Model
Subscription per chair [OWNER]; price open - to validate.
### D8 Legal
Patient data - GDPR; open - to validate.
'''


def app_base(root):
    for path, content in APP_FILES.items():
        write(root, path, content)


def shelfie_docs(root):
    write(root, "docs/constitution.md", CONSTITUTION)
    write(root, "docs/project-state.md", PROJECT_STATE)
    write(root, "docs/decisions.md", DECISIONS)


def accounts_register(rows, summary_rows=()):
    header = (
        "# Accounts Register - Shelfie\n\n"
        "| Service | Used for | Account holder | Login identity | Billing owner | "
        "2FA (owner-confirmed) | Recovery held by | Others with access (role, revoke by) | "
        "Credentials stored in | Status |\n"
        "| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |\n"
    )
    body = "".join("| " + " | ".join(r) + " |\n" for r in rows)
    footer = (
        "\n## Owner Summary\n\n"
        "| What the product depends on | Who controls it | Risk | Action to fix |\n"
        "| --- | --- | --- | --- |\n"
    )
    footer += "".join("| " + " | ".join(r) + " |\n" for r in summary_rows)
    return header + body + footer


def ideas_log(rows):
    header = (
        "# Ideas Log - Shelfie\n\n"
        "## Ideas\n\n"
        "| ID | Date | Raised during | Owner's words (verbatim) | Level | Impact map | "
        "Build effect | Owner's choice | Status | Revisit trigger |\n"
        "| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |\n"
    )
    body = "".join("| " + " | ".join(r) + " |\n" for r in rows)
    return header + body + "\n## Steer Sessions\n"
