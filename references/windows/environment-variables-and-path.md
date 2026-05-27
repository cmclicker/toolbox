# Environment variables and PATH on Windows

**TL;DR:** Windows stores environment variables in two persistent scopes — **User** and **Machine** (system) — held in the registry. When a process starts, Windows merges them (Machine then User) into the process's environment; `PATH` is the concatenation of both. Changing them via the GUI or `setx` writes the registry but **does not update already-running processes** — open a new terminal to pick up changes. Edit `PATH` carefully: a careless overwrite can wipe entries.

## The scopes

| Scope | Stored in | Needs admin to change | Applies to |
|---|---|---|---|
| **User** | `HKCU` | no | just your account |
| **Machine** (System) | `HKLM` | yes | all users |
| **Process** | in-memory | n/a | the current process + children only |

A process's live `PATH` = Machine PATH + User PATH, merged at launch. (Verified here: User had 11 entries, Machine 36, and the running process saw them combined.) That's why a tool you just installed isn't found until you open a new shell — the old shell still has the pre-change merged copy.

## Reading

```powershell
$env:PATH                                                   # the live process value
[Environment]::GetEnvironmentVariable('PATH','User')        # persisted User scope only
[Environment]::GetEnvironmentVariable('PATH','Machine')     # persisted Machine scope only
```

`$env:X` is always the *process* value; the `[Environment]` calls read the persisted registry scopes directly.

## Setting

```powershell
# Current process only (temporary, no persistence):
$env:MY_VAR = 'value'

# Persist to the User scope (no admin):
[Environment]::SetEnvironmentVariable('MY_VAR', 'value', 'User')

# Persist to Machine scope (needs an elevated shell):
[Environment]::SetEnvironmentVariable('MY_VAR', 'value', 'Machine')
```

Avoid `setx` for `PATH`: `setx` **truncates the value at 1024 characters** and can silently corrupt a long PATH. Use the `[Environment]::SetEnvironmentVariable(...,'User'|'Machine')` API or the GUI for PATH.

## Editing PATH safely

The danger is overwriting the whole variable instead of appending. Read the *correct scope*, append, write back — never assemble PATH from `$env:PATH` (that's the merged value; writing it back duplicates Machine entries into User):

```powershell
$dir  = 'C:\tools\bin'
$user = [Environment]::GetEnvironmentVariable('PATH','User')
if (($user -split ';') -notcontains $dir) {
    [Environment]::SetEnvironmentVariable('PATH', "$user;$dir", 'User')
}
```

A reusable, guarded helper is in [../../snippets/windows/path-helpers.ps1](../../snippets/windows/path-helpers.ps1).

## Making changes take effect without a reboot

New processes inherit the updated environment, so the simplest refresh is **open a new terminal**. To update the *current* session without restarting it, re-read the scopes and rebuild `$env:PATH`:

```powershell
$env:PATH = [Environment]::GetEnvironmentVariable('PATH','Machine') + ';' +
            [Environment]::GetEnvironmentVariable('PATH','User')
```

(The `path-helpers.ps1` snippet wraps this as `Update-SessionPath`.) Explorer-launched apps may need sign-out/in to see changes broadcast.

## The GUI

`SystemPropertiesAdvanced.exe` → Environment Variables, or search "Edit environment variables." The PATH editor there is a safe per-entry list (no manual `;` juggling) — good for one-off changes.

## How I use it

- User scope for my dev tools (no admin); Machine scope only for genuinely system-wide needs.
- The `[Environment]` API (or the GUI list editor) for PATH — never `setx` for PATH, never reassemble PATH from `$env:PATH`.
- New terminal to pick up changes; `Update-SessionPath` when I need the current shell updated immediately.

## Links

- [about_Environment_Variables](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_environment_variables)
- [.NET `Environment.SetEnvironmentVariable`](https://learn.microsoft.com/en-us/dotnet/api/system.environment.setenvironmentvariable)
