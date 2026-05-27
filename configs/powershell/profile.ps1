# Starter PowerShell profile. Copy to the path in `$PROFILE` (create it if missing:
#   if (!(Test-Path $PROFILE)) { New-Item $PROFILE -ItemType File -Force }).
# Note: Windows PowerShell 5.1 and PowerShell 7 use DIFFERENT profile paths.
# Reference: ../../references/powershell/execution-policy-and-profiles.md

# --- Sensible interactive defaults ------------------------------------------
$ErrorActionPreference = 'Continue'          # interactive: keep going (scripts set Stop themselves)
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'   # avoid 5.1's UTF-16 default

# PSReadLine: better history + inline prediction (7+/recent PSReadLine).
if (Get-Module -ListAvailable PSReadLine) {
    Set-PSReadLineOption -PredictionSource History -ErrorAction SilentlyContinue
    Set-PSReadLineOption -HistorySearchCursorMovesToEnd
    Set-PSReadLineKeyHandler -Key UpArrow   -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
}

# --- Aliases / functions ----------------------------------------------------
function which ($name) { (Get-Command $name -ErrorAction SilentlyContinue).Source }
function gs { git status -sb }
function gl { git log --oneline --graph --decorate -20 }
function .. { Set-Location .. }
function ... { Set-Location ../.. }

# --- Prompt: path (git branch) > -------------------------------------------
function prompt {
    $branch = (git branch --show-current 2>$null)
    $b = if ($branch) { " ($branch)" } else { '' }
    "PS $($executionContext.SessionState.Path.CurrentLocation)$b> "
}

# Machine-local overrides, not tracked:
$local = Join-Path (Split-Path $PROFILE) 'profile.local.ps1'
if (Test-Path $local) { . $local }
