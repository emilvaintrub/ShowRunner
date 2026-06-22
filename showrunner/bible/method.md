# Bible Method

The Bible performs read-only synthesis. It writes nothing new about the
product: every architectural claim and every capability traces to a
repository path, an interface, or a named report. Humans own audience
framing, what counts as a "capability," and any claim the evidence rule
flags as ambiguous.

## 1. Policy

Apply the shared decision classifier:

- Human-owned: audience framing (`bible.audience`), what counts as a listed
  "capability," and any claim the evidence rule cannot resolve - recommend
  and wait.
- Convention: extraction order, section composition, and rendering detail
  resolve from repository evidence and the document skeleton; record the
  default and proceed.
- Drift: a capability the Forge spec promises but the repository does not
  implement is recorded under Intent-Not-Shipped, never under a shipped
  capability.
- Adjacent issue: a new security gap noticed during synthesis is reported as
  a candidate Sentry finding, not fixed. The Bible has no product write
  surface.

## 2. Session Order

1. **BIND** (`init`)
   - Read config, the Forge spec, Arc ship reports, Sentry sweep/security/
     pen-test outputs, and the configured `repository_map` hints.
2. **EXTRACT** (`sync`)
   - At the exact commit, walk the configured repository paths and derive the
     component map, data model, and interface list directly - no new scripts
     or executable tooling (S4).
3. **RECONCILE** (`sync`)
   - Reconcile the extraction against the Forge spec (intent), Arc ship
     reports (what shipped), and Sentry artifacts (security posture).
   - Apply the evidence rule (S5) and the Intent-Not-Shipped drift gate (S7).
4. **RENDER** (`sync`)
   - Resolve the human-owned gate (S8).
   - Render [templates/bible.md](templates/bible.md) to `bible.output.path`.
5. **STOP**
   - Produce a ship report. End `STOP BEFORE MERGE`.
6. **MERGE**
   - Run only after human approval, reusing the shared ceremony.

## 3. Initialization

`init` inspects:

- the Forge spec path and which of its sections 1-8 exist;
- Arc ship report paths or globs;
- Sentry sweep report, security document, and pen-test report paths or globs;
- repository-structure hints for component, data-model, and interface
  extraction (`bible.repository_map`);
- the audience setting (`engineering | capabilities | combined`);
- the rendered document's output path;
- the exact-tip requirement for a bound `sync`.

Infer only directly evidenced bindings. Preserve every existing shared-base,
Forge, Arc, and Sentry section byte-for-byte. Mark `ready` only when at least
one source under `bible.sources` resolves.

While `uninitialized`, only `/bible init` is allowed. `disabled` rejects all
Bible commands.

## 4. Synthesis Contract

The Bible's inputs are fixed:

- **Intent** - the Forge spec, sections 1-8 (what the system was meant to be
  and do, brand truths, scope boundaries).
- **As-built structure** - the live repository at the exact commit (modules,
  interfaces, data model, dependencies, entry points, deploy topology).
- **What shipped** - Arc ship report(s) (what was implemented, deviations,
  smoke evidence).
- **Security posture** - Sentry's sweep reports, security document, and
  pen-test report (protection layers, residual and accepted risks).

Repository-derived extraction (components, data model, interfaces) is an
agent-method instruction, not a new tool: read the paths and globs in
`bible.repository_map`, walk the tree, and derive the component map, data
model, and interface list by inspection - the same way Sentry's `sweep` and
Forge's `design` read the repository without new executable tooling.

`sync` binds to one exact commit (`require_exact_tip: true`). Reject a dirty
worktree, hidden-index bytes (assume-unchanged or skip-worktree entries), or a
tip that changes during the run - porcelain status alone is not sufficient
proof of exact-tip content. This mirrors Sentry's bound-sweep discipline.

Deploy, edge, and database facts come from the Sentry config block
(`sentry.deploy`, `sentry.edge_provider`, `sentry.database`); the Bible reads
them and does not redefine them.

## 5. Evidence Rule

Every claim in Part I (Architecture) and Part II (Capabilities) must cite at
least one of:

