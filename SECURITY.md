# Security Policy

ShowRunner is a workflow package. It does not run a hosted service, collect
telemetry, or scan targets by itself.

## Supported Versions

Security fixes are accepted for the current public release line.

| Version | Supported |
| --- | --- |
| 1.x | Yes |

## Reporting A Vulnerability

Please report vulnerabilities through GitHub's private vulnerability reporting
feature if available for this repository. If that is unavailable, open a public
issue with only a high-level description and avoid including exploit details,
secrets, private project data, or live target information.

Useful reports include:

- affected file or workflow area;
- expected behavior;
- observed behavior;
- minimal reproduction using non-sensitive data;
- impact and suggested severity.

## Scope

In scope:

- unsafe workflow instructions that could cause unauthorized writes, merges, or
  security testing;
- missing authorization gates for Sentry or penetration-test workflows;
- instructions that could leak secrets, private project data, or sensitive
  evidence;
- package-install behavior that writes outside the requested target.

Out of scope:

- vulnerabilities in third-party tools configured by a project;
- findings from scans against systems you do not own or have permission to test;
- project-specific misconfiguration outside the reusable ShowRunner package.

## Security Model

ShowRunner treats active scanning, live-site checks, and penetration testing as
authorization-gated workflows. A project must supply target scope, owner
approval, safety limits, evidence handling, and cleanup requirements before
those workflows proceed.
