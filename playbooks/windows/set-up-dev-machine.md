# Playbook: set up a Windows dev machine

> **Trigger:** a fresh (or freshly-reset) Windows box you want ready for development. Est. time: 30–60 min plus download/reboot time. Concepts: [../../references/windows/](../../references/windows/).

## Step 0 — Baseline checks

```powershell
winget --version            # confirm winget exists (preinstalled on Win 11)
$PSVersionTable.PSVersion   # note whether you're on 5.1 or 7
```

On **Windows 10**: if `winget` is missing, install "App Installer" from the Store, and install Windows Terminal (`winget install Microsoft.WindowsTerminal`) — both ship by default on Windows 11. See [../../references/windows/windows-10-vs-11.md](../../references/windows/windows-10-vs-11.md).

## Step 1 — Install your toolset with winget

Use the curated bundle and edit it down to what you want first:

```powershell
winget import -i winget-packages.json --accept-package-agreements --accept-source-agreements
```

The starter list ([../../configs/windows/winget-packages.json](../../configs/windows/winget-packages.json)) includes Git, GitHub CLI, PowerShell 7, Windows Terminal, VS Code, Node LTS, Python, JDK, Docker Desktop, PowerToys. Some installs trigger UAC; some (Docker) need a reboot. After installing, **open a new terminal** so PATH picks up the new tools ([../../references/windows/environment-variables-and-path.md](../../references/windows/environment-variables-and-path.md)).

## Step 2 — Set up the terminal and default shell

- Open **Windows Terminal**, Settings (Ctrl+,) → set the **default profile** to `pwsh` (PowerShell 7) or your WSL distro ([../../references/windows/terminal-and-shells.md](../../references/windows/terminal-and-shells.md)).
- Drop in a PowerShell profile if you want aliases/prompt ([../../configs/powershell/profile.ps1](../../configs/powershell/profile.ps1)); set execution policy: `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`.

## Step 3 — Configure Git

```powershell
git config --global user.name  "Your Name"
git config --global user.email "you@example.com"
```

Apply the toolbox Git config and global ignore/attributes ([../../configs/git/](../../configs/git/)), and set up auth: `gh auth login` (GitHub CLI) wires up credentials for HTTPS push. Consider SSH commit signing ([../../references/git/tags-and-signing.md](../../references/git/tags-and-signing.md)).

## Step 4 — Install WSL (if you want a Linux toolchain)

```powershell
wsl --install               # WSL 2 + Ubuntu by default; REBOOT when prompted
```

After reboot, launch Ubuntu to create your Linux user, then:

- Put project files **inside** the distro (`~/projects`), not on `/mnt/c`, for performance ([../../references/windows/wsl.md](../../references/windows/wsl.md)).
- Add a `%USERPROFILE%\.wslconfig` to cap RAM/CPU ([../../configs/windows/.wslconfig](../../configs/windows/.wslconfig)); `wsl --shutdown` to apply.
- Set up Git **inside** WSL too (its config is separate from Windows).

## Step 5 — Enable developer conveniences

- **Developer Mode** (Settings → System → For developers) — allows symlinks without admin and other dev features.
- **Long paths**: `git config --system core.longpaths true` and enable the OS long-path policy ([../../references/windows/paths-and-filesystem.md](../../references/windows/paths-and-filesystem.md)).
- **VS Code**: install the WSL extension if using WSL; sign in to sync settings/extensions.

## Step 6 — Verify

```powershell
git --version; node --version; python --version; gh auth status
wsl -l -v                   # distro present and on version 2
```

Confirm each tool resolves on PATH in a **new** terminal, CI/auth works (`gh auth status`), and a test `git clone` + build succeeds (do it inside WSL if that's your toolchain).

## Notes

- Re-run `winget upgrade --all` periodically to keep tools current.
- Capture your eventual setup with `winget export -o my-packages.json` so the *next* machine is one `winget import` away.
- This is a checklist-style procedure with one real branch (WSL reboot); keep the exported package list in sync with what you actually use.
