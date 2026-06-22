# Severity Rubric

Use plain-language tiers. Add CVSS only when project config requires it.

- **Critical**: practical path to broad compromise, privileged control,
  catastrophic data loss, or high-impact cross-tenant disclosure with weak
  preconditions.
- **High**: serious confidentiality, integrity, availability, or authorization
  failure affecting sensitive or privileged scope.
- **Medium**: meaningful exploit with narrower reach, stronger preconditions,
  or effective compensating controls.
- **Low**: limited impact, difficult exploitation, or defense-in-depth gap.
- **Info**: observation, hardening opportunity, or unverified signal.

Rate impact and likelihood separately. State preconditions, affected actors,
data class, blast radius, and compensating controls. Do not inflate severity to
force priority or reduce it to avoid work.
