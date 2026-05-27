# WSL (Windows Subsystem for Linux)

**TL;DR:** WSL runs a real Linux distribution inside Windows. **WSL 2** (the default) uses a lightweight VM with a genuine Linux kernel, so Linux tooling, Docker, and native binaries work as on Linux. It's the best of both worlds for cross-platform dev: Windows desktop + Linux toolchain. The main performance rule: keep your project files on the **Linux** filesystem when working from Linux, not on `/mnt/c`.

## Install and manage

```powershell
wsl --install                 # installs WSL 2 + Ubuntu by default (one command, then reboot)
wsl --install -d Debian       # a specific distro
wsl -l -v                     # list installed distros + WSL version + state
wsl --set-default <Distro>    # choose the default distro
wsl --update                  # update the WSL kernel
wsl --shutdown                # stop all distros (frees memory; resets after edits to .wslconfig)
```

(Verified here: WSL is present with **Ubuntu** on **version 2**.) Open a distro by running `wsl`, the distro name, or selecting its profile in Windows Terminal ([terminal-and-shells.md](terminal-and-shells.md)).

## WSL 1 vs. WSL 2

- **WSL 2** (default) — real Linux kernel in a managed VM. Full syscall compatibility, runs Docker and native ELF binaries, much faster at Linux-filesystem I/O. Use this.
- **WSL 1** — a translation layer, no VM. Faster *only* for cross-OS file access on `/mnt/c`, but limited compatibility. Rarely the right choice now.

`wsl --set-version <Distro> 2` converts an existing distro.

## Interop: crossing between Windows and Linux

- **Linux → Windows files:** your drives are mounted at `/mnt/c`, `/mnt/d`. You can read/write Windows files from Linux.
- **Windows → Linux files:** the distro's filesystem is at `\\wsl$\<Distro>\` (or `\\wsl.localhost\<Distro>\`) in Explorer and Windows tools.
- **Run across the boundary:** call Windows exes from Linux (`explorer.exe .`, `code .` to open VS Code, `clip.exe`); call Linux from Windows (`wsl ls -la`).
- **VS Code** has first-class WSL support: `code .` from inside WSL opens the editor on Windows with the workspace/tooling running in Linux.

## The performance rule (the #1 gotcha)

WSL 2 is fast on its **own** Linux filesystem and **slow** on `/mnt/c` (crossing the VM boundary for every file op). So:

- Keep code you build/run from Linux **inside** the distro (e.g. `~/projects`), not under `/mnt/c/Users/...`.
- A `git clone` + `npm install` under `/mnt/c` from WSL can be many times slower than under `~`. Put the repo on the Linux side.

The mirror applies too: editing the Linux filesystem from Windows tools over `\\wsl$` is slower than native — fine for occasional access, not for a build's hot path.

## Resource limits (`.wslconfig`)

WSL 2's VM can consume a lot of RAM. Cap it with a `%USERPROFILE%\.wslconfig` (applies after `wsl --shutdown`):

```ini
[wsl2]
memory=8GB
processors=4
```

A starter is in [../../configs/windows/.wslconfig](../../configs/windows/.wslconfig).

## Line endings across the boundary

A repo used from both Windows and WSL can get CRLF/LF confusion. The fix is the same `.gitattributes` (`* text=auto`) rule as everywhere ([../git/line-endings.md](../git/line-endings.md)) — commit it so normalization is consistent regardless of which side touched the file.

## How I use it

- WSL 2 + Ubuntu as the Linux toolchain; project files live **in** the distro (`~/projects`), not on `/mnt/c`.
- `code .` from WSL for VS Code; `explorer.exe .` to pop a folder in Windows.
- A `.wslconfig` capping RAM/CPU; `wsl --shutdown` to apply it or reclaim memory.
- `* text=auto` in `.gitattributes` for any repo shared across the Windows/Linux divide.

## Links

- [WSL documentation](https://learn.microsoft.com/en-us/windows/wsl/)
- [Best practices for set up (filesystem performance, VS Code, Git)](https://learn.microsoft.com/en-us/windows/wsl/setup/environment)
