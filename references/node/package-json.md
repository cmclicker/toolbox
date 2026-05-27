# `package.json` field by field

**TL;DR:** `package.json` is the manifest for a Node project — identity, dependencies, scripts, and how the package is consumed. Most fields are optional, but a handful are load-bearing: `type` (module system), `main`/`exports` (entry points), `scripts` (commands), `dependencies` vs `devDependencies`, `engines`, and `files` (what gets published). Getting `exports` and `files` wrong is the usual cause of "it works locally but breaks when installed."

## Identity

```jsonc
{
  "name": "my-package",        // lowercase, url-safe; scoped: "@scope/name"
  "version": "1.2.3",          // semver — see semver.md
  "description": "...",
  "license": "MIT",
  "type": "module"             // "module" = ESM, "commonjs"/absent = CJS (modules-cjs-vs-esm.md)
}
```

## Entry points: `main`, `exports`, `bin`

- **`main`** — the legacy single entry point (`"./dist/index.js"`).
- **`exports`** — the modern, stricter entry map. It **encapsulates** the package: only listed paths are importable, and it supports conditional resolution (ESM vs CJS, types):

```jsonc
"exports": {
  ".": {
    "types": "./dist/index.d.ts",
    "import": "./dist/index.mjs",
    "require": "./dist/index.cjs"
  },
  "./feature": "./dist/feature.js"
}
```

When `exports` is present it takes precedence over `main` and **blocks deep imports** not listed (`import 'pkg/src/internal'` fails) — good for keeping internals private, but a common surprise when consumers can't reach a path. Put `types` first in each conditions block.

- **`bin`** — maps CLI command names to scripts (`"mycli": "./bin/cli.js"`); the file needs a shebang and is symlinked onto PATH on install.

## `scripts`

```jsonc
"scripts": {
  "build": "tsc",
  "test": "vitest run",
  "lint": "eslint .",
  "prepare": "...",           // lifecycle: runs on install (e.g. husky setup)
  "prepublishOnly": "npm run build"
}
```

Run with `npm run <name>` (`test`/`start` need no `run`). Lifecycle names (`pre`/`post<script>`, `prepare`, `prepublishOnly`) fire automatically — see [npm-and-dependencies.md](npm-and-dependencies.md).

## Dependencies

| Field | For | Installed by consumers? |
|---|---|---|
| `dependencies` | runtime needs | yes |
| `devDependencies` | build/test/lint tooling | no (not when installed as a dep) |
| `peerDependencies` | a host the package plugs into (React, ESLint) | not auto-installed; the host provides it |
| `optionalDependencies` | nice-to-have; install failure is non-fatal | yes, if possible |

Putting a build tool in `dependencies` bloats every consumer's install; putting a runtime need in `devDependencies` breaks consumers. This split matters most for *published* packages.

## Publishing & environment

- **`files`** — allowlist of what gets published to the registry (e.g. `["dist"]`). Without it, npm publishes most of the directory (minus `.gitignore`d/`.npmignore`d). Verify with `npm pack --dry-run`.
- **`engines`** — declares supported runtimes (`"node": ">=20"`). Advisory unless `engine-strict` is set; still signals intent and can gate installs.
- **`sideEffects`** — `false` lets bundlers tree-shake aggressively.
- **`packageManager`** — pins the package manager/version for Corepack (`"pnpm@9.0.0"`).

## How I use it

- `"type": "module"`, `exports` (not just `main`) with `types` first, and a `files` allowlist for anything published — then `npm pack --dry-run` to confirm the tarball.
- Strict `dependencies`/`devDependencies` discipline for published packages; less critical for apps.
- `engines` to document the Node floor; `scripts` as the canonical task interface (`build`/`test`/`lint`).

## Links

- [npm — package.json](https://docs.npmjs.com/cli/v10/configuring-npm/package-json)
- [Node — Packages (exports, type, conditions)](https://nodejs.org/api/packages.html)
