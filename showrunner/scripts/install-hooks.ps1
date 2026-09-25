[CmdletBinding()]
param(
    [string]$ProjectRoot = (Get-Location).Path,

    [string]$HooksPath = ".githooks",

    [string[]]$AllowedPrefixes = @(
        "feat",
        "fix",
        "docs",
        "chore",
        "refactor",
        "test",
        "ci",
        "build",
        "perf",
        "revert"
    ),

    [switch]$Force,

    [switch]$ClaudeSettings
)

$ErrorActionPreference = "Stop"

$project = (Resolve-Path -LiteralPath $ProjectRoot).Path
$source = Join-Path $PSScriptRoot "hooks\commit-msg"
$prefixesSource = Join-Path $PSScriptRoot "hooks\showrunner-commit-prefixes"
$preCommitSource = Join-Path $PSScriptRoot "hooks\pre-commit"
$showrunnerSource = Join-Path $PSScriptRoot "showrunner"
$showrunnerSourcesSource = Join-Path $PSScriptRoot "showrunner-sources"

if ([System.IO.Path]::IsPathRooted($HooksPath) -or $HooksPath -match "(^|[\\/])\.\.([\\/]|$)") {
    throw "HooksPath must stay within the project: $HooksPath"
}

$targetDirectory = Join-Path $project $HooksPath
$target = Join-Path $targetDirectory "commit-msg"
$preCommitTarget = Join-Path $targetDirectory "pre-commit"
$showrunnerTarget = Join-Path $targetDirectory "showrunner"
$showrunnerSourcesTarget = Join-Path $targetDirectory "showrunner-sources"
$prefixesTarget = Join-Path $targetDirectory "showrunner-commit-prefixes"
$legacyTypesTarget = Join-Path $targetDirectory "showrunner-commit-types"

if (-not (Test-Path -LiteralPath (Join-Path $project ".git"))) {
    throw "Not a Git repository root: $project"
}

foreach ($prefix in $AllowedPrefixes) {
    if ($prefix -notmatch "^[a-z][a-z0-9-]*(\([a-z0-9._/-]+\))?$") {
        throw "Invalid conventional commit prefix: $prefix"
    }
}

$docsAllowed = $AllowedPrefixes | Where-Object {
    $_ -eq "docs" -or $_ -eq "docs(backlog)"
}
if (-not $docsAllowed) {
    throw "AllowedPrefixes must admit docs(backlog) for the hygiene commit."
}

New-Item -ItemType Directory -Force -Path $targetDirectory | Out-Null

function Install-GuardedHook {
    param(
        [string]$SourcePath,
        [string]$TargetPath
    )

    if ((Test-Path -LiteralPath $TargetPath) -and -not $Force) {
        $sourceHash = (Get-FileHash -LiteralPath $SourcePath -Algorithm SHA256).Hash
        $targetHash = (Get-FileHash -LiteralPath $TargetPath -Algorithm SHA256).Hash
        if ($sourceHash -ne $targetHash) {
            $name = Split-Path -Leaf $TargetPath
            throw "Refusing to overwrite an existing $name hook. Re-run with -Force after review."
        }
    }

    Copy-Item -LiteralPath $SourcePath -Destination $TargetPath -Force
}

Install-GuardedHook -SourcePath $source -TargetPath $target
Install-GuardedHook -SourcePath $preCommitSource -TargetPath $preCommitTarget
Install-GuardedHook -SourcePath $showrunnerSource -TargetPath $showrunnerTarget
Install-GuardedHook -SourcePath $showrunnerSourcesSource -TargetPath $showrunnerSourcesTarget

if ($AllowedPrefixes.Count -eq 0) {
    Copy-Item -LiteralPath $prefixesSource -Destination $prefixesTarget -Force
}
else {
    $allowlistText = ($AllowedPrefixes -join "`n") + "`n"
    [System.IO.File]::WriteAllText(
        $prefixesTarget,
        $allowlistText,
        [System.Text.UTF8Encoding]::new($false)
    )
}

if (Test-Path -LiteralPath $legacyTypesTarget) {
    Remove-Item -LiteralPath $legacyTypesTarget -Force
}

