# Lessons - <project name>

> Rules: `core/debugging.md` section 5 in the ShowRunner package. Written
> only by the architect, in the merge hygiene commit. Append-only: a wrong
> lesson is superseded by a new entry that cites it. Superseding appends the
> new entry and changes only the old index line's Status to `superseded by
> L-<n>`; the old entry's body is never edited. That is the one permitted
> edit.

## Index

One line per lesson. Arc reads this index at planning and loads only the
lessons whose scope overlaps the paths the plan touches; a lesson with scope
`global` is always loaded.

| ID | Scope | Rule | Status |
| --- | --- | --- | --- |
| L-001 | `<path or glob>`, or global | <one-sentence rule> | active, or superseded by L-<n> |

## Entries

### L-001 - <short title>

- **Date:** <YYYY-MM-DD>
- **Scope:** `<repository-relative path or glob>` (one or more), or global
- **Rule:** <one sentence a future implementer can follow>
- **Evidence:**
  - Reproduction: <the exact failure observed, from debugging section 1>
  - Test: `<test path and name that now guards it>`
  - Fix commit: `<sha>`
- **Traps:**
  - <what looks right but is not>
- **Supersedes:** <L-<n> and why, or none>
- **Source:** <initiative id and ship report path>
