# Cmdlets, verbs, and discovery

**TL;DR:** PowerShell commands are **cmdlets** named `Verb-Noun` (`Get-Process`, `Set-Item`, `Remove-Variable`). The verb comes from an approved list, so once you know the pattern you can guess command names. Three discovery cmdlets get you anywhere without memorizing: `Get-Command` (what exists), `Get-Help` (how to use it), `Get-Member` (what an object has).

## The `Verb-Noun` convention

Every well-formed cmdlet is an approved verb plus a singular noun:

- `Get-` retrieve, `Set-` modify, `New-` create, `Remove-` delete, `Add-`, `Start-`/`Stop-`, `Import-`/`Export-`, `ConvertTo-`/`ConvertFrom-`, `Test-` (check, returns boolean), `Invoke-` (run).

```powershell
Get-Verb            # the full approved-verb list (use these when authoring functions)
```

Using approved verbs in your own functions makes them discoverable and avoids the warning PowerShell emits on import for unapproved verbs.

## The three discovery cmdlets

```powershell
Get-Command *service*          # find commands by name pattern
Get-Command -Noun Process      # all cmdlets acting on "Process"
Get-Help Get-ChildItem -Full   # parameters, description, examples
Get-Help Get-ChildItem -Examples
Get-Process | Get-Member       # the properties/methods of what a command returns
```

This trio is the whole game: **Get-Command** to find it, **Get-Help** to learn its parameters, **Get-Member** to see the objects it emits ([objects-and-pipeline.md](objects-and-pipeline.md)). Run `Update-Help` once to get full local help.

## `about_` topics

Conceptual docs (not about a single cmdlet) live in `about_*` help topics:

```powershell
Get-Help about_*               # list conceptual topics
Get-Help about_Splatting       # read one
```

These cover the language itself (operators, pipelines, scopes, splatting) and are the built-in reference for everything in this domain.

## Parameters

```powershell
Get-ChildItem -Path C:\ -Recurse -Filter *.log    # named parameters
Get-ChildItem C:\ *.log                            # positional (Path, Filter)
```

- **Named** parameters (`-Path`) are clearer; positional works for the common ones.
- **Switch** parameters are boolean flags (`-Recurse`, `-Force`) — present = true.
- **Tab completion** completes cmdlet names, parameters, and often values — lean on it instead of memorizing.

### Splatting (pass parameters as a hashtable)

When a call has many parameters, build them as a hashtable and splat with `@`:

```powershell
$params = @{ Path = 'C:\logs'; Filter = '*.log'; Recurse = $true }
Get-ChildItem @params
```

Splatting keeps long invocations readable and lets you build parameters conditionally.

## Aliases

Many cmdlets have short aliases: `gci`/`ls`/`dir` → `Get-ChildItem`, `?` → `Where-Object`, `%` → `ForEach-Object`, `select` → `Select-Object`.

```powershell
Get-Alias ls          # what does this alias resolve to?
Get-Alias -Definition Get-ChildItem
```

Use aliases interactively; **write full cmdlet names in scripts** for readability and to avoid alias differences across machines.

## How I use it

- `Get-Command`/`Get-Help -Examples`/`Get-Member` to work out any unfamiliar command instead of guessing.
- Approved `Verb-Noun` (`Get-Verb`) when naming my own functions.
- Splatting for any call with more than ~3 parameters; full cmdlet names (not aliases) in committed scripts.

## Links

- [Approved Verbs for PowerShell](https://learn.microsoft.com/en-us/powershell/scripting/developer/cmdlet/approved-verbs-for-windows-powershell-commands)
- [about_Splatting](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_splatting)
