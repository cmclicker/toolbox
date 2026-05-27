# Package managers (and distro differences)

**TL;DR:** How you install software is the **main** thing that differs between Linux distributions. Debian/Ubuntu use **apt** (`.deb` packages); Fedora/RHEL use **dnf** (`.rpm`); Arch uses **pacman**. The commands differ but the concepts are identical: update the package index, install/remove/upgrade, search. Cross-distro formats (**snap**, **flatpak**) and language package managers layer on top. This is the one Linux reference where "which distro" actually matters.

## The same operations, three dialects

| Task | apt (Debian/Ubuntu) | dnf (Fedora/RHEL) | pacman (Arch) |
|---|---|---|---|
| Refresh index | `sudo apt update` | (automatic) | `sudo pacman -Sy` |
| Install | `sudo apt install <pkg>` | `sudo dnf install <pkg>` | `sudo pacman -S <pkg>` |
| Remove | `sudo apt remove <pkg>` | `sudo dnf remove <pkg>` | `sudo pacman -R <pkg>` |
| Upgrade all | `sudo apt upgrade` | `sudo dnf upgrade` | `sudo pacman -Syu` |
| Search | `apt search <term>` | `dnf search <term>` | `pacman -Ss <term>` |
| What provides a file | `dpkg -S <file>` | `dnf provides <file>` | `pacman -Qo <file>` |
| List installed | `apt list --installed` | `dnf list installed` | `pacman -Q` |

(Verified on this WSL Ubuntu: `apt` is the package manager at `/usr/bin/apt`.) The recurring pattern: **update the index, then install**. On apt you must `apt update` before installing fresh; pacman folds it into `-Sy`; dnf refreshes automatically.

## apt specifics (Debian/Ubuntu — most likely your distro)

```bash
sudo apt update && sudo apt upgrade -y   # the routine maintenance pair
sudo apt install build-essential curl git
apt show <pkg>          # package details
sudo apt autoremove     # drop orphaned dependencies
```

`apt` is the modern front-end; `apt-get`/`apt-cache` are the older scriptable tools (use `apt-get` in scripts for a stable interface). Packages come from **repositories** listed in `/etc/apt/sources.list` and `/etc/apt/sources.list.d/`.

## Cross-distro package formats

- **Snap** (Canonical) — self-contained packages with bundled dependencies; default on Ubuntu for some apps. `sudo snap install <pkg>`. Auto-updating; some dislike the confinement/startup overhead.
- **Flatpak** — sandboxed desktop apps from Flathub, works across distros. `flatpak install flathub <app>`.
- **AppImage** — a single executable file, no install. Download, `chmod +x`, run.

These trade distro-native integration for portability; use them when a package isn't in your distro's repos or you want the latest upstream version.

## Don't confuse with language package managers

System package managers (apt/dnf/pacman) install **OS-level** software. Language ecosystems have their own — `npm`/`pnpm` (Node), `pip`/`uv` (Python), `cargo` (Rust), `gem` (Ruby). Rule of thumb: install **system tools and libraries** with the OS manager; install **project dependencies** with the language manager (in a venv/local scope), never system-wide via `sudo pip`.

## How I use it

- On Ubuntu/Debian: `sudo apt update && sudo apt upgrade`, then `apt install` what I need; `apt-get` in scripts for a stable CLI.
- Language deps via the language's own tool in project scope — never `sudo pip install` into the system Python.
- Snap/Flatpak/AppImage only when a package isn't packaged natively or I need a newer upstream build.
- On an unfamiliar distro, map the operation to its dialect using the table above — the concepts don't change.

## Links

- [Ubuntu — package management](https://ubuntu.com/server/docs/package-management)
- [Pacman/Rosetta (Arch Wiki) — cross-distro command comparison](https://wiki.archlinux.org/title/Pacman/Rosetta)
