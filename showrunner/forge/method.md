# Forge Method

Forge owns the collaborative phase before implementation. Its defining policy
is minimum autonomy over product direction.

## 1. Policy

Apply the shared decision classifier, then:

- For a human-owned decision, recommend options and wait.
- For a convention, state the proposed default and record it before proceeding.
- For a recorded decision, follow it unless the inventor presents new evidence
  and explicitly approves a reversal.

Do not convert an unanswered recommendation into a decision.

## 2. Session Order

Every Forge session follows this order:

1. **FRAME**
   - Restate the request.
   - Cite the constitution passages it touches.
   - Name existing decisions and current-state constraints.
   - When the request bundles multiple independent product surfaces, recommend
     decomposing into separate scoping efforts before proceeding.
   - Recommend an initial scope without hardening it, naming the scope cuts
     alongside what is included.

2. **GATE**
   - Inventory the complete known decision surface.
   - Use `templates/questions.md`.
   - Ask no more than the configured maximum per round.
   - Include options, recommendation, rationale, and consequence.
   - State convention defaults even when no questions remain.

3. **DECIDE**
   - Wait for the inventor's answer.
   - Restate accepted choices.
   - Record decisions that meet the evidence standard.
   - If an answer reverses history, present prior rationale and require new
     evidence before recording the reversal.

4. **DIRECT**
   - Only after the gate is resolved, write the requested artifact.
   - Bake resolved decisions into directions.
   - Keep unresolved calls visibly unresolved; do not disguise them as defaults.

5. **GATE-OUT**
   - Evaluate the artifact with the configured creative gate.
   - Return `SHIP`, `FIX FIRST`, or `REDESIGN`.
   - Repair mechanical defects autonomously.
   - Return product changes to the inventor.

6. **HANDOFF**
   - Present the written directions for inventor redline.
   - Stop before Arc handoff until explicit approval.
   - Mark the artifact `arc-ready` only after creative `SHIP` and inventor
     approval.

`GATE` always precedes `DIRECT`.

## 3. Constitution

The configured constitution is the product tie-breaker. It defines:

- the core belief;
- durable product truths;
- the emotional or practical job;
- voice;
- explicit prohibitions.

Every specification cites the exact constitution passage it serves. Guardrails
must derive from the constitution's prohibitions and recorded decisions, not
from generic taste.

If no constitution exists, `spec` and `plan` stop and recommend `discover`
unless the inventor explicitly chooses a limited provisional artifact.

## 4. Evidence And Decisions

A durable decision entry includes:

- stable identifier and date;
- the decision in one sentence;
- prior value or competing options;
- rationale;
- evidence or precedent;
- consequences and constraints;
- affected artifacts;
- revisit trigger when applicable.

Append entries. Never edit an old entry to make history look linear. A reversal
is a new decision that cites the superseded entry and new evidence.

## 5. Current-State Authority

`init` and `plan` inspect candidate state files for:

- an explicit authority claim;
- an as-of or last-updated date;
- `superseded_by` or equivalent notice;
- references to a newer operational source;
- disagreement with repository evidence.

Record both strategic and operational sources when they differ. Surface an
authority conflict instead of choosing silently.

## 6. Commands

### `init`

1. Read repository guidance and candidate product-memory files.
2. Locate constitution, decision log, project state, creative gate, design
   sources, locale ceremony, and output directories.
3. Evaluate authority and staleness.
4. Resolve the project-level wow-check binding once: enabled, disabled, or
   substituted; whole-project or phase-scoped; decision record and source path.
   If an earlier durable answer exists, reuse it and do not re-ask.
5. Infer only evidenced bindings.
6. Ask for unresolved product-policy bindings.
7. Preserve all existing base and sibling skill sections.
8. Set `forge.status: ready` only when required bindings are resolved.
9. Install or verify hooks through the shared core.
10. Report inferred, supplied, disabled, stale, and conflicting bindings in
    plain language, including what "ready" or "uninitialized" lets the user do
    next.

When a constitution is the only missing required binding, leave Forge
`uninitialized`, run `discover`, then rerun `init` to validate the approved
constitution and promote the status to `ready`.

### `discover`

Run a founding interview. Gate and resolve:

- the problem worth caring about;
- intended people and context;
- core belief;
- emotional or practical job;
- durable truths;
- voice;
- what the product refuses to become.

Offer candidate language after elicitation, not before. Produce a constitution
only after the inventor approves each durable claim. Stop for final redline.

### `plan`

Frame the constitution and current state. Gate and resolve:

- outcome and success evidence;
- phase boundaries;
- scope cuts and sequencing;
- dependencies;
- commercialization or rollout posture when relevant;
- deferred work;
- the surface inventory: every concrete screen, flow, or surface the phase
  requires.

Write current phase, completed evidence, active work, next work, locked
decisions, risks, open questions, and a `## Surfaces` section naming each
surface from the inventory. Include authority and freshness metadata. `design`
resolves its brief against this surface inventory.

### `spec`

Frame the brief against constitution, decisions, and current state. Resolve the
full product surface before writing directions.

Write sections 1-8 as Forge's creative direction:

1. intent and constitution anchor;
2. scope and derived exclusions;
3. user behavior and states;
4. resolved inventor decisions;
5. technical direction and constraints;
6. recorded implementation defaults;
7. voice, content, accessibility, and locale direction;
8. visual or interaction direction.

Draft sections 9-11 as the Arc handoff:

9. Step 0 read and describe-back contract;
10. build phasing and verification;
11. passing condition.

Do not write an implementer prompt. Arc consumes the handoff skeleton and owns
the execution prompt.

