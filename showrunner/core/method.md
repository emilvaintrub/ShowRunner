# Shared Method

This file defines universal ceremony. It does not decide how a skill responds
to a classified decision.

## 1. Roles

**Architect/orchestrator**

- Own intent, scope, decisions, prompt quality, independent verification, and
  the merge ceremony.
- Do not perform the implementer's production edits in a dispatched arc.
- May correct a describe-back, answer convention questions, and escalate
  product decisions.

**Implementer**

- Start from a fresh context and re-read the configured sources.
- Describe the work back before implementation.
- Own only the feature branch: edit, test, commit, and push there.
- Never merge or push `main`.

The same model may fill both roles in separate sessions. The separation is
contextual and procedural, not a claim about identity.

## 2. Initialize From Project Bindings

The engine reads `.claude/showrunner/config.md` from the active repository.
Never copy project facts into this package.

An `init` command must:

1. Inspect repository guidance and existing project-memory files.
2. Infer bindings that are directly evidenced by files or configuration.
3. Ask for unresolved bindings in capped batches.
4. Write one config using [config.schema.md](config.schema.md).
5. Create the configured hygiene ledger only when no existing project-state or
   backlog file can receive the merge hygiene entry.
6. Install and verify the commit hook described in
   [commit-hooks.md](commit-hooks.md).
7. If `context_optimizer.enabled` is true, verify that at least one configured
   command or manual fallback exists. If the named provider is not installed,
   record it as unavailable rather than blocking initialization.
8. Report inferred values, human-provided values, disabled capabilities, and
   unresolved risks.

Never silently infer product policy, compliance posture, a destructive
migration policy, or a human approval ceremony.

## 3. Classify Decisions

Core classifies; the selected skill acts.

### Human decision surface

Classify as human-owned when the answer changes:

- product behavior, UX, emotional framing, brand, naming, or voice;
- scope, timing, rollout, monetization, privacy posture, or inclusion;
- risk acceptance, compliance posture, destructive migration strategy, or
  operational ownership;
- a previously recorded decision;
- a configured approval ceremony.

### Convention surface

Classify as convention when evidence already determines a safe answer:

- reuse of an established repository pattern;
- naming, file placement, imports, comments, or formatting;
- fixture mechanics and test organization;
- implementation composition with no user-visible or policy consequence.

If uncertain, test the consequence: if two reasonable choices would produce
meaningfully different product, risk, or scope outcomes, classify it as
human-owned.

Every skill records convention defaults. Only Forge must surface each default
before hardening directions; Arc and Sentry may resolve and proceed.

## 4. Front-Load Questions

Before directions or dispatch:

1. Inventory the full known decision surface.
2. Remove questions answered by recorded decisions or repository evidence.
3. Group related questions.
4. Respect `questions.max_per_round` from config.
5. For each question, provide concise options, a recommendation, and rationale.
6. Split a large surface into rounds.

An empty question set is explicit: state the convention defaults being used.
Never hide an empty gate.

## 5. Step 0 Describe-Back

Step 0 is read-only. Before code, schema, generated files, formatting, or
branch commits, the implementer reports:

1. The requested outcome and explicit non-goals.
2. Verified paths, symbols, interfaces, and relevant current behavior.
3. The implementation sequence and ownership boundary.
4. Tests, gates, migrations, flags, locale work, and smoke requirements.
5. Classified decisions and recorded convention defaults.
6. Ambiguities, conflicts, and proposed deviations.

End with `STOP: awaiting describe-back approval`.

The reviewer responds with one of:

- `APPROVED`: implementation may begin.
- `CORRECT AND RE-DESCRIBE`: no implementation; incorporate corrections.
- `ESCALATE`: ask the human a batched decision question.

Creating an isolated worktree is infrastructure, not implementation. Prefer
describe-back approval before branch/worktree creation when the adapter permits.
Spawn-time-isolated adapters may provision it earlier, but no repository content
may change and no commit may be created before approval.

