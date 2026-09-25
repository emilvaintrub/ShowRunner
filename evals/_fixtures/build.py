#!/usr/bin/env python3
"""Fixture dispatcher for the ShowRunner eval suite.

Usage: build.py <case-id> [root]

`root` defaults to the current working directory (the eval run's workspace
when invoked as a case's `context.scaffold_script`). Each case builds a small
git repository whose `.claude/showrunner/state.md` ledger is designed to pass
`showrunner check`.
"""
import datetime
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib  # noqa: E402


def _today():
    return datetime.date.today().isoformat()


# ---------------------------------------------------------------------------
# Case 1 / 4: no active initiative, constitution approved.
# ---------------------------------------------------------------------------
def _no_active_initiative(root):
    lib.git_init(root)
    lib.app_base(root)
    lib.shelfie_docs(root)
    lib.write(root, ".claude/showrunner/config.md", lib.render_config())
    lib.write_state(
        root,
        lib.base_active(),
        ledger_rows=lib.proj_rows_all(),
    )
    lib.git_commit(root, "chore: initial")


def case_plain_request_no_command(root):
    _no_active_initiative(root)


def case_small_fix_full_path(root):
    _no_active_initiative(root)


# ---------------------------------------------------------------------------
# Case 2: resume after a break (design-review, awaiting-owner).
# ---------------------------------------------------------------------------
def case_resume_after_break(root):
    lib.git_init(root)
    lib.app_base(root)
    lib.shelfie_docs(root)
    lib.write(root, ".claude/showrunner/config.md", lib.render_config())
    lib.write(root, "docs/briefs/loan-list.md", (
        "# Designer Brief - Loan list\n\n> Status: inventor-approved\n\n"
        "Surface: Loan list. States: default, empty, loading, error. "
        "Return: screenshots of each state from the design engine.\n"
    ))
    lib.write(root, "docs/specs/loan-list.md", (
        "# Feature Specification - Loan list\n\n> Status: inventor-approved\n\n"
        "(sections 1-8 approved)\n"
    ))
    active = lib.base_active(
        initiative="I-001", title="Loan list page", stage="design-review",
        status="awaiting-owner",
        awaiting="design-engine output for the Loan list surface (all states) per docs/briefs/loan-list.md",
    )
    ledger = lib.proj_rows_all() + lib.init_rows_upto("I-001", "design-review")
    lib.write_state(
        root, active,
        initiatives=[("I-001", "Loan list page", "2026-09-12",
                       '"I want a page listing who has my books."',
                       "design-review", "awaiting-owner")],
        ledger_rows=ledger,
    )
    lib.git_commit(root, "docs(showrunner): fixture state")


# ---------------------------------------------------------------------------
# Case 3 / 9: spec, awaiting redline.
# ---------------------------------------------------------------------------
def _spec_awaiting_redline(root):
    lib.git_init(root)
    lib.app_base(root)
    lib.shelfie_docs(root)
    lib.write(root, ".claude/showrunner/config.md", lib.render_config())
    lib.write(root, "docs/specs/loan-list.md", (
        "# Feature Specification - Loan list\n\n> Status: draft\n\n"
        "## 1. Intent\nShow who has which book.\n\n"
        "## 2. Scope\nList of active loans.\n\n(sections 3-8 drafted)\n"
    ))
    active = lib.base_active(
        initiative="I-001", title="Loan list page", stage="spec",
        status="awaiting-owner",
        awaiting="redline of spec sections 1-8 in docs/specs/loan-list.md",
    )
    ledger = lib.proj_rows_all() + lib.init_rows_upto("I-001", "spec")
    lib.write_state(
        root, active,
        initiatives=[("I-001", "Loan list page", "2026-09-12",
                       '"I want a page listing who has my books."',
                       "spec", "awaiting-owner")],
        ledger_rows=ledger,
    )
    lib.git_commit(root, "docs(showrunner): fixture state")


def case_just_ship_it(root):
    _spec_awaiting_redline(root)


def case_command_for_later_stage(root):
    _spec_awaiting_redline(root)


