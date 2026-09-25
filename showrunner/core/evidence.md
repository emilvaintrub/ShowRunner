# Evidence Standard

Business research is only useful if it is true. This standard applies to the
Forge `assessment`, every Pitch document, and any other ShowRunner output that
states a fact about the world outside the repository: markets, competitors,
prices, costs, benchmarks, regulations, funding, user numbers, or trends.

The rule is simple: **no fact without a source, no number without a label.**
A figure the model remembers from training is not evidence. When research is
not possible, the answer is "unknown - here is how to find out", never a
plausible guess.

## 1. What Counts As Evidence

A source is something ShowRunner opened during this project and recorded in
the sources register:

- **Primary**: a company's own website, pricing page, documentation, filing,
  press release, app-store listing, or public dataset; a government or
  regulator publication; a standards body.
- **Secondary**: reputable research firms, industry associations, established
  news outlets, academic papers, or analyst reports that name their method.
- **Owner-supplied**: documents, data, or statements the owner provides.
  These are cited like any other source and marked `owner`.

Not evidence: model memory, unnamed "industry estimates", AI-generated
summaries, content farms, or a search-result snippet that was not opened.
A single blog post is weak evidence; say so when it is all there is.

## 2. Labels

Every figure in a research-bearing document carries exactly one label:

| Label | Meaning | Example |
| --- | --- | --- |
| `[S<n>]` | Stated in source `S<n>` of the register | `Plans start at $12/user/month [S4].` |
| `[OWNER]` | Supplied or decided by the owner | `Launch budget: $40,000 [OWNER].` |
| `[ASSUMPTION A<n>]` | A reasoned estimate listed in the assumptions register, with rationale and sensitivity | `Trial-to-paid conversion 4% [ASSUMPTION A2].` |
| `[DERIVED: <formula>]` | Computed from labeled inputs, with the formula shown | `SAM 1.2M households [DERIVED: 3.0M [S2] x 40% [S7]].` |

A figure is any amount of money, percentage, market size, count of users,
customers or companies used as a market fact, growth rate, price, cost,
salary, conversion rate, or date-bound statistic.

Qualitative claims about a specific competitor, market, or regulation also
cite a source: "Competitor X offers offline mode [S9]." When a search finds
nothing, write "no evidence found in <what was searched> [search log Q<n>]",
never "X does not offer it".

## 3. The Registers

Each project keeps one registers file, `business.registers`
([config.schema.md](config.schema.md)), created from
[templates/research-registers.md](templates/research-registers.md). It has
three sections - `## Sources`, `## Search Log`, and `## Assumptions` - and
every research-bearing document shares it, so a source is recorded once and
cited everywhere.

### Sources Register

```markdown
| ID | Title | Publisher | URL | Published | Accessed | Type | Excerpt |
| --- | --- | --- | --- | --- | --- | --- | --- |
| S1 | <page or report title> | <organization> | <full URL> | <date or unknown> | <YYYY-MM-DD> | primary / secondary / owner | "<exact words or figure copied from the source>" |
```

- The excerpt is copied, not paraphrased, and contains the figure or claim
  being cited. One source row per distinct excerpt; reuse the ID wherever the
  same excerpt supports a claim.
- `Accessed` is the date ShowRunner opened it. A source older than
  `business.research.freshness_days` at use time is flagged stale in the
  document.
- Owner-supplied sources use `owner` as the Type and a file path or
  description in the URL column.

### Search Log

```markdown
| ID | Date | Tool | Query | Results opened | Notes |
| --- | --- | --- | --- | --- | --- |
| Q1 | <YYYY-MM-DD> | <web search / site / database> | "<exact query>" | S3, S4 | <what was and was not found> |
```

The search log makes competitor discovery and market research reproducible
and shows what was looked for but not found.

### Assumptions Register

```markdown
| ID | Assumption | Value | Rationale | Based on | Sensitivity | Owner status |
| --- | --- | --- | --- | --- | --- | --- |
| A1 | <what is assumed> | <value and unit> | <why this value> | <S-ids or "judgment"> | <effect on the outcome if wrong, e.g. break-even moves 9 months per 1 point> | proposed / owner-accepted / owner-replaced |
```

Assumptions are allowed; hidden assumptions are not. The owner sees every
assumption that moves a headline number and accepts or replaces it.

An assumption is for something that cannot be known yet: a future conversion
rate, churn, growth, adoption speed, or the owner's own plans. It is never a
stand-in for a fact that could be looked up - a vendor's fee, a published
price, a salary level, a market size, a tax or regulatory rule. When such a
fact cannot be researched in the session, it stays `EVIDENCE PENDING` until it
is researched or the owner supplies it; it does not become an assumption with
a remembered value. An assumption's `Based on` column cites the sources that
informed it, or says `judgment` with the reasoning in `Rationale`.

## 4. Research Rules

- **Real access or no claim.** Use the session's web search and fetch tools.
  When they are unavailable, blocked, or return nothing useful, stop the
  research-bearing sections, mark them `EVIDENCE PENDING`, tell the owner
  exactly what could not be researched, and list the sources the owner could
  provide. Never fall back to memory.
- **Open what you cite.** Cite only pages actually opened, and copy the
  excerpt from the opened page.
- **Prefer primary.** A competitor's price comes from its own pricing page; a
  regulation from the regulator.
- **Triangulate headline numbers.** Market size needs at least two independent
  sources, or one source plus a bottom-up calculation. Show both and explain
  any gap. When they disagree by more than 2x, say so plainly.
- **Match the scope.** State the geography, year, currency, and segment of
  each figure. Never apply a global figure to a local market without a
  labeled derivation.
- **Currency and dates.** Convert currencies only through a cited rate with
  its date. Keep the source year next to every figure.
- **Minimum depth.** Meet the configured minimums
  (`business.research.min_sources`, `min_competitors`) or state why fewer
  exist, backed by the search log.
- **No invented precision.** Round derived figures to the precision of their
  weakest input.

## 5. Verification

Before any research-bearing document reaches the owner for approval:

1. **Lint.** Run `showrunner-sources lint <document>`
   ([enforcement.md](enforcement.md)). Every figure is labeled, every cited
   `S`, `A`, and `Q` id exists in its register, and every source row has a
   URL, an access date, and an excerpt. Errors block.
2. **Citation audit.** An independent verifier - a fresh-context agent where
   the adapter provides one, otherwise a separate pass that reads only the
   document and the registers - re-opens every cited source and checks that
   the excerpt is on the page and supports the claim as written. Run
   `showrunner-sources lint --fetch` first for a mechanical pre-check.
   Record each source as `confirmed`, `mismatch`, `unreachable`, or
   `paywalled` in an audit table at the end of the document.
3. **Resolve.** A `mismatch` is corrected or the claim removed. An
   `unreachable` or `paywalled` source stays only when its excerpt was
   captured at access time and the document says the page could not be
   re-checked. Unconfirmed headline numbers are reported to the owner as
   unconfirmed.

The owner approves a document only after it passes lint and the audit, and
the approval ledger row cites the audit result.

## 6. Honesty In Conclusions

- Say what the evidence shows, including when it cuts against the owner's
  idea. A weak market, a dominant competitor, or unit economics that do not
  work are findings, not things to soften.
- Separate evidence from judgment: "The data shows..." versus "My read
  is...".
- Every projection is a scenario, not a forecast: show conservative, base,
  and optimistic cases, and the assumptions that move them most.
- Business documents are decision support, not legal, tax, or investment
  advice. Say so once in each document, and recommend a qualified
  professional where the stakes call for one.
