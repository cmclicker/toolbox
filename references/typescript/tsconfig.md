# `tsconfig.json`

**TL;DR:** `tsconfig.json` configures the TypeScript compiler — what JS version to emit, which module system, how strict to be, and what files to include. The options that matter most: `strict` (turn it on), `target`/`module`/`moduleResolution` (match your runtime), and `outDir`/`rootDir` (where code goes). Modern projects often **don't emit** with `tsc` at all (a bundler/`tsx` runs the code), using `tsc --noEmit` purely as the type-checker.

## A modern baseline

```jsonc
{
  "compilerOptions": {
    "target": "ES2022",            // JS feature level to emit/allow
    "module": "NodeNext",           // module system (NodeNext for Node ESM/CJS)
    "moduleResolution": "NodeNext", // how imports are resolved
    "lib": ["ES2022"],              // ambient APIs available (add "DOM" for browser)
    "strict": true,                 // the whole strict family — non-negotiable
    "esModuleInterop": true,        // smooth CJS default-import interop
    "skipLibCheck": true,           // don't type-check .d.ts of deps (faster, fewer false errors)
    "forceConsistentCasingInFileNames": true,
    "outDir": "dist",
    "rootDir": "src",
    "declaration": true,            // emit .d.ts (for libraries)
    "sourceMap": true
  },
  "include": ["src"],
  "exclude": ["node_modules", "dist"]
}
```

A baseline preset is in [../../configs/typescript/tsconfig.base.json](../../configs/typescript/tsconfig.base.json).

## The options that actually matter

- **`strict`** — enables the whole strict family. Always on for new code; the constituent flags are in [strictness-flags.md](strictness-flags.md).
- **`target`** — the ECMAScript level of emitted JS and the syntax you may use. Match what your runtime supports (modern Node → `ES2022`+).
- **`module` / `moduleResolution`** — how `import`/`export` are emitted and resolved. Use `NodeNext` for Node projects (respects `package.json` `"type"` and `exports`); `Bundler` when a bundler (Vite, esbuild) handles resolution; the legacy `Node`/`CommonJS` only for old setups.
- **`lib`** — which built-in type definitions are available (`DOM` for browser APIs, `ES2022` for the language). Don't include `DOM` in a pure-Node project.
- **`outDir`/`rootDir`** — where emitted JS lands / where source starts.
- **`skipLibCheck: true`** — skip type-checking dependency `.d.ts` files; almost always worth it (faster, avoids errors in code you don't control).
- **`esModuleInterop: true`** — makes `import x from 'cjs-pkg'` work as expected.

## `extends` and project layout

Share a base across projects/packages:

```jsonc
// tsconfig.json
{ "extends": "./tsconfig.base.json", "compilerOptions": { "outDir": "dist" } }
```

For monorepos, **project references** (`"references": [{ "path": "../lib" }]` + `composite: true`) let `tsc --build` compile packages in dependency order with incremental caching.

## Type-check vs. emit

Two common modes:

- **`tsc` emits JS** (libraries, or Node apps that run the compiled `dist`). Set `outDir`, `declaration`.
- **`tsc --noEmit` as a checker only** — a bundler or runtime (Vite, esbuild, `tsx`, Bun) handles the actual transpile, and `tsc` just verifies types in CI/precommit. Set `"noEmit": true`. This is common for app/frontend projects.

Pick deliberately: emitting with `tsc` for a published library (you control the output + `.d.ts`); `--noEmit` checker for an app where a faster bundler transpiles.

## How I use it

- `strict: true`, `skipLibCheck: true`, `forceConsistentCasingInFileNames: true` in every project; a shared `tsconfig.base.json` via `extends`.
- `NodeNext` for Node, `Bundler` when a bundler owns resolution; `lib` matched to the runtime (no `DOM` in Node).
- `tsc --noEmit` as the CI type-check for apps; full emit + `declaration` for published libraries.

## Links

- [TSConfig reference (every option)](https://www.typescriptlang.org/tsconfig)
- [Modules — Theory & `moduleResolution`](https://www.typescriptlang.org/docs/handbook/modules/theory.html)
