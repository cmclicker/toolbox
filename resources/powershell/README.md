# PowerShell — resources

> Curated external material for PowerShell. My own explainers are in [../../references/powershell/](../../references/powershell/); reusable templates in [../../snippets/powershell/](../../snippets/powershell/).

## Official docs & specs

- **[PowerShell documentation (MS Learn)](https://learn.microsoft.com/en-us/powershell/)** — the authoritative hub: language, cmdlets, modules, versions.
- **[`about_` conceptual topics](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/)** — the built-in reference for the language itself (operators, pipelines, scopes, splatting). Also available offline via `Get-Help about_*`.
- **[Cmdlet reference](https://learn.microsoft.com/en-us/powershell/module/)** — every built-in cmdlet, by module.

## Learn

- **[PowerShell 101 (MS Learn)](https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/00-introduction)** — a solid, modern from-zero tutorial.
- **[What's new / migrating 5.1 → 7](https://learn.microsoft.com/en-us/powershell/scripting/whats-new/migrating-from-windows-powershell-51-to-powershell-7)** — the differences that matter when targeting both.

## Cheatsheets & quick-reference

- **[ss64 — PowerShell](https://ss64.com/ps/)** — fast, example-rich per-command reference (and a CMD reference alongside).
- **[devhints — PowerShell](https://devhints.io/powershell)** — one-page syntax reminder.

## Tools & utilities

- **[PSScriptAnalyzer](https://learn.microsoft.com/en-us/powershell/utility-modules/psscriptanalyzer/overview)** — the linter (ShellCheck equivalent). `Install-Module PSScriptAnalyzer`; settings template in [../../configs/powershell/PSScriptAnalyzerSettings.psd1](../../configs/powershell/PSScriptAnalyzerSettings.psd1).
- **[PowerShell Gallery](https://www.powershellgallery.com/)** — the module/script repository (`Find-Module`, `Install-Module`).
- **[PowerShell (GitHub)](https://github.com/PowerShell/PowerShell)** — the open-source 7+ project; install via `winget install Microsoft.PowerShell`.
- **[PSReadLine](https://learn.microsoft.com/en-us/powershell/module/psreadline/about/about_psreadline)** — the interactive line editor (history search, prediction) configured in [../../configs/powershell/profile.ps1](../../configs/powershell/profile.ps1).

---

_Last checked: 2026-05. External links rot — see [maintenance notes](../README.md#maintenance)._
