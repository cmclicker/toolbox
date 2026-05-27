# Node versions and version managers

**TL;DR:** Node has time-based releases: **even-numbered majors become LTS** (Long-Term Support) and are what you should run in production; odd majors are short-lived. A version manager (**nvm**, **fnm**, **Volta**, or Corepack for package managers) lets you install and switch between Node versions per project, driven by an `.nvmrc` or `engines` field — so different projects can use different Node versions on one machine.

## The release line

- **Even majors (20, 22, 24…)** enter **LTS** ~6 months after release and are supported for ~30 months. Use the **Active LTS** for production.
- **Odd majors (21, 23…)** are "Current" only — newest features, but short support. Fine for experimenting, not for things you must maintain.
- "Current" = the latest release; "Active LTS" = the recommended stable line; "Maintenance" = older LTS getting only critical fixes.

Pick the **Active LTS** unless you specifically need a newer feature. Declare the floor in `package.json` `engines` ([package-json.md](package-json.md)).

## Why a version manager

Different projects pin different Node versions; a single system-wide Node forces them all onto the same one. A manager installs multiple versions side by side and switches per shell/project — and avoids the permission problems of `sudo npm -g`.

| Manager | Notes |
|---|---|
| **nvm** | the original (bash); `nvm use` per shell. Windows: use **nvm-windows** (separate project) |
| **fnm** | fast, cross-platform (Rust), nvm-compatible `.nvmrc`; good on Windows/WSL |
| **Volta** | pins tool versions *in `package.json`* and switches automatically per project; cross-platform |
| **Corepack** | ships with Node; manages the *package manager* (pnpm/yarn) version, not Node itself |

## Per-project version pinning

```bash
# .nvmrc  (just the version)
22

# then, in the project:
nvm use            # or: fnm use   — switches to the .nvmrc version
nvm install        # install that version if missing
```

`.nvmrc` (read by nvm and fnm) + `engines` in `package.json` together document and enforce the version. Volta instead records the pin inside `package.json` (`"volta": { "node": "22.x" }`) and switches transparently when you `cd` in.

## On Windows / WSL

- **WSL** → use `nvm` or `fnm` inside the Linux distro, exactly as on Linux ([../windows/wsl.md](../windows/wsl.md)).
- **Native Windows** → `fnm` (recommended, cross-platform) or **nvm-windows** (note: a different tool from Unix nvm, with its own commands). Don't mix a manager-installed Node with a `winget`/installer Node on the same PATH.

## Corepack (package managers)

```bash
corepack enable            # lets Node manage pnpm/yarn versions
# package.json: "packageManager": "pnpm@9.12.0"  → that exact pm version is used
```

Corepack pins the *package manager* per project so collaborators use the same pnpm/yarn — complementary to a Node version manager, not a replacement.

## How I use it

- **Active LTS** Node for real work; a version manager (`fnm` cross-platform, or `nvm` in WSL) so each project gets its pinned version.
- `.nvmrc` + `engines` in every project to document the version; `nvm use`/`fnm use` on entry.
- Corepack + `packageManager` to pin pnpm/yarn across the team.
- Never `sudo npm install -g`; a version manager puts global installs in user space.

## Links

- [Node releases & LTS schedule](https://nodejs.org/en/about/previous-releases)
- [nvm](https://github.com/nvm-sh/nvm) · [fnm](https://github.com/Schniz/fnm) · [Volta](https://volta.sh/) · [Corepack](https://nodejs.org/api/corepack.html)
