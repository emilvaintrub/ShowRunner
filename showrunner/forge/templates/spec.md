# Feature Specification - <feature>

> Status: decision-gate | draft | inventor-approved | arc-ready
> Owner: <inventor or product owner>
> Constitution: <path and passage>
> Decisions: <ids>

## 1. Intent

<One paragraph explaining why this should exist, the human consequence, and the
constitution passage it serves.>

## 2. Scope And Guardrails

### In Scope

- <behavior or surface>

### Explicitly Out Of Scope

- <constitution-derived guardrail>
- <deferred adjacent behavior and revisit trigger>

## 3. Experience And Behavior

Describe:

- entry conditions;
- primary path;
- empty, loading, error, and completion states;
- permissions and inclusion;
- important transitions;
- what persists and what remains ephemeral.

## 4. Resolved Inventor Decisions

| Decision | Approved choice | Rationale | Decision entry |
| --- | --- | --- | --- |
| <call> | <choice> | <reason> | <id or pending> |

Do not leave hidden product decisions in later sections.

## 5. Technical Direction

- Existing systems and patterns to reuse.
- Required data or interface shapes.
- Privacy, security, accessibility, and operational constraints.
- Flags, migrations, and compatibility expectations.
- Technical facts Arc must verify rather than assume.

## 6. Recorded Implementation Defaults

- <convention>: <default and evidence>

Defaults are not product decisions. Arc may refine them when current repository
evidence requires it, provided behavior and scope remain unchanged.

## 7. Voice, Content, Accessibility, And Locale

- Voice rules and required copy moments.
- Content that requires inventor approval.
- Accessibility states and labels.
- Locale ceremony and translation approval requirements.
- Prohibited language.

## 8. Visual And Interaction Direction

- Design principle and token sources.
- Hierarchy, surface, typography, motion, and asset constraints.
- Protected content or interaction zones.
- Required designer brief, when enabled.

---

## 9. Arc Step 0 Contract

Before implementation, Arc must read:

- this specification;
- configured guidance, constitution, decisions, and current state;
- verified implementation surfaces named in section 5.

Arc's implementer describes back:

1. outcome and non-goals;
2. verified paths, symbols, and current behavior;
3. implementation and ownership plan;
4. data, flags, migrations, locale, tests, gates, and smoke;
5. ambiguities or deviations.

Then stop for approval.

## 10. Build And Verification Phasing

1. <smallest independently verifiable phase>
2. <next phase>
3. <integration, content, or rollout phase>

For each phase, name:

- expected commit boundary;
- automated tests;
- creative or audit gates;
- human smoke when runtime state is involved.

## 11. Passing Condition

State an observable end-to-end scenario and the human/product test it must pass.
Include inert behavior for disabled flags and non-leakage for excluded people
or surfaces when relevant.

`arc-ready` requires:

- all section 4 decisions approved;
- creative gate `SHIP`;
- inventor redline approval;
- sections 9-11 complete.
