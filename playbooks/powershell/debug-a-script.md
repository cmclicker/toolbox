# Playbook: debug a PowerShell script

> **Trigger:** a script errors, produces wrong output, or "won't run" at all. Est. time: 5–30 min. Concepts: [../../references/powershell/error-handling.md](../../references/powershell/error-handling.md), [../../references/powershell/execution-policy-and-profiles.md](../../references/powershell/execution-policy-and-profiles.md).

## Step 0 — "Won't run at all" is usually not a bug

Before debugging logic, rule out the environment:

- **"cannot be loaded because running scripts is disabled"** → execution policy. `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`.
- **"...because it is not digitally signed" on a downloaded file** → Mark-of-the-Web. `Unblock-File .\script.ps1`.
- **Syntax error mentioning `&&`, `?:`, or `??`** → you're on Windows PowerShell 5.1 running 7-only syntax. Use `pwsh`, or rewrite to the 5.1 subset ([../../references/powershell/powershell-5-vs-7.md](../../references/powershell/powershell-5-vs-7.md)).
- Confirm the host: `$PSVersionTable.PSVersion`.

## Step 1 — Lint first

```powershell
Invoke-ScriptAnalyzer -Path .\script.ps1 -Settings .\PSScriptAnalyzerSettings.psd1
```

PSScriptAnalyzer catches the `$x -eq $null` trap, aliases, unapproved verbs, and many real bugs statically ([../../configs/powershell/PSScriptAnalyzerSettings.psd1](../../configs/powershell/PSScriptAnalyzerSettings.psd1)).

## Step 2 — Make errors surface

Add strict mode so failures stop at their source instead of cascading:

```powershell
Set-StrictMode -Version Latest      # unset vars / bad property refs become errors
$ErrorActionPreference = 'Stop'     # non-terminating errors become catchable/fatal
```

Remember: a `try/catch` that "doesn't catch" usually means the error was **non-terminating** — add `-ErrorAction Stop` to that call ([../../references/powershell/error-handling.md](../../references/powershell/error-handling.md)).

## Step 3 — Inspect the error

```powershell
$Error[0] | Format-List * -Force      # the most recent error, in full
$Error[0].ScriptStackTrace            # where it came from
$Error[0].Exception.GetType().FullName # the exception type (to catch specifically)
```

## Step 4 — Trace and step

```powershell
.\script.ps1 -Verbose                 # see Write-Verbose diagnostics (add them as needed)
Set-PSDebug -Trace 1                   # echo each line as it runs (1=lines, 2=+vars); Set-PSDebug -Off to stop
```

For interactive stepping, set a breakpoint and run:

```powershell
Set-PSBreakpoint -Script .\script.ps1 -Line 42
Set-PSBreakpoint -Script .\script.ps1 -Variable result -Mode Write   # break when $result is written
```

At a breakpoint you're at a normal prompt — inspect variables, then `c` (continue), `s` (step), `q` (quit). VS Code's PowerShell extension gives the same breakpoints with a GUI.

## Step 5 — Inspect values precisely

```powershell
$x | Get-Member                       # what type/properties is $x really?
$x | Format-List * -Force             # all property values
$x.GetType().FullName                  # exact type (string vs array vs $null?)
```

Most logic bugs are a value not being the type you assumed — a single object where you expected an array, `$null` where you expected data, or a string where you expected a number.

## Common root causes

| Symptom | Usual cause |
|---|---|
| `try/catch` never fires | error was non-terminating; add `-ErrorAction Stop` |
| Native command "succeeded" but didn't | checked `$?` not `$LASTEXITCODE` |
| Comparison/`if` behaves oddly with a variable | `$x -eq $null` filtering an array; use `$null -eq $x` |
| Works in `pwsh`, fails in `powershell.exe` | 7-only syntax under 5.1 |
| Garbled output file / BOM | 5.1 UTF-16 default; write with `-Encoding utf8` |
| Script hangs in automation | a prompt (`Read-Host`, confirmation); add `-Confirm:$false` |

## How I use it

Environment check (`$PSVersionTable`, execution policy) → PSScriptAnalyzer → `Set-StrictMode`+`$ErrorActionPreference='Stop'` → `$Error[0] | Format-List *` → breakpoints / `Get-Member` on the suspect value.