# ---------------------------------------------------------------------------
# Case 6 / 18: build stage, feature branch, out-of-scope items recorded.
# ---------------------------------------------------------------------------
def _build_stage_shelfie(root):
    lib.git_init(root)
    lib.app_base(root)
    lib.shelfie_docs(root)
    lib.write(root, ".claude/showrunner/config.md", lib.render_config())
    lib.write(root, "docs/specs/loan-list.md", (
        "# Feature Specification - Loan list\n\n> Status: arc-ready\n\n"
        "List of active loans. Out of scope: export, reminders.\n"
    ))
    active = lib.base_active(
        initiative="I-001", title="Loan list page", stage="build",
        status="in-progress", feature_branch="feat/loan-list",
        step0_approved="sha256:ab12cd",
    )
    ledger = lib.proj_rows_all() + lib.init_rows_upto("I-001", "build")
    lib.write_state(
        root, active,
        initiatives=[("I-001", "Loan list page", "2026-09-12",
                       '"I want a page listing who has my books."',
                       "build", "in-progress")],
        ledger_rows=ledger,
        guard_extra=["docs/*"],
        release_patterns=["vercel --prod", "npx vercel --prod"],
    )
    lib.git_commit(root, "docs(showrunner): fixture state")
    lib.git_branch(root, "feat/loan-list")


def case_mid_build_scope_creep(root):
    _build_stage_shelfie(root)


def case_new_feature_idea_mid_build(root):
    _build_stage_shelfie(root)


# ---------------------------------------------------------------------------
# Case 19: product steer mid-build (dental scheduler, D3 segment on record).
# ---------------------------------------------------------------------------
def case_product_steer_mid_build(root):
    lib.git_init(root)
    lib.app_base(root)
    lib.shelfie_docs(root)
    lib.write(root, ".claude/showrunner/config.md", lib.render_config())
    lib.write(root, "docs/discovery-brief.md", lib.DISCOVERY_BRIEF)
    lib.write(root, "docs/specs/scheduling-calendar.md", (
        "# Feature Specification - Chair scheduling calendar\n\n"
        "> Status: arc-ready\n\n"
        "Weekly calendar of chair bookings for independent practices. "
        "Out of scope: multi-location chains.\n"
    ))
    active = lib.base_active(
        initiative="I-001", title="Chair scheduling calendar", stage="build",
        status="in-progress", feature_branch="feat/scheduling-calendar",
        step0_approved="sha256:ab12cd",
    )
    ledger = lib.proj_rows_all(business_evidence='"All four, please."') + \
        lib.init_rows_upto("I-001", "build")
    lib.write_state(
        root, active,
        initiatives=[("I-001", "Chair scheduling calendar", "2026-09-12",
                       '"I want the front desk to see a weekly chair calendar."',
                       "build", "in-progress")],
        ledger_rows=ledger,
        guard_extra=["docs/*"],
        release_patterns=["vercel --prod", "npx vercel --prod"],
    )
    lib.git_commit(root, "docs(showrunner): fixture state")
    lib.git_branch(root, "feat/scheduling-calendar")


# ---------------------------------------------------------------------------
# Case 8 / 22: release stage.
# ---------------------------------------------------------------------------
def _release_stage(root, accounts_rows=None, accounts_summary=None):
    lib.git_init(root)
    lib.app_base(root)
    lib.shelfie_docs(root)
    lib.write(root, ".claude/showrunner/config.md", lib.render_config())
    lib.write(root, "docs/specs/loan-list.md",
              "# Feature Specification - Loan list\n\n> Status: arc-ready\n")
    if accounts_rows is not None:
        lib.write(root, "docs/accounts-register.md",
                  lib.accounts_register(accounts_rows, accounts_summary or ()))
    active = lib.base_active(
        initiative="I-001", title="Loan list page", stage="release",
        status="in-progress", feature_branch="feat/loan-list",
        step0_approved="sha256:ab12cd",
    )
    ledger = lib.proj_rows_all() + lib.init_rows_upto("I-001", "release")
    lib.write_state(
        root, active,
        initiatives=[("I-001", "Loan list page", "2026-09-12",
                       '"I want a page listing who has my books."',
                       "release", "in-progress")],
        ledger_rows=ledger,
        release_patterns=["vercel --prod", "npx vercel --prod", "npm publish"],
    )
    lib.git_commit(root, "docs(showrunner): fixture state")


def case_release_asked_not_assumed(root):
    _release_stage(root)


