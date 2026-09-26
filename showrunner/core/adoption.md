# Adoption And Rescue

ShowRunner is often called in after work has already started: a product
built without a process, an agency or freelancer who left, a team that lost
its direction, or a ShowRunner project that drifted off-process. The owner
needs rescue and direction, not a restart. This file governs how ShowRunner
adopts an existing product: it keeps what was done, trusts none of it until it
is checked, and brings every piece into the lifecycle where it actually stands.

Four principles:

- **Stop the bleeding first.** Live harm, lost control of accounts, and
  unprotected data come before any planning.
- **Nothing is thrown away by default.** Code, branches, uncommitted work,
  documents, designs, and decks are inventoried and kept until the owner
  decides otherwise.
- **Nothing is trusted by default.** Existing code is verified and swept like
  new code before it counts as done. Existing documents are audited like new
  ones before they count as evidence.
- **Reconstruct, don't redo.** Stages are satisfied by reconstructing their
  artifacts from what exists and what the owner intended - an as-built spec,
  a reviewed existing design - not by pretending the work never happened and
  not by pretending the gates were passed when they were not.

## 1. When It Applies

- `setup` finds a repository with substantial product code, a live
  deployment, or product documents, and no ShowRunner ledger.
- The owner says they need rescue or direction mid-development.
- An existing ShowRunner project changed outside the lifecycle: commits on the
  primary branch, releases, or new services with no ledger rows. Session start
  reports the drift; the unrecorded work is adopted with this method.

Say plainly, at the start, what adoption means for the owner: a short
stabilization, an honest inventory and health report, their decisions on what
to keep, and then the normal process from wherever each piece really stands.

## 2. Stabilize (Part Of `setup`)

In this order, before any planning:

1. **Live harm.** Anything broken or harmful in production now goes to
   incident mode ([incident.md](incident.md)).
2. **Control.** Run the accounts inventory ([ownership.md](ownership.md))
   first and hardest: repository, domain, hosting, stores, payments, email,
   and credentials held by people who have left. Every `at risk` row is
   named to the owner with its fix.
3. **Secrets.** Secrets in the repository or its history are reported for the
   owner to rotate now.
4. **Data.** Confirm that production data is backed up somewhere the owner
   can restore without anyone's help. If not, that is the first rescue item.
5. **Reproducibility.** Can the product be built, tested, and deployed from
   the repository by someone new? Record the baseline as it is - red tests,
   missing steps, manual deploys - without fixing anything yet.

Never discard, reset, rebase, force-push, or delete anything during adoption:
no `git reset --hard`, `git clean`, branch deletion, or history rewrite.
Before any later cleanup the owner approves, tag or archive what would be
removed.

## 3. Inventory (Part Of `setup`, Read-Only)

Build a factual picture, citing repository paths and commands:

- **As-built architecture**: a Bible `sync` of the current primary branch
  ([../bible/method.md](../bible/method.md)): components, data model,
  interfaces, deploy topology.
- **Security posture**: a full Sentry sweep, dependency audit, and licence
  inventory.
- **Test and build health**: which test lanes exist, what passes and fails,
  whether the build and deploy steps work.
- **Work in flight**: every branch and pull request with its last activity
  and what it appears to change, uncommitted changes, feature flags,
  half-wired routes or screens, `TODO`/`FIXME` clusters, and issues or tickets
  the owner shares.
- **Intent sources**: existing specs, designs, tickets, decks, notes, and
  contracts the owner provides - listed, not yet trusted.
- **History**: who worked on what and when, from Git history, in neutral
  terms. Never assign blame.

## 4. Reconstruct Intent (Adoption `discovery`)

Run discovery ([../forge/discovery.md](../forge/discovery.md)) with the
inventory in hand. Pre-fill each domain from existing documents and mark it
`reconstructed`; the owner confirms or corrects it. Ask concrete questions the
inventory raises ("There is a half-built subscription flow on branch
`billing-v2`, last touched in March. Was that planned, and is it still
wanted?"). Guide and challenge modes apply as usual. The owner often needs
direction most at this point: say what the evidence suggests, and recommend.

## 5. Health Report And Rescue Assessment (Adoption `assessment`)

The assessment ([../forge/templates/assessment.md](../forge/templates/assessment.md))
gains a health report, written for a non-technical owner and backed by the
inventory:

- **Product**: what works end to end today, verified by running it; what is
  broken; what is half-built.
- **Code**: quality hotspots, test gaps, dead code, and risky dependencies,
  each with paths.
- **Security and legal**: Sentry findings and licence issues.
- **Operations**: build, deploy, backups, monitoring, and the bus factor.
- **Control**: the accounts register summary.
- **Existing business documents**: every figure in an existing deck, plan, or
  analysis is audited under [evidence.md](evidence.md); unsourced figures are
  listed, not reused.

For every component and every workstream in flight, recommend one of
**keep** (works; adopt as is after verification), **finish** (close to done),
**fix** (works but unsafe or fragile), **rebuild** (cheaper to redo than to
repair, with the evidence), or **drop** (no longer wanted or not worth it),
with the reason and a labeled effort estimate.

The verdict adds adoption options to proceed, validate first, pivot, and
stop: **continue** (the direction holds), **refocus** (narrow to what works
and matters), and **rescue-rebuild** (keep the product and data, rebuild named
parts). The owner decides, component by component and overall.

## 6. The Baseline

Record what exists as the project's baseline in the project state, citing the
as-built Bible, the health report, and the owner's decisions: what is live,
what is kept, what will be finished, fixed, rebuilt, or dropped. The baseline
is where the lifecycle starts, not a claim that earlier gates were passed.

Live capabilities the owner keeps count as shipped. When the owner wants to
know whether they work for users, add outcome reviews for them
([outcomes.md](outcomes.md)).

Existing business documents the owner wants to keep enter `business-docs` as
refreshes: they are re-researched and evidence-audited before approval.

## 7. Adopting Work In Flight

Each workstream the owner keeps (finish, fix, or rebuild) becomes an
initiative at `intake`, with its existing work as evidence, and runs every
stage. Stages are satisfied by reconstruction:

- **roadmap**: the initiative inquiry, answered with the inventory.
- **spec**: an as-built spec written from the existing code and the owner's
  intent, marking clearly what is built, what is intended but missing, and
  what the owner no longer wants. The owner approves it like any spec.
- **design / design-review**: existing screens and design files are reviewed
  against the spec; gaps become the design work.
- **arc-plan**: plans the remaining work and the verification of the existing
  work.
- **step0**: the describe-back covers both the existing code on the branch and
  the planned changes.
- **build / verify / security**: the existing code is verified and swept
  exactly like new code. "It was already there" is never a reason to skip
  review; unverified adopted code is labeled `adopted, unverified` until it
  passes.

An existing branch may continue as the feature branch when its base and
history are clean; otherwise start a new feature branch from the primary
branch and bring the kept work across with ordinary commits, leaving the old
branch untouched until the owner approves archiving it.

## 8. The Rescue Roadmap

The first roadmap after adoption is ordered, and the owner approves it:

1. **Stop the bleeding**: critical security findings, accounts at risk,
   missing backups, exposed secrets.
2. **Stabilize**: a green, reproducible build and test baseline; a documented
   deploy with a rollback; basic monitoring.
3. **Finish or fix** kept work in flight, most valuable first.
4. **Rebuild** what the owner chose to rebuild.
5. **New work** from the reconstructed direction.

Each item is an initiative and runs the full lifecycle. Tell the owner after
each one where the rescue stands, in plain words.
