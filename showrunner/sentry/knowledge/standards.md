# Standards Manifest

This manifest is refreshable evidence, not timeless policy. A refresh records
retrieval time and digest. Version drift is reported for human redline rather
than silently changing Sentry's method.

```yaml
schema_version: 1
sources:
  - id: owasp-top-10
    surface: backend-web
    version: "2025"
    mode: versioned
    url: "https://owasp.org/Top10/2025/"
  - id: owasp-api-top-10
    surface: backend-api
    version: "2023"
    mode: versioned
    url: "https://owasp.org/API-Security/editions/2023/en/0x11-t10/"
  - id: owasp-asvs
    surface: application
    version: "5.0.0"
    mode: versioned
    url: "https://github.com/OWASP/ASVS/releases/tag/v5.0.0"
  - id: owasp-wstg
    surface: web-api-testing
    version: "4.2"
    mode: versioned
    url: "https://owasp.org/www-project-web-security-testing-guide/v42/"
  - id: cwe-top-25
    surface: software
    version: "2025"
    mode: versioned
    url: "https://cwe.mitre.org/top25/archive/2025/2025_cwe_top25.html"
  - id: nist-digital-identity
    surface: authentication
    version: "800-63B-4"
    mode: versioned
    url: "https://pages.nist.gov/800-63-4/sp800-63b.html"
  - id: owasp-masvs
    surface: native-mobile
    version: "living"
    mode: digest
    url: "https://mas.owasp.org/MASVS/"
  - id: owasp-mastg
    surface: native-mobile-testing
    version: "living"
    mode: digest
    url: "https://mas.owasp.org/MASTG/"
  - id: owasp-mobile-top-10
    surface: native-mobile
    version: "2024"
    mode: versioned
    url: "https://owasp.org/www-project-mobile-top-10/"
  - id: owasp-llm-top-10
    surface: ai-llm
    version: "2025"
    mode: versioned
    url: "https://genai.owasp.org/llm-top-10/"
  - id: owasp-agentic-top-10
    surface: agentic-ai
    version: "2026"
    mode: versioned
    url: "https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/"
  - id: owasp-nhi-top-10
    surface: machine-identity
    version: "2025"
    mode: versioned
    url: "https://owasp.org/www-project-non-human-identities-top-10/2025/"
  - id: nist-security-testing
    surface: assessment-method
    version: "800-115"
    mode: versioned
    url: "https://csrc.nist.gov/pubs/sp/800/115/final"
  - id: nist-ssdf
    surface: software-supply-chain
    version: "800-218"
    mode: versioned
    url: "https://csrc.nist.gov/pubs/sp/800/218/final"
  - id: cyclonedx
    surface: software-ai-inventory
    version: "1.7"
    mode: versioned
    url: "https://cyclonedx.org/specification/overview/"
  - id: osv
    surface: dependencies
    version: "rolling"
    mode: digest
    url: "https://osv.dev/"
```

## Refresh Rules

- Fetch only the configured URL; redirects must remain on the same allowed
  official domain.
- Store retrieval time, status, digest, extracted version, adapter name, and
  the fetched response body.
- A changed digest on a `digest` source is informational until reviewed.
- A changed major or year on a `versioned` source is `REDLINE REQUIRED`.
- A fetched `versioned` source whose version cannot be extracted is
  `REVIEW REQUIRED`, not proven drift.
- A fetch failure retains the previous cache and marks the source stale.
- Standards mappings in reports cite IDs from this manifest, not copied prose.