if ([System.Environment]::OSVersion.Platform -ne [System.PlatformID]::Win32NT) {
    foreach ($executable in @($target, $preCommitTarget, $showrunnerTarget, $showrunnerSourcesTarget)) {
        & chmod +x $executable
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to mark $executable executable."
        }
    }
}

& git -C $project config core.hooksPath $HooksPath
if ($LASTEXITCODE -ne 0) {
    throw "Failed to configure core.hooksPath."
}

$configured = (& git -C $project config --get core.hooksPath).Trim()
if ($LASTEXITCODE -ne 0 -or $configured -ne $HooksPath) {
    throw "Hook verification failed. Expected $HooksPath, got '$configured'."
}

Write-Output "Installed commit-msg hook at $target"
Write-Output "Installed pre-commit hook at $preCommitTarget"
Write-Output "Installed showrunner script at $showrunnerTarget"
Write-Output "Installed showrunner-sources script at $showrunnerSourcesTarget"
Write-Output "Installed commit prefix allowlist at $prefixesTarget"

if ($ClaudeSettings) {
    # Windows PowerShell 5.1 can have ETS type data on System.Array (added by
    # a profile, module, or prior session) that makes ConvertTo-Json
    # serialize an array as {"value":[...],"Count":n} instead of a plain
    # JSON array. Strip it before touching hooks JSON; PowerShell 7 has no
    # such type data, so this is a no-op there.
    if (Get-TypeData -TypeName 'System.Array') {
        Remove-TypeData -TypeName 'System.Array'
    }

    $claudeTemplateSource = Join-Path $PSScriptRoot "claude-hooks.json"
    $settingsPath = Join-Path $project ".claude/settings.json"
    $settingsDirectory = Split-Path -Parent $settingsPath
    New-Item -ItemType Directory -Force -Path $settingsDirectory | Out-Null

    $renderedText = (Get-Content -LiteralPath $claudeTemplateSource -Raw) -replace [regex]::Escape("__HOOKS_PATH__"), $HooksPath
    $newHooksDoc = $renderedText | ConvertFrom-Json

    function Test-IsShowRunnerHookBlock {
        param($Block)

        if (-not $Block.hooks) {
            return $false
        }
        foreach ($entry in @($Block.hooks)) {
            if ($entry.command -and ($entry.command -match "/showrunner ")) {
                return $true
            }
        }
        return $false
    }

    if (-not (Test-Path -LiteralPath $settingsPath)) {
        [System.IO.File]::WriteAllText($settingsPath, $renderedText, [System.Text.UTF8Encoding]::new($false))
        Write-Output "Installed Claude Code hooks at $settingsPath"
    }
    else {
        $existing = Get-Content -LiteralPath $settingsPath -Raw | ConvertFrom-Json

        if (-not $existing.PSObject.Properties.Match('hooks').Count) {
            $existing | Add-Member -NotePropertyName hooks -NotePropertyValue ([pscustomobject]@{})
        }

        foreach ($eventProperty in $newHooksDoc.hooks.PSObject.Properties) {
            $eventName = $eventProperty.Name
            [object[]]$newBlocks = @($eventProperty.Value)

            [object[]]$existingBlocks = @()
            if ($existing.hooks.PSObject.Properties.Match($eventName).Count) {
                $existingBlocks = @($existing.hooks.$eventName)
            }

            [object[]]$kept = @($existingBlocks | Where-Object { -not (Test-IsShowRunnerHookBlock $_) })
            # Force-typed [object[]] so a single surviving/merged hook block
            # (Count -eq 1) still round-trips through ConvertTo-Json as a
            # one-element JSON array, not an unwrapped scalar object.
            [object[]]$merged = @($kept + $newBlocks)

            if ($existing.hooks.PSObject.Properties.Match($eventName).Count) {
                $existing.hooks.$eventName = $merged
            }
            else {
                $existing.hooks | Add-Member -NotePropertyName $eventName -NotePropertyValue $merged
            }
        }

        $mergedJson = ConvertTo-Json -InputObject $existing -Depth 20
        [System.IO.File]::WriteAllText($settingsPath, $mergedJson + "`n", [System.Text.UTF8Encoding]::new($false))
        Write-Output "Merged Claude Code hooks into $settingsPath"
    }
}