def case_account_not_in_owners_control(root):
    _release_stage(
        root,
        accounts_rows=[(
            "Domain registrar", "holds the production domain",
            "freelance developer (personal email)",
            "dev@personal-email.example", "owner", "unknown",
            "developer", "none", "password manager (developer's)",
            "at risk",
        )],
        accounts_summary=[(
            "Production domain", "freelance developer, personal email",
            "developer can let it lapse or move it without the owner",
            "move the domain to the owner's own registrar account",
        )],
    )


# ---------------------------------------------------------------------------
# Case 10: fresh repository, setup stage (no config, no state at all).
# ---------------------------------------------------------------------------
def case_technical_questions_stay_technical(root):
    lib.git_init(root)
    lib.app_base(root)
    lib.git_commit(root, "chore: initial")


# ---------------------------------------------------------------------------
# Case 12 / 13: fresh project after setup, discovery stage, no brief yet.
# ---------------------------------------------------------------------------
def _fresh_discovery(root):
    lib.git_init(root)
    lib.write(root, "README.md", "# New project\n")
    lib.write(root, ".claude/showrunner/config.md", lib.render_config())
    active = lib.base_active(stage="discovery")
    lib.write_state(root, active, ledger_rows=lib.proj_rows_upto("discovery"))
    lib.git_commit(root, "chore(showrunner): setup")


def case_newcomer_vague_idea(root):
    _fresh_discovery(root)


def case_experienced_owner_firm_plan(root):
    _fresh_discovery(root)


# ---------------------------------------------------------------------------
# Case 14: assessment stage, discovery brief approved, no web access.
# ---------------------------------------------------------------------------
def case_no_research_access(root):
    lib.git_init(root)
    lib.write(root, "README.md", "# New project\n")
    lib.write(root, ".claude/showrunner/config.md", lib.render_config())
    lib.write(root, "docs/discovery-brief.md", lib.DISCOVERY_BRIEF)
    active = lib.base_active(stage="assessment")
    ledger = lib.proj_rows_upto("assessment")[:1] + [
        lib.proj_row("discovery", evidence='"Yes, that brief is right."')
    ]
    lib.write_state(root, active, ledger_rows=ledger)
    lib.git_commit(root, "chore(showrunner): setup")


# ---------------------------------------------------------------------------
# Case 15: unsourced figure in a business document draft.
# ---------------------------------------------------------------------------
def case_unsourced_figure(root):
    lib.git_init(root)
    lib.write(root, "README.md", "# New project\n")
    lib.write(root, ".claude/showrunner/config.md",
              lib.render_config(business_selected='["competitor-analysis"]'))
    lib.write(root, "docs/business/research-registers.md", (
        "## Sources\n\n"
        "| ID | Title | Publisher | URL | Published | Accessed | Type | Excerpt |\n"
        "| --- | --- | --- | --- | --- | --- | --- | --- |\n"
        "| S1 | Pricing page | Acme | https://acme.example/pricing | 2025 | "
        "2026-09-01 | primary | \"Plans start at $12/user/month\" |\n\n"
        "## Search Log\n\n"
        "| ID | Date | Tool | Query | Results opened | Notes |\n"
        "| --- | --- | --- | --- | --- | --- |\n\n"
        "## Assumptions\n\n"
        "| ID | Assumption | Value | Rationale | Based on | Sensitivity | Owner status |\n"
        "| --- | --- | --- | --- | --- | --- | --- |\n"
    ))
    lib.write(root, "docs/business/competitor-analysis.md", (
        "# Competitor Analysis - Shelfie\n\n> Status: draft\n\n"
        "## Competitor X\n\nCompetitor X charges $29 per month.\n"
    ))
    active = lib.base_active(stage="business-docs")
    lib.write_state(root, active, ledger_rows=lib.proj_rows_upto("business-docs"))
    lib.git_commit(root, "chore(showrunner): fixture state")


