# ShowRunner Eval Suite

Automated, repeatable eval cases for the behavioral scenarios in
[`docs/SCENARIOS.md`](../docs/SCENARIOS.md). Each case runs the ShowRunner
plugin against a disposable fixture repository for one agent turn and grades
the result with `claude plugin eval` (Claude Code 2.1+). This replaces
running the scenarios by hand with fresh agents on throwaway fixture repos:
the same 27 scenarios now run in CI on every prose change and on a weekly
schedule, so a rule edit or a new model generation cannot silently regress a
scenario that was manually verified once and never checked again.

## What Each Case Does

A case's `context.scaffold_script` builds a small git repository in the run's
ephemeral workspace (config, ledger, and supporting docs matching the
scenario's `Setup:` line), then the owner's message from the scenario is sent
as the case's `execution.prompt`. Every case grades:

- `showrunner-skill-fired` (`tool_used`, `Skill`, min 1) - the showrunner
  skill actually triggers from its own description, the way a real session
  would, rather than being told to read `SKILL.md`.
- A `llm` grader (`meets-scenario-pass-criteria`) built directly from the
  scenario's `Pass:` line in `docs/SCENARIOS.md`.
- Deterministic graders wherever the scenario's pass condition is a hard
  invariant rather than wording that can legitimately vary: no product-file
  edits yet (`tool_used` `Write`/`Edit` under `src/`/`test/`, max 0), no
  deploy command runs (`tool_used` `Bash` matching `vercel --prod` /
  `npm publish` / etc., max 0), a required tool call actually happens (for
  example `showrunner-sources lint`), required ledger text or file state,
  and forbidden phrasings (for example no "is free"/"is available" claim
  about a trademark, no flattery, no canned "skip design/security" example
  wording).

`context.scaffold_script` is a path to a real script, resolved relative to
the *case's own directory* - the harness execs it directly with the process's
cwd already set to the run's ephemeral workspace; it is not a shell command
line and gets no arguments or `$CLAUDE_PLUGIN_ROOT`-style expansion. Each case
therefore has its own tiny `scaffold.sh` (one line different per case: which
fixture to build) that calls into the shared library:

```sh
#!/bin/sh
set -eu
here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
exec python3 "$here/../_fixtures/build.py" "<case-id>"
```

The real work lives once in `evals/_fixtures/build.py` (one function per
case) and `evals/_fixtures/lib.py` (shared git/YAML/ledger helpers). Neither
file is itself a case (no `case.yaml`/`prompt.md`), so case discovery skips
the `_fixtures/` directory. Every fixture's `.claude/showrunner/state.md`
ledger is designed to pass `showrunner check`; `tests/run.sh` verifies this on
every run (calling `build.py` directly) without spending any model calls.

### Sandbox backend for `--allow-tools Bash`

Granting the case's `Bash` tool (`--allow-tools ... Bash`) requires a working
sandbox backend on the machine running `claude plugin eval` - on Linux that
means `bubblewrap` (`bwrap`) and `socat` installed
(`apt install bubblewrap socat` on Debian/Ubuntu; see
<https://code.claude.com/docs/en/sandboxing>). Without them, any case whose
`allowed_tools` includes `Bash` fails immediately with
`sandbox required but unavailable`, before the model is called (at effectively
no cost). Verify locally with `claude plugin eval . --case <name>
--allow-tools Bash --max-cost-usd 1 --scaffold --trust-plugin --no-publish`.
GitHub's `ubuntu-latest` runner is not documented as shipping either package,
so the `evals` workflow installs them itself before running the suite.

## Scenario -> Case Mapping

| Scenario | Case directory |
| --- | --- |
| 1 | `plain-request-no-command` |
| 2 | `resume-after-break` |
| 3 | `just-ship-it` |
| 4 | `small-fix-full-path` |
| 6 | `mid-build-scope-creep` |
| 8 | `release-asked-not-assumed` |
| 9 | `command-for-later-stage` |
| 10 | `technical-questions-stay-technical` |
| 12 | `newcomer-vague-idea` |
| 13 | `experienced-owner-firm-plan` |
| 14 | `no-research-access` |
| 15 | `unsourced-figure` |
| 16 | `deck-fact-nobody-researched` |
| 17 | `owner-selects-no-business-docs` |
| 18 | `new-feature-idea-mid-build` |
| 19 | `product-steer-mid-build` |
| 20 | `parked-idea-returns` |
| 21 | `outcome-review-due` |
| 22 | `account-not-in-owners-control` |
| 23 | `new-service-in-spec` |
| 24 | `production-incident` |
| 25 | `copyleft-dependency` |
| 26 | `naming-a-product` |
| 27 | `rescue-mid-development` |
| 28 | `delegate-approval-and-disagreement` |
| 29 | `customer-feedback-routing` |
| 30 | `budget-reached` |

### Not Automated

- **Scenario 5** (build chain runs unattended) - spans many unattended turns
  (dispatch, Step 0 approval, build, verify, security) rather than a single
  agent turn a case can script and grade.
- **Scenario 7** (verify loop limit) - a genuine third `FIX` verdict depends
  on the independent verify reviewer judging real build output; a fixture can
  set `fix_loops: 2`, but it cannot force a real verify reviewer to return a
  third `FIX` without an actual build to review, so this cannot be scripted
  deterministically in one turn.
- **Scenario 11** (enforcement backs the prose) - this is the mechanical
  hook-blocking behavior already covered by `sh tests/run.sh` (the guard and
  pre-commit tests), not agent judgment.

## Tags

- `smoke`: `plain-request-no-command`, `just-ship-it`,
  `command-for-later-stage`, `no-research-access`,
  `account-not-in-owners-control`, `production-incident`,
  `rescue-mid-development` - a small, cheap, high-value subset for quick
  checks.
- Topical: `lifecycle`, `discovery`, `evidence`, `steering`, `ownership`,
  `outcomes`, `incident`, `legal`, `adoption`, `delegates`, `feedback`,
  `cost`.

## Running Locally

Requires Claude Code 2.1+ (`claude plugin eval --help`) and
`ANTHROPIC_API_KEY` set. Run from the repository root.

```sh
# Smoke subset only (cheap, ~7 cases):
claude plugin eval . --trust-plugin --scaffold --allow-tools Bash Write Edit \
  --tag smoke --ablation none --runs 1 --no-publish --max-cost-usd 2

# One case:
claude plugin eval . --case plain-request-no-command --trust-plugin \
  --scaffold --allow-tools Bash Write Edit --ablation none --runs 1 \
  --no-publish --max-cost-usd 1

# The full suite (all 27 cases):
claude plugin eval . --trust-plugin --scaffold --allow-tools Bash Write Edit \
  --ablation none --runs 1 --threshold 0.8 --no-publish --max-cost-usd 10
```

Notes:

- `--scaffold` runs each case's `scaffold_script` as you (author-supplied
  bash) - only run it against case files you or your organization authored,
  which is true of everything under `evals/` here.
- `--allow-tools Bash Write Edit` is the operator grant required for those
  gated tools; each case's own `execution.allowed_tools` must also list them
  (it does) - both are required for a gated tool to actually be usable in a
  run.
- `--ablation none` skips the no-plugin baseline arm, which is not useful
  here (a comparison against "no ShowRunner plugin at all" answering a
  ShowRunner-specific owner message) and roughly halves the cost.
- `--max-cost-usd` is a hard ceiling; drop it or raise it for a full run of
  all 27 cases with 3 judged votes per `llm` grader.
- Add `--json <path>` to get the full machine-readable result, and drop
  `--no-publish` if you want the shareable HTML report link.

## Cost Guidance

Each case is one agent turn (`runs: 1`, `max_turns: 15`) plus up to 3 judged
`llm`-grader votes (haiku by default; override with `--judge-model`). The
smoke subset is the cheapest way to catch a regression quickly; the full
suite costs more and is what the weekly schedule and manual
`workflow_dispatch` runs use by default.
