# Adapter - Figma Make (Page-First)

> Renders `templates/designer-brief.md` into one prompt per screen, for
> pasting into Figma Make.

## Rendering Rules

1. Carry the Brand And Constraints Header into a single shared "Design Tokens
   And Brand Notes" block, included once at the top of the rendered output.
   Reference the configured palette, typography, and motion sources as named
   design tokens; do not invent token names the header does not contain.
2. For each `## Surface` block in the brief, render one screen-level prompt
   covering the full surface in a single pass: layout, hierarchy, interaction
   model, every state and transition from State Coverage shown together as
   variants of the same screen (not split into separate component prompts),
   and the surface's Deliverables as the screen's required artifacts.
3. Each screen prompt states, in order:
   - the screen's purpose and audience/context;
   - every required state and transition, including empty, loading, error,
     success, permission, offline, disabled, and responsive variants when
     applicable;
   - voice and copy (from the header and the surface's Guardrails);
   - accessibility, locale, token, and component-reuse constraints;
   - explicit do/don't (Guardrails plus the header's "never be" list);
   - a request for the screen to reference the shared design tokens rather
     than introduce new ones.
4. Ask the engine to return the screen output plus a short coverage note:
   states covered, tokens introduced or reused, deviations, and questions.
5. Preserve the Derivation Trace as a one-line reference above each prompt
   naming the source surface.
6. Leave any "Unresolved Brand Or Creative Calls" out of rendered prompts;
   render only after the inventor gate resolves them.

## Output Shape

```
## Design Tokens And Brand Notes
<shared header, once>

## Screen: <surface>
Source surface: <brief surface name>
<prompt text>

Expected return: screen output, covered-state checklist, token/component notes,
deviations, and open questions.
```
