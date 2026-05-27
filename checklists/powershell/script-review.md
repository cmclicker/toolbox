# Checklist: before shipping a PowerShell script

> Walk this before committing or relying on a non-trivial PowerShell script. Each item is yes/no. Background in [../../references/powershell/](../../references/powershell/).

## Blocking

- [ ] [PSScriptAnalyzer](../../resources/powershell/README.md) run and clean (or remaining findings justified). Settings: [../../configs/powershell/PSScriptAnalyzerSettings.psd1](../../configs/powershell/PSScriptAnalyzerSettings.psd1).
- [ ] `Set-StrictMode -Version Latest` and `$ErrorActionPreference = 'Stop'` set ([../../snippets/powershell/strict-mode.ps1](../../snippets/powershell/strict-mode.ps1)).
- [ ] Null comparisons written `$null -eq $x` (null on the left), not the reverse.
- [ ] Every **native** command's failure checked via `$LASTEXITCODE` (not `$?` alone); risky cmdlet calls wrapped in `try/catch` with `-ErrorAction Stop`.
- [ ] Target version declared (`#requires -Version 7.0`) — or, if it must run on 5.1, no `&&`/`||`/ternary/`??`/`?.` and no 7-only cmdlet parameters.
- [ ] File writes specify `-Encoding utf8` (don't rely on 5.1's UTF-16 default).

## Robustness & safety

- [ ] State-changing functions support `-WhatIf`/`-Confirm` (`[CmdletBinding(SupportsShouldProcess)]`) where destructive.
- [ ] Non-interactive paths avoid prompts: destructive cmdlets pass `-Confirm:$false` (and `-Force` where needed); no `Read-Host`/`Get-Credential`/`Out-GridView` in automation.
- [ ] No `New-Item -Force` on a file you mean to keep (it truncates).
- [ ] Parameters validated with attributes (`[ValidateNotNullOrEmpty()]`, `[ValidateSet]`, `[ValidateRange]`) rather than manual checks ([../../snippets/powershell/advanced-function-template.ps1](../../snippets/powershell/advanced-function-template.ps1)).
- [ ] No secrets hard-coded or echoed; use `Get-Secret`/secure storage where applicable.

## Style

- [ ] Full cmdlet names in the script (no aliases like `gci`/`%`/`?`).
- [ ] Approved `Verb-Noun` names for functions (`Get-Verb`).
- [ ] Pipeline output is data objects; `Format-*` only at the very end (display), never mid-pipeline.

## Advisory

- [ ] Comment-based help (`<# .SYNOPSIS ... #>`) for anything reused.
- [ ] `-Verbose`/`Write-Verbose` for diagnostics instead of `Write-Host`.
- [ ] Tested under the actual target host (`powershell.exe` vs `pwsh`) — see [../../playbooks/powershell/debug-a-script.md](../../playbooks/powershell/debug-a-script.md).
