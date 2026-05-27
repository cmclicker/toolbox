# Execution policy and profiles

**TL;DR:** Execution policy controls whether `.ps1` scripts are allowed to run; it's a safety speed-bump, **not** a security boundary. The usual developer setting is `RemoteSigned` (local scripts run; downloaded ones need a signature or to be unblocked). Profiles (`$PROFILE`) are scripts that run at shell startup — PowerShell's equivalent of `.bashrc`, where aliases, functions, and prompt live.

## Execution policy

```powershell
Get-ExecutionPolicy -List          # effective policy at each scope
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Common values:

| Policy | Effect |
|---|---|
| `Restricted` | no scripts run (interactive only) — old Windows client default |
| `RemoteSigned` | local scripts run; downloaded scripts need a signature *or* unblocking — the practical dev default |
| `AllSigned` | every script must be signed |
| `Bypass` | nothing blocked (use for a known-safe automation context) |

Scopes (most specific wins): `MachinePolicy`/`UserPolicy` (Group Policy) → `Process` → `CurrentUser` → `LocalMachine`. Set `-Scope CurrentUser` so you don't need admin and don't change machine-wide behavior.

**It is not security.** Anyone can bypass it (`powershell -ExecutionPolicy Bypass -File x.ps1`, or by pasting the script body). It exists to stop *accidental* execution of untrusted scripts, not a determined attacker. Don't rely on it as a control.

### "Script is blocked / cannot be loaded"

Two different causes:

- **Execution policy** too strict → set `RemoteSigned` for `CurrentUser` (above).
- **Mark-of-the-Web**: a file downloaded from the internet carries a "this came from elsewhere" tag, blocked under `RemoteSigned`. Clear it once you trust the file:
  ```powershell
  Unblock-File .\script.ps1
  Get-Item .\script.ps1 -Stream Zone.Identifier   # inspect the MOTW tag if present
  ```

## Profiles (`$PROFILE`)

A profile is a `.ps1` that runs when the shell starts — where you put aliases, functions, prompt, and module imports.

```powershell
$PROFILE                       # path to the current-user, current-host profile
$PROFILE | Format-List * -Force # all four profile paths
Test-Path $PROFILE             # does it exist yet?
if (!(Test-Path $PROFILE)) { New-Item $PROFILE -ItemType File -Force }
```

There are four profile files (per user / all users × current host / all hosts). The one you usually edit is `$PROFILE` itself = **current user, current host**. Key points:

- **Windows PowerShell 5.1 and PowerShell 7 have *separate* profile paths** (`WindowsPowerShell\` vs `PowerShell\` under Documents). Editing one doesn't affect the other — a frequent "my profile isn't loading" cause.
- Running scripts from a profile is subject to execution policy, so a too-strict policy can make the profile fail silently.
- Keep the profile fast; heavy work there slows every shell launch.

A starter profile is in [../../configs/powershell/profile.ps1](../../configs/powershell/profile.ps1).

## How I use it

- `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser` on a new machine; `Unblock-File` for trusted downloads — never treat the policy as a security guarantee.
- Maintain `$PROFILE` for aliases/prompt/functions; remember 5.1 and 7 have different profile files and set up whichever shell I actually use.
- `Test-Path $PROFILE` then create it if missing before editing.

## Links

- [about_Execution_Policies](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies)
- [about_Profiles](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles)
