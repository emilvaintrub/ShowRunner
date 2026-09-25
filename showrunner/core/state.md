# State Ledger

The state ledger is the conductor's memory. It records where each initiative
stands and every gate it has passed. A stage is complete only when the ledger
says so; artifact status lines, summaries, and recollection are not evidence.

## Location And Ownership

- Path: `.claude/showrunner/state.md` in the primary worktree, created by the
  `setup` stage from [templates/state.md](templates/state.md).
- ShowRunner writes it. The owner reads it. Implementers never write it.
- Worktrees and enforcement scripts read the primary worktree's copy
  (`git rev-parse --git-common-dir`), so a dispatched implementer and the
  conductor always see the same state.
- Commit ledger changes with the planning artifacts they record, using a
  `docs(showrunner): <summary>` commit on the primary branch, and in the merge
  hygiene commit. Never rewrite committed rows.

## Shape

The file holds one YAML block, then two append-only Markdown tables. Keep the
YAML flat: enforcement scripts read it with line tools, not a YAML parser.

```yaml
schema_version: 1
project:
  primary_branch: "main"
  setup: "pending | complete"
  owner_profile: "pending | guide | challenge | both"
  verdict: "pending | proceed | validate-first | pivot | stop"
  constitution: "pending | approved"
  business_docs: "pending | none | <comma-separated selected documents>"
active:
  initiative: "<id or none>"
  title: "<short title or none>"
  stage: "<stage id from lifecycle.md>"
  status: "in-progress | awaiting-owner | blocked | parked"
  awaiting: "<what the owner must supply, or none>"
  feature_branch: "<branch or none>"
  step0_approved: "no | <approved contract digest>"
  fix_loops: 0
  release_authorized: "no | yes"
  resume: "<exact next action if a turn stopped mid-stage, or none>"
queue:
  - "<id> - <title>"
parked:
  - "<id> - release held until <trigger>"
guard:
  writable_before_build:
    - ".claude/showrunner/*"
    - ".claude/settings.json"
    - "<configured hooks path>/*"
    - "<every configured planning, report, and output path or glob>"
  release_patterns:
    - "<deploy or publish command prefix the owner must authorize>"
```

`guard.writable_before_build` lists the paths ShowRunner may write outside the
`build` stage: the config and ledger, constitution, decision log, project
state, specs, briefs, plans, prompts, ship, sweep, and Bible outputs, the
hygiene ledger, and the enforcement files setup installs (`.claude/settings.json`
and the hooks path). Setup derives it from the config; anything not listed is
product code.

`guard.release_patterns` lists command prefixes that publish or deploy
(for example a hosting CLI's production deploy or a package publish). Setup
proposes them from repository evidence; the owner confirms them at `release`.

### Initiatives Table

```markdown
| Initiative | Title | Opened | Owner request (verbatim) | Stage | Status |
| --- | --- | --- | --- | --- | --- |
| I-001 | <title> | <date> | "<the owner's words>" | <stage> | <status> |
```

### Gate Ledger

```markdown
| # | Initiative | Stage | Outcome | Approver | Date | Artifact | Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | project | setup | passed | showrunner | <date> | .claude/showrunner/config.md@sha256:<hex> | <what was validated> |
| 2 | I-001 | roadmap | approved | owner | <date> | docs/state.md@sha256:<hex> | "<owner's exact words>" |
```

Outcomes:

| Outcome | Meaning | Allowed approver |
| --- | --- | --- |
| `passed` | a ShowRunner-owned stage met its exit record | `showrunner` |
| `approved` | the owner approved an owner gate | `owner` |
| `not-applicable` | `design` or `design-review` only, owner-confirmed | `owner` |
| `waived` | owner waiver under lifecycle section 5 | `owner` |
| `fix` | a non-terminal verification or security loop | `showrunner` |
| `held` | release deferred by the owner, with a trigger | `owner` |
| `released` | owner-authorized release executed and checked | `owner` |

`passed`, `approved`, `not-applicable`, `waived`, and `released` are terminal.
`held` is terminal for `release` only.

## Recording Rules

- Use `project` as the initiative for the project stages: `setup`,
  `discovery`, `assessment`, `constitution`, and `business-docs`.
- The Artifact column names the approved file as `path@sha256:<hex>` of its
  exact bytes at approval, or `commit:<sha>` for branch and merge gates.
- An owner row's Evidence column quotes the owner verbatim, in quotes. Replace
  a `|` in the quote with `/`. Never paraphrase, summarize, or infer approval.
  A reply that answers some gates and not others approves only those it names.
- A ShowRunner row's Evidence names the concrete check: the command and
  result, the verdict and tip, or the gate report path.
- Re-opening a stage appends a new row; it never edits an old one.
- When an artifact changes after its gate row, the old approval no longer
  covers it. Re-run the gate or append a row explaining the change and who
  approved it.

## Validation

`showrunner check` (see [enforcement.md](enforcement.md)) reads this file and
fails when:

- the active stage is not a known stage;
- any earlier stage for the active initiative, or any project stage, lacks a
  terminal row (while a project stage is active, every earlier project stage
  needs one);
- an owner-gate stage is closed by `showrunner`, or an owner row has no quoted
  evidence;
- `not-applicable` is used outside `design` and `design-review`;
- a non-waivable stage is `waived`;
- `build` or a later implementation stage is active without an approved
  Step 0 digest and a feature branch.

It warns when an artifact's current bytes no longer match its latest row.

Run it at every session start, before every stage transition, and in CI when
the project enables it.
