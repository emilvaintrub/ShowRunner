# ShowRunner State - <project>

> Authority: operational. Written only by ShowRunner; see
> `core/state.md` in the ShowRunner package. Owner approvals are quoted
> verbatim. Rows are append-only.

```yaml
schema_version: 1
project:
  primary_branch: "main"
  setup: "pending"
  owner_profile: "pending"
  verdict: "pending"
  constitution: "pending"
  business_docs: "pending"
active:
  initiative: "none"
  title: "none"
  stage: "setup"
  status: "in-progress"
  awaiting: "none"
  feature_branch: "none"
  step0_approved: "no"
  fix_loops: 0
  release_authorized: "no"
  resume: "none"
queue: []
parked: []
guard:
  writable_before_build:
    - ".claude/showrunner/*"
    - ".claude/settings.json"
    - ".githooks/*"
  release_patterns: []
```

## Initiatives

| Initiative | Title | Opened | Owner request (verbatim) | Stage | Status |
| --- | --- | --- | --- | --- | --- |

## Gate Ledger

| # | Initiative | Stage | Outcome | Approver | Date | Artifact | Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- |