- a repository path (a file or directory the extraction walked);
- a named interface or contract surfaced by that extraction;
- a named report (the Forge spec and section, an Arc ship report, or a Sentry
  sweep/security/pen-test report).

A claim with no such citation is unbacked. Reject it before render: narrow
the claim to what the evidence supports, find the real citation, or move it
to Intent-Not-Shipped (S7) or Limits & Non-Goals as the evidence warrants. A
capability with no code evidence is a defect in the draft, not a feature.

## 6. Document Skeleton

Render one combined document, [templates/bible.md](templates/bible.md), with
two parts. Every numbered item below is evidence-bound per S5.

### Part I - Architecture (engineering audience)

1. System overview - one paragraph, derived from the Forge spec.
2. Component map - modules/services and responsibilities, generated from the
   repository; each component cites its real path.
3. Data model - entities, relationships, ownership/tenancy, from schema and
   migrations.
4. Interfaces & contracts - public surfaces, endpoints, key APIs; each cites
   its defining file.
5. Dependencies - runtime and third-party, with versions actually present
   (read from the repository, not asserted).
6. Deploy topology - environments and edge/DB/deploy targets, read from the
   Sentry config block.
7. Key decisions - material architectural decisions, traced to the decision
   log or ship reports, not re-derived.

### Part II - Capabilities (product/external audience)

1. What the system does - capability inventory, each bound to its
   implementing surface, phrased in user terms.
2. Surfaces - the screens/flows/endpoints a user touches.
3. Limits & non-goals - explicit scope boundaries, from the Forge spec.
4. Security & accepted risks - a summary lifted from Sentry/pen-test, with a
   pointer to the authoritative security document. Never restate the full
   threat model here.
5. Intent-not-shipped - anything the spec promised that the repository does
   not yet implement, stated plainly. This is the reconciliation payload
   (S7).

## 7. Drift Gate - Intent-Not-Shipped

For each capability or feature named in Forge spec sections 1-8, compare it
against the repository extraction and the Arc ship report scope:

- implemented and evidenced: list under Part II S1, citing the implementing
  surface;
- promised but not implemented (a "ghost capability"): list under Part II S5,
  never under S1;
- ambiguous (the spec language does not clearly describe a capability):
  surface as a human-owned question (S8) before deciding either way.

A ghost capability is a normal, expected output of an honest synthesis - not
a failure of the run.

## 8. Human-Owned Gate

Before render, batch:

- audience framing, if `bible.audience` is unset or the repository evidence
  conflicts with the configured value;
- borderline inclusion calls for what counts as a listed "capability";
- any claim the evidence rule (S5) could not resolve to a citation.

An empty gate is explicit: state the convention defaults used (for example,
"`bible.audience: combined` taken from config; no ambiguous claims found").
Never hide an empty gate.

## 9. Read-Only Ceiling

`sync` never edits product code, configuration, schema, or risk memory. It
commits only the rendered document at `bible.output.path` and its own ship
report, on the feature branch. A genuine gap (missing source, ambiguous
spec language, or a claim that cannot be backed) is recorded and asked about
- never invented or silently dropped.

`sync` can run as the terminal stage of `forge spec -> arc plan -> arc run ->
sentry sweep -> BIBLE`, or standalone on any repository that has a Forge spec
and Sentry artifacts.

## 10. Commands

`init`, `sync`, and `merge` is the convention default for this policy's
command surface - one command to bind sources (mirroring Arc's and Sentry's
`init`), one read-only synthesis-and-render pass (mirroring Sentry's
`sweep`), and the shared merge ceremony. Recorded here as the default;
redirect if a project's evidence calls for a different shape.

## 11. Completion

A Bible `sync` may request merge approval only when:

- Step 0 was approved;
- `sync` ran at the exact tip with a clean worktree;
- every claim in the rendered document cites a path, interface, or report
  (S5);
- the Intent-Not-Shipped section reflects every drift found (S7);
- the human-owned gate (S8) is resolved or explicitly empty;
- ship report and remote-tip evidence are complete;
- required smoke is complete or explicitly awaits the human;
- the response ends `STOP BEFORE MERGE`.
