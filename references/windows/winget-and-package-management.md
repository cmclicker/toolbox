# Package management: winget (and Scoop, Chocolatey)

**TL;DR:** `winget` is the built-in Windows Package Manager — install/upgrade/remove apps from the command line instead of hunting for installers. It ships with modern Windows 10/11. For dev tooling that should live in your user profile without admin, **Scoop** is often nicer; **Chocolatey** is the older, broadest ecosystem. You can export your installed set to a file and re-import it on a new machine.

## winget basics

```powershell
winget search node            # find a package
winget install Git.Git         # install (by exact id, recommended)
winget install --id Microsoft.PowerShell --source winget
winget list                    # what's installed (that winget knows about)
winget upgrade                 # show available upgrades
winget upgrade --all           # upgrade everything
winget uninstall <id>
```

(Verified present here: winget v1.28.) Prefer `--id Exact.Id` over a fuzzy name so you install the package you meant. Some installs need elevation; winget prompts via UAC.

## Reproducible setup: export / import

The feature that makes winget worth using for a dev machine — capture your apps and replay them:

```powershell
winget export -o packages.json            # write installed packages to JSON
winget import -i packages.json             # install them on another machine
winget import -i packages.json --accept-package-agreements --accept-source-agreements
```

A curated dev bundle is in [../../configs/windows/winget-packages.json](../../configs/windows/winget-packages.json); the new-machine procedure uses it ([../../playbooks/windows/set-up-dev-machine.md](../../playbooks/windows/set-up-dev-machine.md)).

## Scoop and Chocolatey (the alternatives)

| Manager | Installs to | Admin? | Best for |
|---|---|---|---|
| **winget** | system/user (per package) | sometimes | mainstream apps; built-in, no setup |
| **Scoop** | `~\scoop\` (user profile) | no (by design) | CLI dev tools, portable, no UAC, easy PATH |
| **Chocolatey** | system (Program Files) | usually | broadest catalog, system-wide, mature |

- **Scoop** keeps everything under your user profile and on PATH automatically — great for `jq`, `ripgrep`, language runtimes you want without admin. `scoop install <x>`; buckets add catalogs.
- **Chocolatey** has the largest package set and is common in enterprise/CI; `choco install <x>` (elevated).

They coexist; many devs use winget for GUI apps and Scoop for CLI tools. Don't install the *same* tool through two managers — you'll get version confusion on PATH.

## Caveats

- A package installed by winget that updates itself (e.g. browsers) may drift from winget's view; `winget upgrade` won't always see it.
- `winget list` shows Store/installer-registered apps too, not only winget-installed ones.
- Pin a version with `winget install <id> --version x.y` when you need reproducibility.

## How I use it

- `winget` for mainstream apps and one-shot installs; an exported `packages.json` to rebuild a machine.
- **Scoop** for CLI dev tools I want on PATH without admin.
- `winget upgrade --all` periodically; pin versions where reproducibility matters.

## Links

- [winget documentation](https://learn.microsoft.com/en-us/windows/package-manager/winget/)
- [Scoop](https://scoop.sh/) · [Chocolatey](https://chocolatey.org/)
