# Wow Check

Use this creative gate for Forge output and Arc UI work when enabled in project
config. Evaluate against the project's constitution, voice, and design
bindings. Do not import example-project language into another project.

## 0. Project Definition

Define the wow-check once per project before design or spec hardening whenever
the gate is enabled. Record whether it applies to the whole project, only the
current phase, or is disabled/substituted. The durable record belongs in the
configured decision log or project state, and the config must point at that
record through `quality_gates.wow_check.scope`, `decision_id`, `defined_in`,
and `substitution_policy`.

Later phases read that record first. They do not re-ask the same
wow-check-substitution question unless the stored scope was phase-specific, the
project evidence changed, or the inventor explicitly reopens the decision.

## 1. Resonance Test

Answer each with a specific `YES` or `NO`:

1. Does the experience deliver the emotional job named by the constitution?
2. Does the copy sound like the configured voice rather than generated or
   system language?
3. Is the product's distinctive human or domain context visible?
4. Would the intended audience understand the experience and feel its intended
   consequence without explanation?

Any `NO` requires a concrete cause and fix.

## 2. UX Laws

Evaluate:

1. **Low friction**: the primary action is obvious and unnecessary input is
   absent.
2. **Context retained**: users understand what, where, and why without detours.
3. **Relevant people or objects visible**: the experience does not erase the
   relationships its value depends on.
4. **On the user's side**: chrome, alerts, and system machinery do not compete
   with the user's goal.
5. **Designed ending**: completion has a deliberate payoff rather than a dead
   end.

Projects may add laws in `quality_gates.wow_check.config`; they may not silently
remove the four resonance questions.

## 3. Design And Voice

Check configured:

- token and no-hardcode rules;
- typography, palette, motion, and asset reservations;
- one-primary-action policy;
- empty and end states;
- locale and accessibility requirements;
- prohibited language;
- specific, human copy.

## Output

```text
WOW CHECK - <artifact>

RESONANCE: PASS | PARTIAL | FAIL
  Q1-Q4: YES|NO - evidence

UX LAWS: <n>/<total>
  each law: PASS|FAIL - evidence

DESIGN SYSTEM: PASS|FAIL
VOICE: PASS|FAIL

REQUIRED FIXES:
  ordered, concrete fixes

VERDICT: SHIP | FIX FIRST | REDESIGN
```

Only `SHIP` passes a configured creative gate.
