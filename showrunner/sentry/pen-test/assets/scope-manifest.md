# Scope And Attack Surface - <engagement-id>

Store the machine-readable form as JSON with `targets` and `entry_points`
arrays. Hash those exact bytes into the engagement record.

- Rules hash:
- Scope hash:
- Inventory timestamp:
- Inventory confidence:

## Targets

| Target ID | Asset or boundary | Owner | Environment | Allowed | Notes |
| --- | --- | --- | --- | --- | --- |
| <id> | <asset> | <owner> | <environment> | yes/no | <notes> |

## Actors And Identities

| Actor | Privilege | Identity type | Test account | Restrictions |
| --- | --- | --- | --- | --- |
| <actor> | <level> | human/machine/agent | <account> | <restrictions> |

## Entry Points

| Entry ID | Target | Interface | Auth | State-changing | Consequential | Owner |
| --- | --- | --- | --- | --- | --- | --- |
| <id> | <target> | <route/tool/callback> | <mode> | yes/no | yes/no | <owner> |

## Trust Boundaries And Stores

| ID | Type | From | To | Data or capability | Control |
| --- | --- | --- | --- | --- | --- |
| <id> | boundary/store | <source> | <destination> | <asset> | <expected control> |

## Unknowns

- <unknown public surface, ownership gap, or unresolved boundary>