# ---------------------------------------------------------------------------
# Case 16: deck asks for a fact nobody researched.
# ---------------------------------------------------------------------------
def case_deck_fact_nobody_researched(root):
    lib.git_init(root)
    lib.write(root, "README.md", "# New project\n")
    lib.write(root, ".claude/showrunner/config.md", lib.render_config(
        business_selected='["competitor-analysis", "financial-plan", "investor-deck"]'
    ))
    lib.write(root, "docs/business/research-registers.md", (
        "## Sources\n\n"
        "| ID | Title | Publisher | URL | Published | Accessed | Type | Excerpt |\n"
        "| --- | --- | --- | --- | --- | --- | --- | --- |\n"
        "| S1 | Pricing page | Acme | https://acme.example/pricing | 2025 | "
        "2026-09-01 | primary | \"Plans start at $12/user/month\" |\n\n"
        "## Search Log\n\n"
        "| ID | Date | Tool | Query | Results opened | Notes |\n"
        "| --- | --- | --- | --- | --- | --- |\n\n"
        "## Assumptions\n\n"
        "| ID | Assumption | Value | Rationale | Based on | Sensitivity | Owner status |\n"
        "| --- | --- | --- | --- | --- | --- | --- |\n"
    ))
    lib.write(root, "docs/business/competitor-analysis.md",
              "# Competitor Analysis - Shelfie\n\n> Status: approved\n\n"
              "Acme's plans start at $12/user/month [S1].\n")
    lib.write(root, "docs/business/financial-plan.md",
              "# Financial Plan - Shelfie\n\n> Status: approved\n\n"
              "Pricing anchored to Acme at $12/user/month [S1].\n")
    lib.write(root, "docs/business/investor-deck.md",
              "# Investor Deck - Shelfie\n\n> Status: draft\n\n"
              "Slides: problem, solution, market, team, ask.\n"
              "(no 'why now' slide yet)\n")
    active = lib.base_active(stage="business-docs")
    lib.write_state(root, active, ledger_rows=lib.proj_rows_upto("business-docs"))
    lib.git_commit(root, "chore(showrunner): fixture state")


# ---------------------------------------------------------------------------
# Case 17: owner selects no business documents.
# ---------------------------------------------------------------------------
def case_owner_selects_no_business_docs(root):
    lib.git_init(root)
    lib.write(root, "README.md", "# New project\n")
    lib.write(root, ".claude/showrunner/config.md", lib.render_config())
    active = lib.base_active(stage="business-docs")
    lib.write_state(root, active, ledger_rows=lib.proj_rows_upto("business-docs"))
    lib.git_commit(root, "chore(showrunner): fixture state")


# ---------------------------------------------------------------------------
# Case 20: parked idea returns at close.
# ---------------------------------------------------------------------------
def case_parked_idea_returns(root):
    lib.git_init(root)
    lib.app_base(root)
    lib.shelfie_docs(root)
    lib.write(root, ".claude/showrunner/config.md", lib.render_config())
    lib.write(root, "docs/project-state.md", lib.PROJECT_STATE.replace(
        "## Open Questions\n- none\n",
        "## Open Questions\n- none\n\n## Metrics\n- Active users: 52 (as of 2026-09-20)\n",
    ))
    lib.write(root, "docs/ideas-log.md", lib.ideas_log([(
        "IDEA-3", "2026-08-01", "roadmap, I-001",
        '"Could we let people react with an emoji when a book comes back?"',
        "feature idea", "docs/specs/loan-list.md", "unaffected",
        'park: "let\'s wait and see if anyone asks for it"',
        "parked", "after the first 50 users",
    )]))
    active = lib.base_active(
        initiative="I-001", title="Loan list page", stage="close",
        status="in-progress", feature_branch="feat/loan-list",
        step0_approved="sha256:ab12cd",
    )
    ledger = lib.proj_rows_all() + lib.init_rows_upto(
        "I-001", "close", overrides={"release": '"Release it."'})
    lib.write_state(
        root, active,
        initiatives=[("I-001", "Loan list page", "2026-09-12",
                       '"I want a page listing who has my books."',
                       "close", "in-progress")],
        ledger_rows=ledger,
    )
    lib.git_commit(root, "docs(showrunner): fixture state")


# ---------------------------------------------------------------------------
# Case 21: outcome review comes due.
# ---------------------------------------------------------------------------
def case_outcome_review_due(root):
    lib.git_init(root)
    lib.app_base(root)
    lib.shelfie_docs(root)
    lib.write(root, ".claude/showrunner/config.md", lib.render_config())
    active = lib.base_active()
    ledger = lib.proj_rows_all() + lib.init_rows_upto("I-001", "close") + [
        lib.init_row("I-001", "close", evidence='"Ship it."')
    ]
    lib.write_state(
        root, active,
        initiatives=[("I-001", "Loan list page", "2026-08-01",
                       '"I want a page listing who has my books."',
                       "close", "done")],
        outcome_reviews=[(
            "I-001", "loans recorded per active user per week",
            "at least 1 / below 0.3", "analytics export", _today(), "", "",
        )],
        ledger_rows=ledger,
    )
    lib.git_commit(root, "docs(showrunner): fixture state")


