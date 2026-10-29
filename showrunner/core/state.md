# State Ledger

The state ledger is the conductor's memory. It records where each initiative
stands and every gate it has passed. A stage is complete only when the ledger
says so; artifact status lines, summaries, and recollection are not evidence.

## Location And Ownership

- Path: `lifecycle.state_file` in `.claude/showrunner/config.md`, relative to
  the primary worktree (default `.claude/showrunner/state.md`), created by the
  `setup` stage from [templates/state.md](templates/state.md). The value must
  be relative, with no leading `/` and no `..`; a non-default path must be
  listed in `guard.writable_before_build`. Choose a path outside `.claude/`
  when the host refuses or keeps asking about writes there (Claude Code asks
  before writing under `.claude/`, and non-interactive runs refuse).
- ShowRunner writes it. The owner reads it. Implementers never write it.
- Worktrees and enforcement scripts read the primary worktree's copy
  (`git rev-parse --git-common-dir`), so a dispatched implementer and the
  conductor always see the same state.
- Commit ledger changes with the planning artifacts they record, using a
  `docs(showrunner): <summary>` commit on the primary branch, and in the merge
  hygiene commit. Never rewrite committed rows.

## When A Ledger Write Is Refused

If the host refuses a write to the ledger (a permission prompt the owner
declined, or a non-interactive mode that denies it):

- Say so in one line, naming the file.
- Never route around the refusal: no shell redirection, script, or other tool
  to write the ledger instead.
- Finish the stage work that does not depend on the write, in the same turn.
- Show the exact rows and fields that are pending, so nothing is lost.
- Ask the owner to allow the write, or to set `lifecycle.state_file` to a
  path the host lets ShowRunner write.
- The recorded stage does not advance until the ledger says so.

## Shape

The file holds one YAML block, then append-only Markdown tables. Keep the
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
  autonomy: "high | medium | run"
  escalations: 0
  release_authorized: "no | yes"
  resume: "<exact next action if a turn stopped mid-stage, or none>"
people:
  - "<name> | <role> | <comma-separated stages this person may approve>"
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
`build` stage: the config and ledger, constitution, decision log, ideas log, feedback log, accounts register, project
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

### Outcome Reviews

```markdown
| Initiative | Metric | Target (works / does not) | Source | Review date | Result | Owner's follow-up (verbatim) |
| --- | --- | --- | --- | --- | --- | --- |
| I-001 | <metric> | <target> | <named source> | <YYYY-MM-DD> | pending / met / partly met / missed / inconclusive | "<owner's words>" |
```

Added at `close` from the initiative's roadmap entry; updated when the review
runs ([outcomes.md](outcomes.md)). Validation experiments use the same table
with the experiment id in the Initiative column.

### Gate Ledger

```markdown
| # | Initiative | Stage | Outcome | Approver | Date | Artifact | Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | project | setup | passed | showrunner | <date> | .claude/showrunner/config.md@sha256:<hex> | <what was validated> |
| 2 | I-001 | roadmap | approved | owner | <date> | docs/state.md@sha256:<hex> | "<owner's exact words>" |
```

Outcomes:

The Approver column is `showrunner`, `owner`, or `delegate:<name>` where
`<name>` matches a `people` entry exactly. In the tables below, "owner" means
the owner or a delegate listed for that stage; `constitution`, `assessment`,
`release`, and every `waived` outcome accept `owner` only.

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

### Autonomy Changes

```markdown
| Initiative | From | To | Date | Reason or owner words (verbatim) |
| --- | --- | --- | --- | --- |
| I-001 | medium | run | <date> | "<the owner's words>" |
```

Append-only. `From` and `To` are `high`, `medium`, or `run`. The first row for
an initiative is written at `handoff`, with `From` equal to the config default
(`lifecycle.autonomy.default`). The last row's `To` must equal
`active.autonomy`. The last column quotes the owner verbatim; the only
exception is an automatic downgrade from `run` to `medium`, whose reason starts
with `auto-downgrade:` (for example `auto-downgrade: 4 escalations`). See
[autonomy.md](autonomy.md).

### Owner Checkpoints

```markdown
| Initiative | Stage | Date | Owner words (verbatim) |
| --- | --- | --- | --- |
| I-001 | step0 | <date> | "<the owner's words>" |
```

Append-only, used at High only. `Stage` is `arc-plan`, `step0`, `verify`, or
`security`. A row records the owner's "go" after that ShowRunner-owned stage
passed; it never replaces the stage's gate row. At High, the next stage may not
have a ledger row until the checkpoint row exists.

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
- a `delegate:<name>` row names someone not in `people`, a stage not
  delegated to them, or a stage that can never be delegated, or is a `waived`
  outcome;
- `not-applicable` is used outside `design` and `design-review`;
- a non-waivable stage is `waived`;
- `build` or a later implementation stage is active without an approved
  Step 0 digest and a feature branch;
- `active.autonomy`, when present, is not `high`, `medium`, or `run` (a missing
  key means `medium`);
- an Autonomy Changes row has a `From` or `To` outside that set;
- the last Autonomy Changes row for the active initiative has a `To` that
  differs from `active.autonomy`;
- `active.autonomy` is `high` or `run`, the active initiative has a `handoff`
  row, and it has no Autonomy Changes row;
- an Autonomy Changes upgrade row (towards less control) is dated at or after
  the initiative's `step0` row, other than the initiative's first Autonomy
  Changes row;
- an Autonomy Changes or Owner Checkpoints row has no quoted owner words, other
  than a `run` to `medium` row whose reason starts with `auto-downgrade:`;
- an Owner Checkpoints row names a stage other than `arc-plan`, `step0`,
  `verify`, or `security`;
- `active.autonomy` is `high` and a later stage has a ledger row with no
  matching checkpoint row (`step0` needs `arc-plan`, `build` needs `step0`,
  `security` needs `verify`, `acceptance` needs `security`), counting only
  rows dated on or after the latest Autonomy Changes row whose `To` is `high`.

It warns when an artifact's current bytes no longer match its latest row.

Run it at every session start, before every stage transition, and in CI when
the project enables it.