If `context_optimizer.enabled` is true and the work matches one of its
`required_before` categories, run or suggest the configured health command
before Step 0. If the tool is unavailable, say so plainly and continue unless
the project config explicitly makes it blocking. Context hygiene never replaces
reading sources or receiving describe-back approval.

## 6. Scope STOP Gate

When adjacent work appears:

1. Stop the affected part.
2. State the finding and why it is adjacent.
3. Classify it.
4. Offer `fold in` or `defer`, with a recommendation.
5. Continue unaffected in-scope work when safe.

Security findings receive a separate finding ID. Never smuggle cleanup,
refactoring, or a second feature into the current arc.

## 7. Implementation Discipline

- Work on the configured branch pattern.
- Make atomic, scoped conventional commits.
- Do not stage unrelated user work.
- Do not bypass hooks.
- Keep project bindings out of the engine.
- Record deviations in the ship report.
- Verify the remote feature-branch tip after each required push.

Branch ownership includes commits and pushes. It excludes checkout, merge, or
push of `main`.

When reporting commits to a non-technical or semi-technical user, explain the
plain meaning: a commit is a named checkpoint saved in Git history. It is not a
release, a merge to the primary branch, or a deployment unless the report says
so explicitly. If the repository is not yet using Git, or the remote/branch
ceremony is missing, offer to set up the Git checkpoint flow and walk the user
through branch, commit, push, merge, and rollback in ordinary language before
assuming those words are understood.

## 8. Tests And Time

For time-dependent behavior, inject one clock or derive all fixtures from one
captured `now`. Never compare hardcoded historical fixture dates against the
real current clock.

Migration tests start from a representative pre-migration fixture, preserve old
rows, apply the migration, verify the new shape, and apply it a second time.
A fresh-schema test alone is insufficient.

Static inspection, a trace, a bundle, and unit tests do not replace a physical
or operational retest when runtime state, devices, external dashboards, or
deployment behavior changed. Use the configured smoke definition.

## 9. Verification Technique

Independent verification is diff-not-report: read the actual diff, commit
history, and command output yourself. A narrative claim that work is
"complete," "fixed," or "all tests pass" is a claim to check, not evidence. A
test that would pass both before and after a change provides no evidence about
the change.

To confirm a fix resolves the issue it claims to resolve, use
revert-to-confirm: compare the change against its prior state (`git show`,
`git diff` against the base commit, or directly evaluating the changed
behavior) and confirm the behavior actually differs in the claimed way. A new
test is only evidence if it would have failed before the change.

Apply both techniques in [merge.md](merge.md)'s independent verification and in
any `verify` or `fix` step that claims a defect is resolved.

## 10. Completion

Implementation ends with:

- a ship report;
- exact test and gate results;
- commits and remote-tip evidence;
- migrations, dependencies, and residual risks;
- a short human smoke checklist when required;
- `STOP BEFORE MERGE`.

Continue through [merge.md](merge.md) only after independent verification and
human sign-off.

## 11. Plain-Language User Updates

Every command that changes status or stops for a human decision must include a
short explanation of what the status means in user terms:

- what was found or created;
- what is now allowed or still blocked;
- what the user is being asked to decide or do;
- what will happen next if they approve.

Avoid tool-native phrases as the only instruction. For example, do not only
say "rerun `/forge init` to promote `forge.status`." Say that the project now
has the missing foundation file, the engine needs one validation pass to mark
Forge ready, and after that planning/design/spec commands become available.

Smoke-test instructions must be executable by the assigned human. Name the
environment, exact commands, build or install artifact, manual steps, expected
result, evidence to return, and who to contact or what to stop if the smoke
cannot be completed.

When context hygiene runs, explain it as a quick check that the session still
has enough useful context to proceed. Do not present token savings or quality
scores as proof that implementation, security, smoke, or merge gates passed.
