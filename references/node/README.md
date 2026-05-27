# Node.js — references

> My authored explainers for Node.js — the runtime, its module systems, and package management. The TypeScript layer and JavaScript-the-language are separate domains in this cluster (added as they land). For curated external material, see [../../resources/node/](../../resources/node/).

## Modules & packaging

- [modules-cjs-vs-esm.md](modules-cjs-vs-esm.md) — CommonJS vs. ES Modules, how Node picks, and the `__dirname`/`require`/top-level-`await` differences.
- [package-json.md](package-json.md) — the manifest field by field: `type`, `exports`, `scripts`, dependency kinds, `files`, `engines`.

## Dependencies

- [npm-and-dependencies.md](npm-and-dependencies.md) — `install` vs `ci`, the lockfile, dependency types, scripts/lifecycle, audit.
- [semver.md](semver.md) — `MAJOR.MINOR.PATCH`, `^`/`~` ranges, the `0.x` rule, ranges vs. the lockfile.

## Runtime

- [event-loop-and-async.md](event-loop-and-async.md) — single thread, micro vs. macrotasks, `async`/`await`, not blocking the loop.
- [built-in-modules.md](built-in-modules.md) — the standard library, and the modern built-ins (`fetch`, `node:test`, `--env-file`) that replace dependencies.
- [versions-and-managers.md](versions-and-managers.md) — LTS lines, nvm/fnm/Volta, `.nvmrc`/`engines`, Corepack.

## See also

- [../../configs/npm/](../../configs/npm/) — a sane `.npmrc`.
- [../../snippets/node/](../../snippets/node/) · [../../checklists/node/](../../checklists/node/) · [../../playbooks/node/](../../playbooks/node/) · [../../resources/node/](../../resources/node/)
- The `typescript` and `javascript` domains complete the JS/TS cluster (added as they land).
