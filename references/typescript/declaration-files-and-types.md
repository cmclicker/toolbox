# Declaration files and `@types`

**TL;DR:** `.d.ts` files contain **types only** (no implementation) — they describe the shape of JavaScript so TypeScript can check code that uses it. Libraries either ship their own `.d.ts` (bundled types) or get them from the community **DefinitelyTyped** project, installed as `@types/<pkg>`. You also write `.d.ts` to type untyped JS, declare globals/ambient modules, and augment existing types.

## What a `.d.ts` is

A declaration file is the type "header" for JavaScript — signatures, interfaces, and types with no runtime code:

```ts
// math.d.ts — describes a JS module's shape
export function add(a: number, b: number): number;
export const PI: number;
```

When you `tsc` a library with `"declaration": true`, it emits a `.d.ts` next to each `.js` so consumers get types ([tsconfig.md](tsconfig.md)).

## Where a package's types come from

1. **Bundled** — the package ships `.d.ts` and points `package.json` `types`/`exports` at them. Nothing extra to install. (Most modern packages.)
2. **DefinitelyTyped** — for packages without bundled types, the community maintains them separately; install `@types/<pkg>` as a devDependency:
   ```bash
   npm i -D @types/node @types/express
   ```
   The compiler auto-discovers anything under `node_modules/@types`. `@types/node` is what types Node's built-ins.
3. **None** — an untyped package becomes `any`. Either write a local `.d.ts` (below) or pick a typed alternative.

Check [npm](https://www.npmjs.com/) — the "TS" badge means bundled types; otherwise look for an `@types/<pkg>` package.

## Writing declarations you need

**Type an untyped module** (quick stub to stop `any`/errors):

```ts
// types/untyped-lib.d.ts
declare module "untyped-lib" {
  export function doThing(x: string): number;
}
```

**Declare globals / ambient values** (a global injected by a script, a build-time constant):

```ts
declare global {
  interface Window { __APP_CONFIG__: { apiUrl: string }; }
}
export {};   // makes this file a module so `declare global` is valid
```

**Augment a library's types** via interface merging ([type-vs-interface.md](type-vs-interface.md)) — e.g. adding a property to Express's `Request`:

```ts
declare module "express-serve-static-core" {
  interface Request { userId?: string; }
}
```

Keep local declarations in a `types/` folder and ensure it's in `tsconfig`'s `include` (or `typeRoots`).

## `import type` and erasure

Because types are erased ([type-vs-runtime-and-validation.md](type-vs-runtime-and-validation.md)), importing something used **only as a type** should use `import type` so the import is guaranteed to be removed from the emitted JS (no accidental runtime dependency or side effect):

```ts
import type { User } from "./models";    // erased at compile time
import { type User, createUser } from "./models";  // mixed: type erased, value kept
```

`verbatimModuleSyntax` (tsconfig) enforces this distinction, which matters for correct ESM/CJS emit.

## How I use it

- Prefer packages with **bundled** types; otherwise `npm i -D @types/<pkg>`; `@types/node` always for Node projects.
- A small local `declare module`/`declare global` in `types/` to type a stubborn untyped dependency or an injected global, rather than sprinkling `any`.
- `import type` for type-only imports (and enable `verbatimModuleSyntax`) so nothing type-only leaks into runtime.

## Links

- [TS Handbook — Declaration Files](https://www.typescriptlang.org/docs/handbook/declaration-files/introduction.html)
- [DefinitelyTyped](https://github.com/DefinitelyTyped/DefinitelyTyped) · [`import type`](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-3-8.html#type-only-imports-and-export)
