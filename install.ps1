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
description: Use ShowRunner for gated product, implementation, security, and architecture workflow.
globs:
  - "**/*"
alwaysApply: false
---

# ShowRunner

Use the installed ShowRunner skill when work needs product direction, implementation planning, security review, or architecture synthesis.

Command families:
- `/forge init|discover|plan|spec|decide|design`
- `/arc init|plan|run|verify|merge`
- `/sentry init|sweep|fix|verify|accept|deps|pen-test|monthly|refresh-knowledge|merge`
- `/bible init|sync|merge`

Respect the workflow boundaries: Forge decides direction with the user, Arc implements only approved scope, Sentry handles risk, and Bible synthesizes what is already evidenced.
'@

$vscodeInstructions = @'
# ShowRunner

Use ShowRunner for repository work that needs explicit product decisions, implementation arcs, security review, or architecture synthesis.

Start with `/forge init`, `/arc init`, `/sentry init`, or `/bible init` depending on the task. Stop before implementation until Step 0 describe-back is approved. Stop before merge until independent verification and required smoke are complete.

Keep project-specific facts in `.claude/showrunner/config.md`; keep the reusable workflow package project-neutral.
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
