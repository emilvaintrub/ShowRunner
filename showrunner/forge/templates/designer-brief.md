# Designer Brief - <project or feature>

> Status: draft | inventor-approved | design-output-approved
> Source plan: <path> (surface inventory under `## Surfaces`)
> Source specification: <path>
> Target engine: <configured `forge.designer_helper.tool` or neutral>

## How To Use This Brief

Use this brief with a design engine before implementation planning. If the
project does not name a specific engine, choose Claude Design, Figma Make,
Lovable, v0, or an equivalent design-capable tool that can return screens,
components, states, and notes.

1. Paste the shared header once.
2. Paste one surface prompt at a time, exactly as written.
3. Ask the engine to produce complete screens or components for all required
   states, not only the default happy path.
4. Ask for responsive behavior, accessibility notes, design tokens, component
   reuse, and unresolved questions.
5. Return the design output for review before Arc implementation planning.

Expected return package from the user:

- link, file path, screenshots, or exported artifacts from the design engine;
- checklist of covered surfaces and states;
- token, typography, spacing, color, motion, and component notes;
- deviations from this brief and why they were proposed;
- open product, brand, accessibility, or technical questions.

Arc does not treat this work as implementation-ready until the returned design
output is reviewed and approved.

## Research Dossier

This section is required unless a durable research waiver is recorded. Sparse
inventor input must produce a richer dossier, not a thinner brief.

### User Examples

- Examples supplied by the inventor: <links, screenshots, product names, notes,
  or "none supplied">
- Anti-examples supplied by the inventor: <what to avoid, or "none supplied">
- Open follow-up asks: <examples still useful but not blocking>

### Domain And Web Research

- Research mode: <web required, web auto-used, web unavailable, or waived>
- External sources reviewed:
  1. <source, date accessed, why it matters>
  2. <source, date accessed, why it matters>
  3. <source, date accessed, why it matters>
- Benchmarks reviewed: <direct products/services/patterns in the domain>
- Analogs reviewed: <adjacent-domain examples that solve a similar design
  problem>
- Repository evidence reviewed: <current screens, workflows, data, components,
  decisions, state files>

### Expert Synthesis

- Patterns worth borrowing:
  - <pattern and why>
- Patterns to avoid:
  - <anti-pattern and risk>
- Domain constraints:
  - <viewing context, workflow, compliance, operations, platform, content, or
    other non-visual constraint>
- Accessibility constraints:
  - <contrast, focus, motion, language, device, assistive tech, or disabled>
- Operational constraints:
  - <hardware, environment, staffing, latency, data freshness, failure mode, or
    disabled>

### Candidate Directions

| Direction | Best for | Tradeoffs | Risk | Expert verdict |
| --- | --- | --- | --- | --- |
| <name> | <when it wins> | <cost or compromise> | <risk> | recommend / viable / avoid |
| <name> | <when it wins> | <cost or compromise> | <risk> | recommend / viable / avoid |
| <name> | <when it wins> | <cost or compromise> | <risk> | recommend / viable / avoid |

### Recommended Direction

<Forge's expert recommendation in plain language, including why this direction
best serves the constitution and what the inventor must still approve.>

### No-Thin-Design Gate

- User examples requested or recorded as unavailable.
- External/domain evidence present or waiver cited.
- Benchmarks or analogs considered where available.
- Candidate directions include tradeoffs.
- Expert recommendation included.
- Domain-specific quality bars and anti-patterns included.
- Surface detail below is sufficient for design-engine or implementation use
  without inventing product direction.

## Brand And Constraints Header

> <Exact approved constitution passage(s): core belief, durable truths, the
> emotional or practical job, voice>

### What This Product Will Never Be

- <constitution prohibition>

### Visual And Interaction Direction

- Design principle: <configured principle>
- Palette and token sources: <configured sources>
- Typography: <configured sources>
- Motion: <intent and constraints>
- Asset reservations: <configured restrictions>
- No-hardcode rules: <colors, copy, spacing, motion, or disabled>
- Wow-check scope: <whole project, phase, substituted, or disabled, with
  decision id>

### Voice

- <configured voice rules>
- Required copy moments: <list>
- Prohibited language: <list>

Every surface below inherits this header. A surface prompt does not restate or
override it.

---

## Surface: <name from the plan's `## Surfaces` inventory>

### Purpose

<The human outcome this surface must create.>

### Audience And Context

- People: <who>
- Moment: <when and why>
- Device or channel: <web, mobile, admin, email, embedded, or other>
- Constraints: <session, permissions, data freshness, connectivity>

### Layout And Hierarchy

- Primary action: <one action>
- Navigation and orientation: <how the user knows where they are>
- Information hierarchy: <what is most prominent and why>
- Responsive behavior: <desktop, tablet, mobile, small-screen, or disabled>

### Interaction Model

- Entry state: <how the surface begins>
- Primary path: <sequence of user actions>
- Transitions: <state changes, animation intent, timing constraints>
- Disabled or unavailable actions: <rules and copy>
- Designed ending: <what completion feels like and shows>

### State Coverage

- Default:
- Empty:
- Loading:
- Error:
- Success:
- Permission or authorization:
- Offline or degraded:
- Edge cases:

### Data And Content

- Data shown: <fields, objects, summaries>
- Sensitive data handling: <privacy constraints, masking, redaction>
- Required copy: <labels, helper text, error copy, confirmation copy>
- Content boundaries: <what must not be shown or implied>

### Accessibility And Locale

- Keyboard and focus:
- Contrast and visual affordance:
- Screen-reader labels:
- Motion sensitivity:
- Locale, directionality, and formatting:

### Components, Tokens, And Assets

- Existing components to reuse:
- New components allowed:
- Tokens required:
- Asset restrictions:
- Hardcoded values prohibited:

### Guardrails

- <constitution-derived prohibition specific to this surface>
- <privacy, accessibility, platform, or policy constraint>

### Deliverables

- <screens, components, variants, links, screenshots, exports, or notes>
- Must include every state in State Coverage.
- Must include responsive or device-specific variants when applicable.
- Must include design-engine questions or assumptions, if any.

### Acceptance Checklist

- Purpose and primary action are obvious without explanation.
- All required states are represented.
- Copy follows configured voice and prohibited-language rules.
- Accessibility and locale requirements are explicitly covered.
- Tokens and component reuse match configured constraints.
- No unapproved product, brand, scope, or emotional-framing changes were added.

---

<Repeat the "## Surface" block once per surface in the plan's inventory.
Exactly one block per surface - no more, no fewer. A surface the plan does not
contain is a ghost surface and is rejected, not added.>

## Design Review Package

When the design engine returns output, review:

- surface completeness against the plan inventory;
- state coverage for default, empty, loading, error, success, permission,
  offline, responsive, and accessibility states;
- brand, voice, and wow-check fit;
- component, token, and no-hardcode compliance;
- any deviations, assumptions, or new decisions.

## Derivation Trace

| Brief surface | Plan surface (`## Surfaces`) | Required states | Returned artifact |
| --- | --- | --- | --- |
| <name> | <matching plan entry> | <state list> | <link/path/screenshot> |

## Unresolved Brand Or Creative Calls

- <a brand or creative call this brief would need that the constitution and
  spec do not already resolve - gate it with the inventor before hardening
  any surface that depends on it>

The designer may explore execution within these constraints. Product, brand,
scope, and emotional-framing changes return to the inventor.
