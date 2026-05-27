# PowerShell — references

> My authored explainers for PowerShell. For curated external material (MS Learn, PSScriptAnalyzer, the Gallery), see [../../resources/powershell/](../../resources/powershell/). For reusable templates, see [../../snippets/powershell/](../../snippets/powershell/). Shell-agnostic Windows topics (Terminal, winget, WSL) will live in the `windows` domain.

## Start here

- [powershell-5-vs-7.md](powershell-5-vs-7.md) — the two PowerShells, and which syntax (`&&`, ternary, `??`) breaks under Windows PowerShell 5.1. Read first; it determines what you can write.
- [objects-and-pipeline.md](objects-and-pipeline.md) — the defining concept: the pipeline carries objects, not text. `Get-Member` is your map.
- [cmdlets-and-discovery.md](cmdlets-and-discovery.md) — `Verb-Noun`, and `Get-Command`/`Get-Help`/`Get-Member` to find anything.

## Language

- [variables-and-operators.md](variables-and-operators.md) — `$vars`, word operators (`-eq`/`-match`), the collection-filtering and `$null -eq $x` rules, arrays/hashtables.
- [strings-and-quoting.md](strings-and-quoting.md) — single vs. double quotes, `$()` interpolation, here-strings, `-f`, and the 5.1 UTF-16 file-encoding trap.
- [providers-and-filesystem.md](providers-and-filesystem.md) — providers/PSDrives (files, registry, `Env:`), filesystem ops, path helpers, prompt-avoidance in scripts.

## Robustness

- [error-handling.md](error-handling.md) — terminating vs. non-terminating errors, `-ErrorAction Stop`, `try/catch`, and `$LASTEXITCODE` for native executables.
- [execution-policy-and-profiles.md](execution-policy-and-profiles.md) — execution policy (a speed-bump, not security), Mark-of-the-Web, and `$PROFILE` startup scripts.

## See also

- [../../snippets/powershell/](../../snippets/powershell/) — strict-mode header, advanced-function template, argument completer.
- [../../resources/powershell/](../../resources/powershell/) · [../../configs/powershell/](../../configs/powershell/) · [../../checklists/powershell/](../../checklists/powershell/) · [../../playbooks/powershell/](../../playbooks/powershell/)
- [../bash/](../bash/) — the other shell; compare object pipeline vs. text pipeline.
