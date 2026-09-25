# Ownership And Access

The owner brings the idea and owns the product. That ownership is only real if
the owner also controls everything the product runs on: the code, the domain,
the hosting, the app-store listings, the payment and email accounts, the data,
and the credentials. Founders lose products when a contractor, an agency, or an
agent sets these up under the wrong account and leaves. ShowRunner checks this
continuously, and never holds or hides the keys.

## 1. The Accounts Register

Keep one register at `ownership.register` (config), created from
[templates/accounts-register.md](templates/accounts-register.md). One row per
external service or asset the product depends on:

- the service and what it is used for;
- the account holder (the owner, the owner's company, or someone else - name
  them);
- the login identity (the owner-controlled email or organization);
- billing owner;
- two-factor authentication status, as confirmed by the owner;
- recovery method (who can recover the account if access is lost);
- who else has access - people, contractors, and agents - with their role;
- where the credentials live (the name of the password manager, vault, or
  secret store - never the secret itself);
- status: `owner-confirmed`, `pending owner`, or `at risk`.

The register never contains passwords, API keys, tokens, recovery codes, or
personal data. It is a map of who controls what, not a vault.

## 2. When It Is Checked

- **Setup**: ShowRunner inventories every external service the repository
  evidences - hosting and deploy config, domains in code or DNS files,
  package registries, analytics and error-tracking IDs, payment, email, and
  auth SDKs, app-store metadata, cloud and infrastructure files, CI secrets
  referenced by workflows - and drafts a row for each. The owner confirms
  holder, login identity, and two-factor status for each row. ShowRunner
  cannot verify account ownership itself; it asks, and records the answer
  verbatim.
- **Spec and Step 0**: an initiative that introduces a new external service
  names it in spec section 5; the Step 0 describe-back lists it. A new
  service that is not in the register is a scope STOP: the owner creates or
  confirms the account before build uses it.
- **Release**: before any release step, every service the release touches
  must be `owner-confirmed`. An `at risk` or `pending owner` row blocks the
  release question until the owner resolves it or explicitly accepts the risk
  in their own words.
- **Close**: access granted for this initiative (a contractor, a temporary
  deploy token, an agent credential) is listed with a revocation date; revoke
  or confirm it at close.
- **Periodically**: every session start flags `at risk` rows and access past
  its revocation date.

## 3. Rules

- **Accounts are the owner's.** Never create an account, register a domain,
  publish to a store, or accept terms of service on the owner's behalf under
  any identity other than one the owner named for that purpose. Recommend what
  to create and how; the owner creates it.
- **No secrets in the repository.** Credentials live in the named secret store
  and reach the product through environment variables or the platform's
  secret mechanism. A secret found in the repository or its history is a
  Sentry finding of the highest severity, and rotating it is the owner's
  first action.
- **Least access, named and revocable.** Every person, contractor, and agent
  with access is listed with the narrowest role that works and a way to
  revoke it. Agent credentials are scoped to the task and expire.
- **The owner holds recovery.** Recovery email, phone, and backup codes belong
  to the owner. An account whose recovery sits with someone else is `at risk`.
- **Code and data are portable.** The primary repository and production data
  sit in accounts the owner controls, with a backup the owner can reach without
  anyone's help. Record where.
- **Say it plainly.** Explain each risk in one sentence a non-technical owner
  understands ("If the developer's personal email owns the domain, they can
  take your site offline by letting it lapse").

## 4. Plain-Language Summary

At setup and at every release, give the owner a short table: what the product
depends on, who controls each piece, what is at risk, and the one action that
would fix each risk.
