# Privacy

ShowRunner is designed as a local workflow package. It does not include hosted
services, telemetry, analytics, or background network calls.

## What ShowRunner Stores

ShowRunner may create project-local workflow files when a user asks an agent to
initialize or operate it. Those files normally live inside the target project
and can include:

- project configuration;
- plans and specifications;
- design briefs;
- security findings and accepted-risk records;
- browser-evidence paths;
- architecture and capability summaries.

These files belong to the target project. They may contain project-specific
information, so users should review them before publishing a project.

## Optional External Tools

ShowRunner can reference optional companion tools such as Playwright, external
scanner services, design engines, and context optimizers. Those tools are not
bundled with ShowRunner and are governed by their own privacy and license
terms.

When an external tool is configured, the user is responsible for:

- confirming the tool is allowed for the project;
- avoiding secrets, customer data, and private targets unless explicitly
  authorized;
- reviewing what evidence, URLs, screenshots, traces, or reports are shared.

## No Telemetry

The ShowRunner package itself does not phone home, collect usage metrics, or
send workflow data to the maintainers.

## Publishing Projects

Before publishing a repository that used ShowRunner, review generated project
artifacts for private product decisions, security evidence, URLs, credentials,
customer data, and internal process notes.
