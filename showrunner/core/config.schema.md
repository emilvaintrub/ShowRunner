# Project Config Schema

Each project owns one `.claude/showrunner/config.md`. It is Markdown containing
one YAML block plus optional human notes. The engine reads it as structured
instructions; no runtime parser is required.

Use paths relative to the project root unless a field explicitly permits an
absolute path. Set unsupported capabilities to `disabled`; do not delete their
keys and make the engine guess.

## Shape

```yaml
schema_version: 1

project:
  name: "<project name>"
  root_markers: ["<manifest or guidance file>"]
  primary_branch: main
  remote: origin
  guidance_files: ["<CLAUDE.md or equivalent>"]
  decision_log: "<path or disabled>"
  project_state: "<path or disabled>"
  hygiene_ledger: "<existing backlog/project-state path or disabled>"

roles:
  architect_model: "<judgment model>"
  implementer_model: "<execution model>"
  cold_context_required: true
  surface_token_cost: true

questions:
  max_per_round: 5

context_optimizer:
  enabled: false
  provider: "token-optimizer | other | disabled"
  install_hint: "<project-neutral install instruction or disabled>"
  commands:
    health: "<quick context health command or disabled>"
    audit: "<full optimization/audit command or disabled>"
    coach: "<planning/history command or disabled>"
  required_before:
    - long_arc
    - sentry_full_sweep
    - bible_sync
    - post_compaction_resume
  manual_when_unavailable: true

step0:
  read_list: ["<always-read path>"]
  require_verified_paths: true
  require_explicit_approval: true

repository:
  branch_pattern: "feat/<slug>"
  require_remote_tip_match: true
  prompt_artifacts:
    tracked: false
    cleanup_globs: ["<optional prompt glob>"]

tests:
  commands:
    unit: "<command or disabled>"
    integration: "<command or disabled>"
    bundle: "<command or disabled>"
  migration_fixture_rule: true
  fixture_clock_rule: true

design:
  token_sources: ["<path or disabled>"]
  no_hardcode: ["colors", "copy", "spacing", "motion"]
  research:
    enabled: true
    web_required: "auto | required | disabled"
    ask_for_examples: true
    min_external_sources: 3
    benchmark_count: 3
    analog_count: 2
    freshness_days: 365
    output_directory: "<path or disabled>"
    waiver_decision_id: "<decision-log id or disabled>"

locale_ceremony:
  enabled: false
  description: "disabled"
  files: []
  approval_required_before_write: false
  symmetry_check: "disabled"

quality_gates:
  wow_check:
    enabled: false
    scope: "whole_project | phase | disabled"
    decision_id: "<decision-log id, project-state anchor, or disabled>"
    defined_in: "<decision log/project-state path, or disabled>"
    substitution_policy: "<recorded replacement gate, or disabled>"
    config: {}
  audit:
    enabled: true
    severity_block: critical

smoke:
  required_for: ["runtime_state", "device", "external_ops"]
  definition: "<project smoke or disabled>"
  playbooks:
    web:
      commands: ["<npm install/build/dev command, or disabled>"]
      manual_steps: ["<browser/device action>"]
      expected_result: "<observable pass condition>"
      evidence: "<screenshot/log/link/text to return>"
    android:
      commands: ["<build APK command, install command, or disabled>"]
      manual_steps: ["<device/emulator action>"]
      expected_result: "<observable pass condition>"
      evidence: "<APK path, screenshot, logcat excerpt, or disabled>"
    ios:
      commands: ["<build/install command, or disabled>"]
      manual_steps: ["<device/simulator action>"]
      expected_result: "<observable pass condition>"
      evidence: "<screenshot, simulator log, or disabled>"
    backend:
      commands: ["<server start, migration, or curl command, or disabled>"]
      manual_steps: ["<dashboard/API action>"]
      expected_result: "<observable pass condition>"
      evidence: "<response body, log, dashboard screenshot, or disabled>"

browser_evidence:
  enabled: false
  tool: "playwright | disabled"
  install_command: "<browser install command or disabled>"
  commands:
    e2e: "<Playwright test command or disabled>"
    headed: "<headed/debug command or disabled>"
    report: "<HTML report command or disabled>"
  base_url: "<local or deployed URL, or disabled>"
  browsers: ["chromium", "firefox", "webkit"]
  devices: ["<desktop/mobile/tablet profile or disabled>"]
  locales: ["<locale or disabled>"]
  timezones: ["<timezone or disabled>"]
  artifact_directory: "<test-results/playwright-report path or disabled>"
  trace: "on-first-retry | retain-on-failure | on | off"
  screenshots: "only-on-failure | on | off"
  video: "retain-on-failure | on-first-retry | on | off"
  capture:
    console_errors: true
    page_errors: true
    failed_requests: true
    csp_violations: true
    network_log: true
    accessibility_snapshot: false
  auth:
    storage_state_path: "<path or disabled>"
    authenticated: false
    secret_redaction_required: true
  required_for: ["ui", "browser_runtime", "csp", "auth_flow"]

commit_hook:
  hooks_path: .githooks
  allowlist_prefixes:
    - feat
    - fix
    - docs
    - chore
    - refactor
    - test
    - ci
    - build
    - perf
    - revert
  install_command: "git config core.hooksPath .githooks"
  forbid_no_verify: true

merge:
  stop_before_main: true
  strategy: no-ff
  first_commit_prefix: "Merge:"
  second_commit_prefix: "docs(backlog):"
  first_parent_commit_count: 2

forge:
  status: "ready | uninitialized | disabled"
  soul_file: "<constitution path or disabled>"
  voice_rules: ["<rule>"]
  design_principle: "<principle or disabled>"
  asset_reservations: ["<rule>"]
  decision_entry_template: "<template path or disabled>"
  project_state_cadence: "<cadence or disabled>"
  outputs:
    specs_directory: "<path>"
    designer_briefs_directory: "<path or disabled>"
  creative_gate:
    command: "/wow-check"
    ship_verdict_required: true
  decision_surface:
    ask: ["name", "scope", "emotional_framing", "privacy", "monetization"]
    default: ["file_placement", "key_prefixes", "pattern_reuse"]
  designer_helper:
    tool: "<adapter slug matching forge/templates/adapters/<slug>.md, or disabled>"
    brief_template: "<template path or disabled>"
    suggested_tools: ["Claude Design", "Figma Make", "Lovable", "v0", "equivalent"]
  handoff:
    target: "/arc plan"
    seam: "spec section 8 to section 9"

arc:
  status: "ready | uninitialized | disabled"
  additional_step0_reads: []
  planning:
    plans_directory: "<path>"
    prompts_directory: "<path or untracked>"
  test_lanes:
    server: "<command or disabled>"
    web: "<command or disabled>"
    mobile: "<command or disabled>"
  migration:
    enabled: false
    pre_migration_fixture_required: true
  gates:
    audit: "<command or disabled>"
    creative: "<command or disabled>"
  smoke:
    server: "<definition or disabled>"
    web: "<definition or disabled>"
    mobile: "<definition or disabled>"

sentry:
  status: "ready | uninitialized | disabled"
  surfaces:
    backend_api: true
    web_frontend: false
    native_mobile: false
    ai_llm: false
    agentic_ai: false
    supply_chain: true
    cloud_iac_container: false
    network_infrastructure: false
    edge_dns_email: false
  stack: {}
  auth_model: {}
  tenancy:
    model: "<single-tenant, multi-tenant, or none>"
    scoping_helpers: []
  compliance:
    regimes: ["none"]
    cvss_required: false
  data_classification:
    document: "<SECURITY.md path or disabled>"
    classes: []
  deploy: {}
  database: {}
  edge_provider: "none"
  public_surfaces: []
  unauthenticated_endpoints: []
  security_test_commands: {}
  external_scanners:
    code_quality_check:
      enabled: false
      service_url: "<Code Quality Check URL or disabled>"
      run_mode: "manual | browser | api | disabled"
      allowed_targets: ["<public URL or disabled>"]
      evidence_directory: "<path or disabled>"
      report_links: ["<unlisted report URL or disabled>"]
      evidence_freshness_days: 30
      authorization:
        approval_evidence: "<path or disabled>"
        authorizing_owner: "<role or disabled>"
        privacy_notice_acknowledged: false
      include_categories:
        security: true
        ops_security: true
        performance: true
        seo: true
        accessibility: true
        quality: true
  ci_gates: []
  pen_test:
    enabled: false
    engagements_directory: "<path or disabled>"
    reports_directory: "<path or disabled>"
    evidence_directory: "<restricted path or disabled>"
    evidence_freshness_days: 30
    coverage_target_percent: 98
    critical_coverage_percent: 100
    domain_floor_percent: 95
    authorization:
      approval_evidence: "<path or disabled>"
      rules_of_engagement: "<path or disabled>"
      authorizing_owner: "<role or disabled>"
    safety:
      maximum_class: "S0 | S1 | S2 | S3"
      source_identity: "<IP, runner, or disabled>"
      max_requests_per_second: "<positive integer or disabled>"
      max_concurrency: "<positive integer or disabled>"
      max_payload_bytes: "<positive integer or disabled>"
      kill_switch: "<mechanism or disabled>"
      service_health_observer: "<role or disabled>"
    evidence:
      classification: "<class or disabled>"
      retention: "<duration or disabled>"
      storage: "<location or disabled>"
    emergency_contact: "<role or disabled>"
    cleanup_owner: "<role or disabled>"
  memory:
    security_doc: "<path or disabled>"
    accepted_risks: "<path or disabled>"
    regression_catalog: "<path or disabled>"
  backup_access_policy: "<path, prose, or disabled>"
  known_dependency_blocks: []
  mobile_signing:
    enabled: false
    ios_profile_management: "disabled"
    android_keystore_management: "disabled"
    ci_secret_storage: "disabled"
  monthly:
    enabled: false
    digest_destination: "<path or disabled>"
    accepted_risk_max_age_days: 90

bible:
  status: "ready | uninitialized | disabled"
  sources:
    forge_spec: "<path or disabled>"
    arc_ship_reports: ["<path or glob>"]
    sentry_sweep_reports: ["<path or glob>"]
    sentry_security_doc: "<path or disabled>"
    pen_test_reports: ["<path, glob, or disabled>"]
  repository_map:
    components: ["<path or glob>"]
    data_model: ["<path or glob>"]
    interfaces: ["<path or glob>"]
  audience: "engineering | capabilities | combined"
  require_exact_tip: true
  output:
    path: "<path to rendered Bible document>"
```

