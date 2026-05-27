# Error handling

**TL;DR:** PowerShell has two error kinds. **Terminating** errors stop execution and are catchable with `try/catch`. **Non-terminating** errors (the default for most cmdlet failures) write to the error stream and **keep going** — `try/catch` won't catch them unless you escalate with `-ErrorAction Stop` (or `$ErrorActionPreference='Stop'`). Native `.exe` failures don't throw at all: check `$LASTEXITCODE`, not `$?` alone.

## Two kinds of error

- **Terminating** — stops the pipeline/script; caught by `try/catch`. Raised by `throw`, by .NET exceptions, or by a cmdlet running under `-ErrorAction Stop`.
- **Non-terminating** — the cmdlet reports a problem (e.g. one file in a list wasn't found) but continues to the next item. Written to the error stream and to `$Error`. **Not** caught by `try/catch` by default.

This is the most common error-handling surprise: a `try/catch` that never fires because the cmdlet error was non-terminating.

## Make errors catchable

```powershell
try {
    Get-Content missing.txt -ErrorAction Stop    # escalate THIS call to terminating
}
catch {
    Write-Error "failed: $($_.Exception.Message)"   # $_ is the ErrorRecord
}
finally {
    # cleanup that always runs
}
```

- `-ErrorAction Stop` on a single call escalates just that call.
- `$ErrorActionPreference = 'Stop'` at script top makes non-terminating errors terminating **everywhere** — the usual choice for scripts that should fail fast.
- Inside `catch`, `$_` (the `ErrorRecord`) has `.Exception.Message`, `.ScriptStackTrace`, `.CategoryInfo`, etc.

## `$ErrorActionPreference` and `-ErrorAction`

| Value | Effect |
|---|---|
| `Continue` (default) | write the error, keep going |
| `Stop` | make it terminating (catchable / fails the script) |
| `SilentlyContinue` | suppress the error and keep going |
| `Ignore` | suppress and don't even record in `$Error` |

`-ErrorAction` on a cmdlet overrides the preference for that call. Use `SilentlyContinue` deliberately, not as a blanket "hide problems."

## Native executables are different

A native `.exe` (git, npm, robocopy) does **not** raise a PowerShell error on failure — it sets an exit code. `$?` reflects it loosely, but the reliable signal is `$LASTEXITCODE`:

```powershell
git push
if ($LASTEXITCODE -ne 0) { throw "git push failed ($LASTEXITCODE)" }
```

(Verified: after `cmd /c "exit 3"`, `$LASTEXITCODE` is `3` and `$?` is `False`.) Also, redirecting a native exe's stderr with `2>&1` in 5.1 wraps each stderr line in an error record and can flip `$?` to `False` even on a zero exit — so don't assume stderr output means failure for native tools; check `$LASTEXITCODE`.

## `throw` and `Write-Error`

```powershell
throw "explicit terminating error"          # terminating; sets up $_ in a caller's catch
Write-Error "non-terminating by default"    # writes to error stream, continues
```

For input validation, prefer parameter validation attributes (`[ValidateNotNullOrEmpty()]`, `[ValidateSet(...)]`) over manual `throw` — they fail before the body runs ([../../snippets/powershell/advanced-function-template.ps1](../../snippets/powershell/advanced-function-template.ps1)).

## How I use it

- `$ErrorActionPreference = 'Stop'` + `Set-StrictMode -Version Latest` at the top of scripts ([../../snippets/powershell/strict-mode.ps1](../../snippets/powershell/strict-mode.ps1)), then `try/catch` around risky sections.
- After every native command that matters, `if ($LASTEXITCODE -ne 0) { throw }` — don't trust `$?` alone.
- `-ErrorAction SilentlyContinue` only where a failure is genuinely expected and handled.

## Links

- [about_Try_Catch_Finally](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_try_catch_finally)
- [about_Preference_Variables](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_preference_variables)
