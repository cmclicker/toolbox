# Windows Terminal and the available shells

**TL;DR:** On Windows there's a difference between the **terminal** (the window/app that draws text and handles tabs, fonts, input) and the **shell** (the program that interprets commands). **Windows Terminal** is the modern terminal app — default on Windows 11 — and it hosts any shell in tabs: Windows PowerShell 5.1, PowerShell 7 (`pwsh`), Command Prompt (`cmd`), Git Bash, and WSL distros. Pick `pwsh` or WSL as your default; keep `cmd` only for legacy batch.

## Terminal vs. shell

- **Terminal** — the host application. Windows Terminal (`wt`) is the current one; the old "console host" (`conhost.exe`) is what bare `cmd`/`powershell` windows used.
- **Shell** — the command interpreter running inside it. Same shell, different terminals; same terminal, different shells.

This separation is why "open PowerShell" and "open a PowerShell tab in Windows Terminal" run the *same* shell in *different* terminals.

## The shells you'll encounter

| Shell | Launches | Use for |
|---|---|---|
| Windows PowerShell 5.1 | `powershell` | the built-in, frozen version; legacy/automation pinned to it |
| PowerShell 7+ | `pwsh` | your default PowerShell — modern syntax, cross-platform ([../powershell/powershell-5-vs-7.md](../powershell/powershell-5-vs-7.md)) |
| Command Prompt | `cmd` | legacy `.bat`/`.cmd`; avoid for new work |
| Git Bash | `bash` (from Git for Windows) | a Unix-style shell on Windows ([../bash/](../bash/)) |
| WSL | `wsl` / distro name | a real Linux shell ([wsl.md](wsl.md)) |

## Windows Terminal

Default on Windows 11 (verified present on this machine); installable from the Store or `winget install Microsoft.WindowsTerminal` on Windows 10.

- **Launch:** `wt` (also `wt -d .` to open in the current directory; `wt nt` new tab).
- **Multiple shells in tabs/panes:** each "profile" is a shell; split panes with Alt+Shift+`+`/`-`.
- **Set your default shell:** Settings (Ctrl+,) → Startup → Default profile. Point it at `pwsh` or your WSL distro rather than 5.1/`cmd`.
- **Config is JSON:** Settings has a GUI, but everything is backed by a `settings.json` you can version — handy for replicating setup across machines.

## Choosing a default

- **`pwsh` (PowerShell 7)** for Windows-native scripting and admin with modern syntax.
- **WSL** when you want a genuine Linux toolchain (most cross-platform/web dev).
- **Git Bash** for a lightweight POSIX shell without a full WSL distro.
- **`cmd`** only to run existing batch files; don't write new automation in it.

## How I use it

- Windows Terminal as the one terminal app; default profile set to `pwsh` (or WSL Ubuntu for Linux-toolchain work).
- Tabs/panes for different shells side by side instead of separate windows.
- `wt -d .` from Explorer/scripts to open a terminal in a specific folder.
- New automation in PowerShell 7 or Bash; `cmd` reserved for legacy batch only.

## Links

- [Windows Terminal documentation](https://learn.microsoft.com/en-us/windows/terminal/)
- [Windows Terminal — settings (settings.json)](https://learn.microsoft.com/en-us/windows/terminal/customize-settings/startup)