## Ownership

### Shared base

The base owns repository identity, role models, context hygiene, Step 0 reads,
test mechanics, design and locale constraints, hooks, smoke, and merge
ceremony. Skill sections reference or extend these bindings instead of
duplicating them.

### Forge extension

Forge owns constitution, voice, creative principles, decision evidence,
designer briefing, and the handoff seam. It may tighten the base decision
surface but cannot loosen a configured approval ceremony.

### Arc extension

Arc owns implementation test lanes, migration fixtures, code gates, and device
smoke. It reuses base dispatch, hooks, and merge.

### Sentry extension

Sentry owns attack surfaces, threat-relevant stack facts, auth, tenancy,
compliance, classification, public exposure, security tools, accepted risks,
penetration-test authorization and safety bindings, and operational cadence.
Standards versions do not belong here; they live in Sentry's refreshable
knowledge layer.

### Bible extension

Bible owns its synthesis source bindings (the Forge spec, Arc ship reports,
and Sentry sweep, security, and pen-test outputs), repository-structure hints
for component, data-model, and interface extraction, audience framing, the
rendered document's output path, and the exact-tip requirement for a bound
`sync`. It reads deploy, edge, and database facts from the Sentry extension
rather than redefining them, and reuses base hooks and merge.

## Validation

Initialization must reject or surface:

- a missing primary branch or contradictory merge count;
- `stop_before_main: false`;
- context optimization enabled without at least one configured command or an
  explicit manual fallback;
- a locale ceremony enabled without approval rules;
- a migration lane that disables pre-migration fixtures;
- Sentry enabled without tenancy and compliance declarations;
- penetration testing enabled without authorization evidence, Rules of
  Engagement, evidence handling, emergency contact, and cleanup ownership;
- Bible marked `ready` without at least one configured source under
  `bible.sources`;
- a hook allowlist that cannot admit both merge ceremony prefixes;
- project-specific facts written into the user-level engine.

An individual skill's initialization may update the shared base and its own
section. Preserve sibling skill sections byte-for-byte, except when adding a
missing `status: uninitialized` placeholder.
