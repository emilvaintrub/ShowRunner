[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string[]]$Target = @("all"),

    [string]$ProjectRoot = (Get-Location).Path,

    [switch]$Force
)

$ErrorActionPreference = "Stop"
$repoRoot = $PSScriptRoot
$skillSource = Join-Path $repoRoot "showrunner"

if (-not (Test-Path -LiteralPath (Join-Path $skillSource "SKILL.md"))) {
    throw "Cannot find showrunner/SKILL.md. Run this script from the ShowRunner repository root."
}

function Expand-Targets {
    param([string[]]$Items)

    $allowed = @("all", "codex", "claude", "cursor", "vscode")
    $expanded = @(
        foreach ($item in $Items) {
            foreach ($part in "$item".Split(",", [System.StringSplitOptions]::RemoveEmptyEntries)) {
                $part.Trim().ToLowerInvariant()
            }
        }
    )

    foreach ($item in $expanded) {
        if ($item -notin $allowed) {
            throw "Unknown target '$item'. Use one or more of: $($allowed -join ', ')."
        }
    }

    if ($expanded -contains "all") {
        return @("codex", "claude", "cursor", "vscode")
    }
    return @($expanded | Select-Object -Unique)
}

function Copy-Skill {
    param(
        [Parameter(Mandatory)][string]$Destination,
        [Parameter(Mandatory)][string]$Name
    )

    if (Test-Path -LiteralPath $Destination) {
        if (-not $Force) {
            throw "$Name skill already exists at $Destination. Re-run with -Force to replace it."
        }
        if ($PSCmdlet.ShouldProcess($Destination, "replace existing $Name skill")) {
            Remove-Item -LiteralPath $Destination -Recurse -Force
        }
    }

    $parent = Split-Path -Parent $Destination
    if ($PSCmdlet.ShouldProcess($parent, "create skill directory")) {
        New-Item -ItemType Directory -Force -Path $parent | Out-Null
    }
    if ($PSCmdlet.ShouldProcess($Destination, "install $Name skill")) {
        Copy-Item -LiteralPath $skillSource -Destination $Destination -Recurse
    }
}

function Write-InstructionFile {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$Content,
        [Parameter(Mandatory)][string]$Name
    )

    if ((Test-Path -LiteralPath $Path -PathType Leaf) -and -not $Force) {
        throw "$Name instructions already exist at $Path. Re-run with -Force to replace them."
    }

    $parent = Split-Path -Parent $Path
    if ($PSCmdlet.ShouldProcess($parent, "create instruction directory")) {
        New-Item -ItemType Directory -Force -Path $parent | Out-Null
    }
    if ($PSCmdlet.ShouldProcess($Path, "write $Name instructions")) {
        Set-Content -LiteralPath $Path -Value $Content -Encoding UTF8
    }
}

$targets = Expand-Targets -Items $Target
$userProfile = [Environment]::GetFolderPath("UserProfile")

$cursorRule = @'
---
description: ShowRunner conductor - run every lifecycle stage from idea to release; the user is the business owner.
globs:
  - "**/*"
alwaysApply: true
---

# ShowRunner

ShowRunner is the conductor for this repository. The user is the business owner: they supply the idea and every business decision. You run the whole process and never wait to be told the next step.

Every session and every message:
1. Read `.claude/showrunner/config.md` and `.claude/showrunner/state.md`. No config means start the setup stage.
2. Follow the installed ShowRunner skill's `core/lifecycle.md`. Every initiative runs every stage in order: intake, roadmap, spec, design, design-review, handoff, arc-plan, step0, build, verify, security, acceptance, merge, release, close.
3. Classify the owner's message before acting. A request to change code opens or continues an initiative; it is never executed outside the build stage.
4. When a stage's exit record is met, append the ledger row and start the next stage in the same turn. Stop only for owner gates.
5. End every turn with the ShowRunner handoff block: stage, what was done, what is allowed, what you need from the owner, what runs next.

Hard rules:
- Only a ledger row completes a stage; owner approvals are quoted verbatim.
- Never skip a stage. Only the owner can waive one, in their own words; setup, step0, verify, merge approval, and the release question can never be waived.
- Ask the owner only business questions; answer technical ones from the repository.
- Product code changes only in the build stage, after ShowRunner approves Step 0, on the feature branch.
- Stop before merging to the primary branch until the owner approves.
- Never release or deploy without the owner's explicit release instructions.
- Keep project facts in `.claude/showrunner/config.md`.
'@

$vscodeInstructions = @'
# ShowRunner

ShowRunner is the conductor for this repository. The user is the business owner: they supply the idea and every business decision. You run the whole process and never wait to be told the next step.

Every session and every message:
1. Read `.claude/showrunner/config.md` and `.claude/showrunner/state.md`. No config means start the setup stage.
2. Follow the installed ShowRunner skill's `core/lifecycle.md`. Every initiative runs every stage in order: intake, roadmap, spec, design, design-review, handoff, arc-plan, step0, build, verify, security, acceptance, merge, release, close.
3. Classify the owner's message before acting. A request to change code opens or continues an initiative; it is never executed outside the build stage.
4. When a stage's exit record is met, append the ledger row and start the next stage in the same turn. Stop only for owner gates.
5. End every turn with the ShowRunner handoff block: stage, what was done, what is allowed, what you need from the owner, what runs next.

Hard rules:
- Only a ledger row completes a stage; owner approvals are quoted verbatim.
- Never skip a stage. Only the owner can waive one, in their own words; setup, step0, verify, merge approval, and the release question can never be waived.
- Ask the owner only business questions; answer technical ones from the repository.
- Product code changes only in the build stage, after ShowRunner approves Step 0, on the feature branch.
- Stop before merging to the primary branch until the owner approves.
- Never release or deploy without the owner's explicit release instructions.
- Keep project facts in `.claude/showrunner/config.md`.
'@

foreach ($targetName in $targets) {
    switch ($targetName) {
        "codex" {
            Copy-Skill -Name "Codex" -Destination (Join-Path $userProfile ".codex\skills\showrunner")
        }
        "claude" {
            Copy-Skill -Name "Claude Code" -Destination (Join-Path $userProfile ".claude\skills\showrunner")
        }
        "cursor" {
            $cursorParams = @{
                Name = "Cursor"
                Path = (Join-Path $ProjectRoot ".cursor\rules\showrunner.mdc")
                Content = $cursorRule
            }
            Write-InstructionFile @cursorParams
        }
        "vscode" {
            $vscodeParams = @{
                Name = "VS Code Copilot"
                Path = (Join-Path $ProjectRoot ".github\copilot-instructions.md")
                Content = $vscodeInstructions
            }
            Write-InstructionFile @vscodeParams
        }
    }
}

Write-Output "ShowRunner install completed for: $($targets -join ', ')"