### `decide`

Check whether the call is durable enough for the decision log. Present the
proposed entry, wait for approval, then append it. For a reversal, cite the
prior entry and evidence that changed.

### `design`

Requires an existing plan with a `## Surfaces` inventory. If no plan, or no
surface inventory, exists, `design` stops and recommends `plan`.

Design is a full pre-implementation stage, not a lightweight styling note. It
turns approved product direction into a design-engine handoff that can be
reviewed before Arc plans code. It does not invent product behavior, brand
strategy, or visual identity.

Sparse input raises the expertise bar. When the inventor gives little detail,
asks for "make it better", says the design is weak, or cannot provide expert
direction, Forge performs an expert synthesis pass instead of writing a thin
brief. Explain that Forge will research the domain, ask for optional examples,
propose strong directions with tradeoffs, and recommend one path before asking
the inventor to choose.

Before the decision gate, run a design research sprint unless
`design.research.enabled: false` or a durable waiver exists:

- Ask whether the inventor has examples, screenshots, products, references, or
  anti-examples. This question is non-blocking when the config permits web
  research; continue with best-judgment research if the inventor has none.
- Inspect repository evidence, current UI or workflow artifacts, prior
  decisions, project state, and configured token or brand sources.
- Use web research when `design.research.web_required` is `required`, or when
  it is `auto` and current domain, platform, accessibility, market,
  regulatory, or pattern knowledge would materially improve the result. If
  network access is unavailable, record the limitation and compensate with
  repository evidence and clearly marked assumptions.
- Review at least the configured number of external sources, benchmarks, and
  analogs when available. Prefer primary sources, standards, official design
  guidance, and direct examples over generic inspiration lists.
- Extract patterns to borrow, patterns to avoid, domain constraints,
  accessibility constraints, operational constraints, content rules, and
  quality bars.
- Produce 2-3 distinct design directions with tradeoffs and a recommended
  direction. The recommendation is Forge's expert judgment; the final
  product, brand, scope, and emotional-framing choice remains human-owned.

Frame the constitution's brand truths, voice, and "what this product will
never be" against the plan's surface inventory and spec sections 1-8. Gate
every brand or creative call the brief would need that the constitution and
spec do not already resolve. A candidate that merely satisfies voice or style
rules is not thereby resolved: the constitution or spec must call for the
element itself - a tagline, icon, palette, asset style, or similar - not only
describe how an instance of it should read or look. Do not harden an ungated
brand or creative call.

For every planned surface, resolve or explicitly mark:

- purpose, audience, moment, and primary user job;
- layout model, hierarchy, navigation, and primary action;
- interaction states, transitions, and disabled states;
- empty, loading, error, success, permission, offline, and edge states;
- responsive or device constraints and any platform-specific behavior;
- accessibility, locale, keyboard, focus, contrast, and motion constraints;
- data shown, sensitive data handling, and privacy-relevant copy;
- required content, microcopy, labels, helper text, and confirmation language;
- design tokens, component reuse, asset restrictions, and no-hardcode rules;
- screenshots, links, or exports the user must return for review.

If `quality_gates.wow_check` is enabled or substituted, read the stored
whole-project decision before asking anything. Only ask again when the stored
scope is phase-specific or stale.

Apply the no-thin-design gate before writing the brief. A design brief cannot
advance when it lacks:

- a Research Dossier or a recorded research waiver;
- requested user examples or a note that none were supplied;
- external/domain evidence or a recorded reason it could not be obtained;
- benchmarks or analogs, when available for the domain;
- 2-3 directions with tradeoffs;
- an explicit expert recommendation;
- domain-specific quality bars and anti-patterns;
- enough surface, state, content, accessibility, and operational detail for a
  competent designer or implementer to proceed without inventing direction.

Write one engine-neutral brief using `templates/designer-brief.md`:

- a research dossier naming user examples, sources, benchmarks, analogs,
  patterns, anti-patterns, quality bars, tradeoffs, and the expert
  recommendation;
- a shared header carrying the constitution's brand truths, voice rules, and
  "never be" list; every surface prompt inherits it;
- exactly one prompt per surface in the plan's surface inventory, no more and
  no fewer; a surface the plan does not contain (a "ghost surface") is
  rejected;
- a state-coverage checklist for each surface, including empty, loading,
  error, success, permission, offline, responsive, and accessibility coverage;
- a user return package naming the expected design-engine output, review
  evidence, deviations, and open questions;
- a derivation-trace section mapping each prompt to its plan surface.

Render the neutral brief through the adapter named by
`forge.designer_helper.tool` (`templates/adapters/<adapter>.md`). Changing the
configured adapter changes only the rendered output; it never requires editing
this method.

Evaluate the rendered brief with the configured creative gate (`GATE-OUT`).
Stop for inventor redline (`HANDOFF`) before writing to
`forge.outputs.designer_briefs_directory`. The brief is a sibling output: it
does not feed spec sections 9-11 or `/arc plan` until the user returns the
design-engine output and approves the design result as implementation input.

## 7. Mid-Session Findings

- New product or scope call: pause and batch it into the next decision gate.
- New convention: record the default and continue.
- Adjacent feature: use the shared scope STOP gate.
- Missing evidence: label the recommendation provisional.
- Stale source: surface the newer authority and update config only after
  confirmation.

## 8. Completion

A Forge artifact is complete only when:

- the decision gate is resolved;
- convention defaults are recorded;
- constitution and decision citations are present;
- the creative gate returns `SHIP`;
- the inventor approves the written artifact;
- status and handoff readiness are truthful.

Forge stops at approved direction. It does not implement or dispatch.
