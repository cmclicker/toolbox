# Windows 10 vs. 11 (for developers)

**TL;DR:** For day-to-day development the two are nearly identical — same shells, same WSL, same `winget`, same .NET/toolchains. The differences that matter to a developer are small: Windows 11 ships **Windows Terminal as the default** console and tends to have newer built-ins preinstalled, and Windows 10 is approaching **end of support (October 14, 2025)**. Target "Windows," not a specific version, and note version only where a feature genuinely differs.

## What's effectively the same

Shells (PowerShell 5.1 + `pwsh`, `cmd`, Git Bash), WSL 2, `winget`, environment-variable handling, the filesystem model, .NET, and virtually all language runtimes behave identically across 10 and 11. A script or dev setup that works on one works on the other. This is why the rest of this `windows/` domain doesn't split by version.

## The developer-relevant differences

| Area | Windows 10 | Windows 11 |
|---|---|---|
| Default terminal | legacy console host; install Windows Terminal manually | **Windows Terminal is the default** console host |
| `winget` | available, sometimes needs installing/updating (App Installer) | preinstalled and current |
| WSL | fully supported (`wsl --install` on recent builds) | fully supported; some newer WSL features land here first |
| Support lifecycle | **end of support Oct 14, 2025** | actively supported |
| Hardware reqs | lenient | TPM 2.0 + Secure Boot required (affects VMs/older hardware) |

None of these change *how you write code* — they change defaults and provisioning.

## Practical guidance

- **Write version-agnostic.** Target "Windows 10/11"; only call out a version when a feature truly differs (e.g. "Windows Terminal is preinstalled on 11; `winget install` it on 10").
- **On Windows 10, the first-setup steps differ slightly:** you may need to install Windows Terminal and ensure App Installer (winget) is current before the [dev-machine setup](../../playbooks/windows/set-up-dev-machine.md) runs smoothly.
- **End-of-support matters for security**, not features: an unsupported OS stops getting patches. If you're on 10, plan the move while your dev workflow stays the same.

## How I use it

- Treat the `windows/` references as version-neutral; this file is the one place version differences live.
- On a fresh Windows 10 box: install Windows Terminal + confirm `winget` works first, then follow the same setup as 11.
- I don't maintain separate Win10/Win11 content — the dev surface is the same.

## Links

- [Windows 11 requirements](https://learn.microsoft.com/en-us/windows/whats-new/windows-11-requirements)
- [Windows 10 end of support](https://www.microsoft.com/en-us/windows/end-of-support)
