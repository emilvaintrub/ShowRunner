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

    [switch]$Force
)

$ErrorActionPreference = "Stop"

$project = (Resolve-Path -LiteralPath $ProjectRoot).Path
$source = Join-Path $PSScriptRoot "hooks\commit-msg"
$prefixesSource = Join-Path $PSScriptRoot "hooks\showrunner-commit-prefixes"

if ([System.IO.Path]::IsPathRooted($HooksPath) -or $HooksPath -match "(^|[\\/])\.\.([\\/]|$)") {
    throw "HooksPath must stay within the project: $HooksPath"
}

$targetDirectory = Join-Path $project $HooksPath
$target = Join-Path $targetDirectory "commit-msg"
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

if ((Test-Path -LiteralPath $target) -and -not $Force) {
    $sourceHash = (Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash
    $targetHash = (Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash
    if ($sourceHash -ne $targetHash) {
        throw "Refusing to overwrite an existing commit-msg hook. Re-run with -Force after review."
    }
}

Copy-Item -LiteralPath $source -Destination $target -Force

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
    & chmod +x $target
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to mark the commit-msg hook executable."
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
Write-Output "Installed commit prefix allowlist at $prefixesTarget"