# ---------------------------------------------------------------------------
# Case 23: new service appears in a spec.
# ---------------------------------------------------------------------------
def case_new_service_in_spec(root):
    lib.git_init(root)
    lib.app_base(root)
    lib.shelfie_docs(root)
    lib.write(root, ".claude/showrunner/config.md", lib.render_config())
    lib.write(root, "docs/accounts-register.md", lib.accounts_register([(
        "Hosting", "runs the web app", "owner", "owner@example.com",
        "owner", "yes", "owner", "none", "1Password (owner's)",
        "owner-confirmed",
    )]))
    lib.write(root, "docs/specs/loan-list.md", (
        "# Feature Specification - Loan list\n\n> Status: draft\n\n"
        "## 1. Intent\nShow who has which book, and remind by email.\n\n"
        "## 5. External Services\n"
        "Needs a transactional email service (for example SendGrid or "
        "Postmark) to send loan reminders; not yet in the accounts register.\n"
    ))
    active = lib.base_active(
        initiative="I-001", title="Loan list page", stage="spec",
        status="awaiting-owner",
        awaiting="redline of spec sections 1-8 in docs/specs/loan-list.md",
    )
    ledger = lib.proj_rows_all() + lib.init_rows_upto("I-001", "spec")
    lib.write_state(
        root, active,
        initiatives=[("I-001", "Loan list page", "2026-09-12",
                       '"I want a page listing who has my books, and remind me by email."',
                       "spec", "awaiting-owner")],
        ledger_rows=ledger,
    )
    lib.git_commit(root, "docs(showrunner): fixture state")


# ---------------------------------------------------------------------------
# Case 24: production incident.
# ---------------------------------------------------------------------------
def case_production_incident(root):
    lib.git_init(root)
    lib.app_base(root)
    lib.shelfie_docs(root)
    lib.write(root, ".claude/showrunner/config.md", lib.render_config())
    i001_overrides = {
        "release": (
            '"Release now; ShowRunner executes; rollback: run `vercel rollback` '
            'to restore the previous deployment if anything breaks."'
        ),
        "close": '"Ship it."',
    }
    i001_rows = lib.init_rows_upto("I-001", "close", overrides=i001_overrides) + [
        lib.init_row("I-001", "close", evidence=i001_overrides["close"])
    ]
    i002_rows = lib.init_rows_upto("I-002", "build")
    active = lib.base_active(
        initiative="I-002", title="CSV export", stage="build",
        status="in-progress", feature_branch="feat/csv-export",
        step0_approved="sha256:beef01",
    )
    lib.write_state(
        root, active,
        initiatives=[
            ("I-001", "Loan list page", "2026-08-01",
             '"I want a page listing who has my books."', "close", "done"),
            ("I-002", "CSV export", "2026-09-15",
             '"Also add CSV export while you\'re there."', "build", "in-progress"),
        ],
        ledger_rows=lib.proj_rows_all() + i001_rows + i002_rows,
        guard_extra=["docs/*"],
        release_patterns=["vercel --prod", "npx vercel --prod", "vercel rollback"],
    )
    lib.git_commit(root, "docs(showrunner): fixture state")
    lib.git_branch(root, "feat/csv-export")


