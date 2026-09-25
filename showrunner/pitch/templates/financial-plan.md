# Financial Research And Plan - <product>

> Status: draft | evidence-audited | owner-approved (set only with a matching owner ledger row)
> Currency: <code> | Geography: <scope> | Horizon: <years> | Funding scenario: <bootstrapped / grant / angel / venture>
> Financial model: <path to spreadsheet> | Research registers: <path>
> Disclaimer: scenarios for decision support, not a forecast or investment, tax, or accounting advice.

## 1. Summary

- Base-case break-even: <month> [DERIVED: ...]
- Cash needed to reach break-even (base / conservative): <amounts> [DERIVED: ...]
- The three assumptions that move the result most: <A#, A#, A#>

## 2. Market Sizing

| Measure | Top-down | Bottom-up | Notes |
| --- | --- | --- | --- |
| TAM | <figure> [S#] | <figure> [DERIVED: ...] | <year, scope> |
| SAM | <figure> [DERIVED: ...] | <figure> [DERIVED: ...] | <...> |
| SOM (horizon) | - | <figure> [DERIVED: ...] | <share assumption A#> |

Reconciliation: <why the approaches differ>.

## 3. Pricing

| Offer | Price | Unit and period | Source |
| --- | --- | --- | --- |
| <competitor plan> | <price> | <...> | [S#] |
| <owner's planned price> | <price> | <...> | [OWNER] |

## 4. Cost Structure

| Cost line | Basis | Monthly amount | Label |
| --- | --- | --- | --- |
| Hosting and tools | <pricing page> | <amount> | [S#] / [DERIVED: ...] |
| Payment processing | <fee schedule> | <rate> | [S#] |
| Salaries and contractors | <role, location, source> | <amount> | [S#] / [OWNER] |
| Marketing | <channel, cost benchmark> | <amount> | [S#] / [ASSUMPTION A#] |
| Legal and compliance | <...> | <amount> | [S#] / [ASSUMPTION A#] |

## 5. Unit Economics

| Metric | Value | Label |
| --- | --- | --- |
| Average revenue per customer per month | <value> | <label> |
| Cost to serve per customer per month | <value> | <label> |
| Gross margin | <value> | [DERIVED: ...] |
| Customer acquisition cost | <value> | <label> |
| Monthly churn | <value> | <label> |
| Lifetime value | <value> | [DERIVED: ...] |
| Payback period | <value> | [DERIVED: ...] |

## 6. Projections

| Year | Scenario | Customers | Revenue | Costs | Net | Cash end | Driven by |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Conservative | <...> | <...> | <...> | <...> | <...> | A#, A# |
| 1 | Base | <...> | <...> | <...> | <...> | <...> | A#, A# |
| 1 | Optimistic | <...> | <...> | <...> | <...> | <...> | A#, A# |

Every figure in this table is `[DERIVED]` from the model; the model's
Assumptions sheet carries the inputs and their labels.

## 7. Sensitivity

| Assumption | Base value | If 50% worse | If 50% better | Effect on break-even |
| --- | --- | --- | --- | --- |
| A# <name> | <value> | <value> | <value> | <months> [DERIVED: ...] |

## 8. Funding Need And Use Of Funds

- Funding need (base / conservative): <amounts> [DERIVED: ...]
- Owner's funding plan: <...> [OWNER]
- Use of funds: <categories and shares> [OWNER] / [DERIVED: ...]

## 9. Risks To The Numbers

| Risk | Affected assumptions | Evidence | Mitigation |
| --- | --- | --- | --- |
| <...> | A# | <labels> | <...> |

## 10. Evidence Audit

- Lint: <result>
- Citation audit: <counts, date, verifier>
- Owner-accepted assumptions: <A# list>; owner-replaced: <A# list>
