# Accounts Register - <product>

> Rules: `core/ownership.md` in the ShowRunner package. This file maps who
> controls what. It never contains passwords, keys, tokens, recovery codes, or
> personal data. Rows are updated in place; history lives in Git.

| Service | Used for | Account holder | Login identity | Billing owner | 2FA (owner-confirmed) | Recovery held by | Others with access (role, revoke by) | Credentials stored in | Status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| <e.g. domain registrar> | <what the product needs it for> | <owner / owner's company / other: name> | <owner-controlled email or org> | <who pays> | yes / no / unknown | <owner / other: name> | <name, role, date or none> | <vault or secret store name, never the secret> | owner-confirmed / pending owner / at risk |

## Owner Summary

| What the product depends on | Who controls it | Risk | Action to fix |
| --- | --- | --- | --- |
