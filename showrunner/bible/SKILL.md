---
name: bible
description: Synthesize the read-only architecture and capabilities document ("Bible") from the repository, the Forge spec, Arc ship reports, and Sentry security artifacts, binding every claim to a real path, interface, or named report and routing spec-promised but unbuilt capabilities to intent-not-shipped. Use when binding Bible source paths for a project, generating or refreshing the combined architecture and capabilities document at an exact commit, or merging an approved Bible document through the stop-before-merge ceremony.
---

# Bible

Reconcile intent against reality and render one combined architecture and
capabilities document. The Bible writes nothing new about the product: every
claim traces to a repository path, interface, or named report.

## Load

1. Read `../core/method.md`.
2. Read the active project's `.claude/showrunner/config.md`.
3. Read [method.md](method.md).
4. Load `../core/merge.md` for `merge`.
5. Load [templates/bible.md](templates/bible.md) for `sync`.
6. Load [templates/merge.md](templates/merge.md) for merge readiness.

## Route

- `init`: infer Bible source bindings (Forge spec, Arc ship reports, Sentry
  sweep, security, and pen-test outputs, and repository-structure hints for
  component, data-model, and interface extraction) and fill the Bible config
  section.
- `sync`: at an exact commit, extract components, the data model, and
  interfaces from the repository; reconcile against the Forge spec, Arc ship
  reports, and Sentry artifacts; apply the evidence rule and the
  intent-not-shipped drift gate; batch human-owned framing and
  ambiguous-evidence questions; then render
  [templates/bible.md](templates/bible.md) to `bible.output.path`.
- `merge`: after a clean `sync`, required smoke, and explicit approval, reuse
  the shared two-commit ceremony.

## Hard Stops

- Never edit product code, configuration, schema, or risk memory.
- Never assert an architectural claim or a capability without a citing
  repository path, interface, or named report.
- Never list a spec-promised capability the repository does not implement as
  shipped; record it under Intent-Not-Shipped instead.
- Never render from a dirty worktree or a tip that does not match the exact
  commit being documented.
- Never restate Sentry's full threat model; Part II's security section is a
  summary with a pointer to the authoritative security document.
- Never choose audience framing, what counts as a "capability," or resolve
  ambiguous evidence on the human's behalf.
- Never merge without explicit human approval and the shared ceremony.
- Never import facts or wording from another project.