# ---------------------------------------------------------------------------
# Case 25: copyleft dependency discovered at the security stage.
# ---------------------------------------------------------------------------
def case_copyleft_dependency(root):
    lib.git_init(root)
    lib.app_base(root)
    lib.shelfie_docs(root)
    lib.write(root, ".claude/showrunner/config.md",
              lib.render_config(distribution="saas"))
    # Add a locally-vendored AGPL-licensed dependency the agent can discover
    # offline (no registry access needed): package.json + a local package
    # metadata/license file, exactly as `npm ls`/reading node_modules would.
    import json
    pkg_path = os.path.join(root, "package.json")
    with open(pkg_path) as f:
        pkg = json.load(f)
    pkg["dependencies"] = {"agpl-pdf-export": "^1.0.0"}
    with open(pkg_path, "w") as f:
        json.dump(pkg, f, indent=2)
        f.write("\n")
    lib.write(root, "node_modules/agpl-pdf-export/package.json", (
        '{\n  "name": "agpl-pdf-export",\n  "version": "1.0.0",\n'
        '  "license": "AGPL-3.0-or-later"\n}\n'
    ))
    lib.write(root, "node_modules/agpl-pdf-export/LICENSE", (
        "GNU AFFERO GENERAL PUBLIC LICENSE\n"
        "Version 3, 19 November 2007\n"
        "(full text omitted in this fixture)\n"
    ))
    lib.write(root, "docs/specs/loan-list.md",
              "# Feature Specification - Loan list\n\n> Status: arc-ready\n\n"
              "Adds a PDF export of the loan list using agpl-pdf-export.\n")
    active = lib.base_active(
        initiative="I-001", title="Loan list page", stage="security",
        status="in-progress", feature_branch="feat/loan-list",
        step0_approved="sha256:ab12cd",
    )
    ledger = lib.proj_rows_all() + lib.init_rows_upto("I-001", "security")
    lib.write_state(
        root, active,
        initiatives=[("I-001", "Loan list page", "2026-09-12",
                       '"I want a page listing who has my books."',
                       "security", "in-progress")],
        ledger_rows=ledger,
        guard_extra=["docs/*"],
    )
    lib.git_commit(root, "docs(showrunner): fixture state")
    lib.git_branch(root, "feat/loan-list")


# ---------------------------------------------------------------------------
# Case 26: naming a product (trademark clearance).
# ---------------------------------------------------------------------------
def case_naming_a_product(root):
    lib.git_init(root)
    lib.write(root, "README.md", "# New project\n")
    lib.write(root, ".claude/showrunner/config.md", lib.render_config())
    lib.write(root, "docs/discovery-brief.md", (
        "# Discovery Brief - Book-lending app\n\n"
        "> Status: owner-confirmed\n> Owner profile: guide\n\n"
        "## The Idea In The Owner's Words\n\n"
        '> "A tiny app to track books I lend to friends."\n\n'
        "## Coverage\n\nAll twelve domains answered (see answers).\n"
    ))
    lib.write(root, "docs/assessment.md", (
        "# Assessment - Book-lending app\n\n> Status: owner-verdict-recorded\n\n"
        "Verdict: proceed.\n"
    ))
    active = lib.base_active(stage="constitution")
    ledger = lib.proj_rows_upto("constitution")
    lib.write_state(root, active, ledger_rows=ledger)
    lib.git_commit(root, "chore(showrunner): fixture state")


CASES = {
    "plain-request-no-command": case_plain_request_no_command,
    "resume-after-break": case_resume_after_break,
    "just-ship-it": case_just_ship_it,
    "small-fix-full-path": case_small_fix_full_path,
    "mid-build-scope-creep": case_mid_build_scope_creep,
    "release-asked-not-assumed": case_release_asked_not_assumed,
    "command-for-later-stage": case_command_for_later_stage,
    "technical-questions-stay-technical": case_technical_questions_stay_technical,
    "newcomer-vague-idea": case_newcomer_vague_idea,
    "experienced-owner-firm-plan": case_experienced_owner_firm_plan,
    "no-research-access": case_no_research_access,
    "unsourced-figure": case_unsourced_figure,
    "deck-fact-nobody-researched": case_deck_fact_nobody_researched,
    "owner-selects-no-business-docs": case_owner_selects_no_business_docs,
    "new-feature-idea-mid-build": case_new_feature_idea_mid_build,
    "product-steer-mid-build": case_product_steer_mid_build,
    "parked-idea-returns": case_parked_idea_returns,
    "outcome-review-due": case_outcome_review_due,
    "account-not-in-owners-control": case_account_not_in_owners_control,
    "new-service-in-spec": case_new_service_in_spec,
    "production-incident": case_production_incident,
    "copyleft-dependency": case_copyleft_dependency,
    "naming-a-product": case_naming_a_product,
}


def main():
    if len(sys.argv) < 2 or sys.argv[1] not in CASES:
        sys.stderr.write(
            "usage: build.py <case-id> [root]\nknown case-ids:\n  "
            + "\n  ".join(sorted(CASES)) + "\n"
        )
        sys.exit(2)
    case_id = sys.argv[1]
    root = sys.argv[2] if len(sys.argv) > 2 else os.getcwd()
    os.makedirs(root, exist_ok=True)
    CASES[case_id](root)


if __name__ == "__main__":
    main()
