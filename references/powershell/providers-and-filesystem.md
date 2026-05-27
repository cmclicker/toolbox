# Providers, PSDrives, and the filesystem

**TL;DR:** PowerShell **providers** expose different data stores through one consistent set of item cmdlets (`Get-ChildItem`, `Get-Item`, `Set-Item`, `Remove-Item`, `Test-Path`). So you navigate the registry, environment variables, and certificates with the *same commands* you use for files — just on different drives (`C:`, `HKLM:`, `Env:`, `Cert:`).

## One command set, many stores

```powershell
Get-PSProvider              # the available providers
Get-PSDrive                 # the drives they expose
```

The item cmdlets work across all of them:

| Store | Provider | Drive | Example |
|---|---|---|---|
| Files | FileSystem | `C:`, `D:` | `Get-ChildItem C:\logs` |
| Registry | Registry | `HKLM:`, `HKCU:` | `Get-ItemProperty HKLM:\SOFTWARE\...` |
| Env vars | Environment | `Env:` | `$env:PATH`, `Get-ChildItem Env:` |
| Variables | Variable | `Variable:` | `Get-ChildItem Variable:` |
| Certificates | Certificate | `Cert:` | `Get-ChildItem Cert:\CurrentUser\My` |

Registry access uses the `HKLM:`/`HKCU:` PSDrives — **not** raw `HKEY_LOCAL_MACHINE\...` paths.

## Environment variables

```powershell
$env:PATH                              # read
$env:MYVAR = 'value'                   # set for THIS process only
[Environment]::GetEnvironmentVariable('PATH','Machine')   # read a persisted scope
[Environment]::SetEnvironmentVariable('MYVAR','value','User')  # persist (User/Machine)
```

`$env:X = ...` sets the variable only for the current process (and its children). To persist across sessions, use `[Environment]::SetEnvironmentVariable(...,'User'|'Machine')` — the Machine scope needs admin. (Bash-style `export` doesn't exist; there's no inline `VAR=val cmd` prefix either.)

## Common filesystem operations

```powershell
Get-ChildItem -Recurse -Filter *.log           # list (alias gci/ls/dir)
Get-ChildItem -Recurse -File | Where-Object Length -gt 1MB
Test-Path .\build                              # exists?
New-Item -ItemType Directory -Force .\out      # mkdir -p equivalent
Copy-Item src dst -Recurse
Remove-Item .\tmp -Recurse -Force              # add -Confirm:$false in scripts to avoid prompts
Get-Content file.txt -TotalCount 20            # head; -Tail 20 for tail; -Wait to follow
```

Notes that trip people up:

- **`New-Item -Force` on a *file* truncates it** if it exists — fine for directories, destructive for files. To "touch" without clobbering, guard with `Test-Path`.
- Destructive cmdlets may **prompt**; in non-interactive scripts add `-Confirm:$false` (and `-Force` for read-only/hidden items) so they don't hang.
- `Get-ChildItem` returns objects ([objects-and-pipeline.md](objects-and-pipeline.md)) — filter on `.Length`, `.LastWriteTime`, `.Extension`, not parsed text.

## Path helpers

```powershell
Join-Path $base 'sub\file.txt'     # build paths portably
Split-Path $p -Parent / -Leaf      # dirname / basename
Resolve-Path .\rel                  # to absolute
$PSScriptRoot                       # the running script's own folder
```

Use `Join-Path` / `Split-Path` rather than string-concatenating paths, and `$PSScriptRoot` to reference files relative to a script regardless of the caller's working directory.

## How I use it

- The same item cmdlets for files, registry (`HKLM:`/`HKCU:`), and `Env:` — no special registry tooling needed.
- `$env:X` for process-scoped vars; `[Environment]::SetEnvironmentVariable(...,'User')` to persist.
- `Join-Path`/`Split-Path`/`$PSScriptRoot` for paths; `-Confirm:$false`/`-Force` in scripts to avoid interactive prompts; never `New-Item -Force` on a file I want to keep.

## Links

- [about_Providers](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_providers)
- [about_Environment_Variables](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_environment_variables)
