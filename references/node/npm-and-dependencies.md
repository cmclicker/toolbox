# npm and dependencies

**TL;DR:** npm installs the packages in `package.json` into `node_modules` and records the exact resolved tree in `package-lock.json`. The two installs that matter: `npm install` (reads `package.json`, may update the lockfile) for development, and `npm ci` (installs strictly from the lockfile, deletes `node_modules` first) for CI and reproducible builds. Commit the lockfile.

## install vs. ci

| | `npm install` | `npm ci` |
|---|---|---|
| Source of truth | `package.json` (+ lock) | `package-lock.json` only |
| Updates lockfile | may | never (errors if out of sync) |
| `node_modules` | updates in place | wipes and reinstalls clean |
| Use for | day-to-day dev | CI, Docker, reproducible installs |

`npm ci` is faster and deterministic — use it anywhere the build must be repeatable. It fails if `package.json` and the lockfile disagree, which is a feature (catches an uncommitted lockfile change).

## Common commands

```bash
npm install                 # install everything from package.json
npm install lodash          # add a runtime dependency (+ to dependencies)
npm install -D vitest       # add a devDependency
npm install -g <tool>       # global (CLI tools); prefer npx for one-offs
npm uninstall lodash
npm update                  # upgrade within the allowed semver ranges
npm outdated                # show what's behind
npm run <script>            # run a package.json script
npx <tool>                  # run a package binary without installing it globally
npm ls <pkg>                # where a package sits in the dep tree
npm dedupe                  # flatten duplicate deps
```

## The lockfile

`package-lock.json` records the **exact** version and integrity hash of every package in the resolved tree, so everyone installs byte-identical dependencies. **Commit it.** Without it, `^1.2.3` ranges resolve to whatever's newest at install time, so two machines can get different code from the same `package.json`. `npm ci` requires it.

## Dependency types and where they go

- **`dependencies`** — needed at runtime by consumers. `npm install <pkg>`.
- **`devDependencies`** — build/test/lint only. `npm install -D <pkg>`.
- **`peerDependencies`** — the host a plugin attaches to; not auto-installed.

See [package-json.md](package-json.md) for why this split matters for published packages.

## Scripts and lifecycle hooks

```bash
npm run build               # run the "build" script
npm test                    # "test" and "start" don't need `run`
```

npm runs `pre<name>` and `post<name>` automatically around a script, plus lifecycle hooks: **`prepare`** (after `npm install` in the package, and before publish — common for Husky/build), **`prepublishOnly`** (before `npm publish`). Scripts run with `node_modules/.bin` on PATH, so local tools are callable by name.

## Security and maintenance

```bash
npm audit                   # report known vulnerabilities in the tree
npm audit fix               # apply non-breaking fixes
npm pack --dry-run          # preview exactly what `npm publish` would ship
```

Pair with Dependabot ([../github/repo-security.md](../github/repo-security.md)) for automated update PRs. Review `npm audit` findings rather than blindly `--force`-fixing (which can pull breaking majors).

## Alternatives (briefly)

**pnpm** (content-addressed store, fast, strict, great for monorepos) and **Yarn** are drop-in-ish alternatives. pnpm's strictness catches phantom dependencies npm allows. Whichever you pick, commit its lockfile and use the `--frozen-lockfile`/`ci` equivalent in CI. `packageManager` in `package.json` + Corepack pins the choice.

## How I use it

- `npm install` while developing; **`npm ci`** in CI/Docker; always commit `package-lock.json`.
- `npx` for one-off tool runs instead of polluting global installs.
- `npm pack --dry-run` before publishing; `npm audit` reviewed (not force-fixed) and Dependabot for ongoing updates.

## Links

- [npm CLI docs](https://docs.npmjs.com/cli/v10/commands)
- [`npm ci`](https://docs.npmjs.com/cli/v10/commands/npm-ci) · [package-lock.json](https://docs.npmjs.com/cli/v10/configuring-npm/package-lock-json)
