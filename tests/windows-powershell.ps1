# Regression test for showrunner/scripts/install-hooks.ps1 -ClaudeSettings,
# targeting Windows PowerShell 5.1 (the shell GitHub's windows-latest runners
# use by default). Written for 5.1 compatibility: no -AsHashtable, no ?:/??
# operators, no && / || statement chaining.
#
# Run it directly on Windows with:
#   powershell -NoProfile -ExecutionPolicy Bypass -File tests/windows-powershell.ps1
#
# It is also PowerShell 7 (pwsh) compatible, so it can be exercised on Linux
# during development, e.g.:
#   pwsh -NoProfile -File tests/windows-powershell.ps1

[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

Write-Output "PSVersion: $($PSVersionTable.PSVersion)"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$installScript = Join-Path $repoRoot "showrunner/scripts/install-hooks.ps1"

if (-not (Test-Path -LiteralPath $installScript)) {
    throw "install-hooks.ps1 not found at $installScript"
}

$sysTemp = [System.IO.Path]::GetTempPath()
$projName = "showrunner-ps5-test-" + [System.Guid]::NewGuid().ToString("N")
$projectRoot = Join-Path $sysTemp $projName

function Remove-TestRepo {
    if (Test-Path -LiteralPath $projectRoot) {
        Remove-Item -LiteralPath $projectRoot -Recurse -Force -ErrorAction SilentlyContinue
    }
}

try {
    New-Item -ItemType Directory -Force -Path $projectRoot | Out-Null

    Push-Location $projectRoot
    try {
        & git init -q -b main
        if ($LASTEXITCODE -ne 0) { throw "git init failed" }
        & git config user.email "test@example.com"
        & git config user.name "Test"
        & git commit -q --allow-empty -m "chore: init"
        if ($LASTEXITCODE -ne 0) { throw "git commit --allow-empty failed" }
    }
    finally {
        Pop-Location
    }

    # Pre-existing .claude/settings.json with an unrelated top-level key and
    # one unrelated PreToolUse hook block, to prove the merge preserves both.
    $claudeDir = Join-Path $projectRoot ".claude"
    New-Item -ItemType Directory -Force -Path $claudeDir | Out-Null
    $settingsPath = Join-Path $claudeDir "settings.json"

    $initialSettings = @'
{
  "otherSetting": true,
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Read",
        "hooks": [
          { "type": "command", "command": "echo unrelated-pretooluse" }
        ]
      }
    ]
  }
}
'@
    [System.IO.File]::WriteAllText($settingsPath, $initialSettings, [System.Text.UTF8Encoding]::new($false))

    # Run once, then again with -Force, exactly as a real install + re-install would.
    & $installScript -ProjectRoot $projectRoot -ClaudeSettings | Out-Null
    & $installScript -ProjectRoot $projectRoot -Force -ClaudeSettings | Out-Null

    if (-not (Test-Path -LiteralPath $settingsPath)) {
        throw "settings.json is missing after install-hooks.ps1 -ClaudeSettings"
    }
    $rawText = Get-Content -LiteralPath $settingsPath -Raw

    # (b) raw-text check: no PS5.1 ETS array-serialization wrapper leaked
    # into the file ({"value":[...],"Count":n} instead of a plain array).
    if ($rawText -match '"value"\s*:') {
        throw "settings.json raw text contains a `"value`": wrapper - PS5.1 array-serialization bug not defeated"
    }
    if ($rawText -match '"Count"\s*:') {
        throw "settings.json raw text contains a `"Count`": wrapper - PS5.1 array-serialization bug not defeated"
    }

    $parsed = $rawText | ConvertFrom-Json

    # (a) unrelated key and hook survive.
    if ($parsed.otherSetting -ne $true) {
        throw "unrelated top-level key 'otherSetting' did not survive the merge"
    }

    $unrelatedSurvived = $false
    foreach ($block in @($parsed.hooks.PreToolUse)) {
        foreach ($entry in @($block.hooks)) {
            if ($entry.command -eq "echo unrelated-pretooluse") {
                $unrelatedSurvived = $true
            }
        }
    }
    if (-not $unrelatedSurvived) {
        throw "unrelated PreToolUse hook block did not survive the merge"
    }

    # (b) + (c): each event is a JSON array after parsing, with exactly one
    # ShowRunner block (command contains "/showrunner ") per event.
    foreach ($eventName in @("SessionStart", "UserPromptSubmit", "PreToolUse")) {
        if (-not $parsed.hooks.PSObject.Properties.Match($eventName).Count) {
            throw "hooks.$eventName is missing after install"
        }
        $value = $parsed.hooks.$eventName
        if (-not ($value -is [System.Array])) {
            throw "hooks.$eventName is not a JSON array after parsing (got type $($value.GetType().Name))"
        }

        $showrunnerCount = 0
        foreach ($block in @($value)) {
            $isShowRunnerBlock = $false
            foreach ($entry in @($block.hooks)) {
                if ($entry.command -and ($entry.command -match "/showrunner ")) {
                    $isShowRunnerBlock = $true
                }
            }
            if ($isShowRunnerBlock) {
                $showrunnerCount = $showrunnerCount + 1
            }
        }
        if ($showrunnerCount -ne 1) {
            throw "hooks.$eventName has $showrunnerCount ShowRunner block(s), expected exactly 1"
        }
    }

    # (d) the five hook files exist in .githooks.
    $hooksDir = Join-Path $projectRoot ".githooks"
    foreach ($file in @("commit-msg", "pre-commit", "showrunner", "showrunner-sources", "showrunner-commit-prefixes")) {
        $filePath = Join-Path $hooksDir $file
        if (-not (Test-Path -LiteralPath $filePath)) {
            throw "expected hook file missing: $filePath"
        }
    }

    # (e) core.hooksPath is configured.
    $configured = (& git -C $projectRoot config --get core.hooksPath).Trim()
    if ($configured -ne ".githooks") {
        throw "core.hooksPath is '$configured', expected '.githooks'"
    }

    Write-Output "All assertions passed."
}
finally {
    Remove-TestRepo
}
