# TypeScript — references

> My authored explainers for TypeScript — the type system on top of JavaScript. The runtime (Node) is in [../node/](../node/); JavaScript-the-language is in [../javascript/](../javascript/). For curated external material, see [../../resources/typescript/](../../resources/typescript/).

## Setup & strictness

- [tsconfig.md](tsconfig.md) — the compiler config, a modern baseline, and emit-vs-typecheck-only.
- [strictness-flags.md](strictness-flags.md) — what `strict` includes, `strictNullChecks`, and the extra flags worth enabling (`noUncheckedIndexedAccess`).

## The type system

- [type-vs-interface.md](type-vs-interface.md) — when to use each, declaration merging, extending.
- [narrowing-and-guards.md](narrowing-and-guards.md) — control-flow narrowing, discriminated unions, exhaustiveness, user-defined guards.
- [generics.md](generics.md) — type parameters, constraints (`extends`), inference, a glimpse of type-level programming.
- [utility-types.md](utility-types.md) — `Partial`/`Pick`/`Omit`/`Record`/`ReturnType`/`Awaited`; derive, don't duplicate.

## Types meet reality

- [type-vs-runtime-and-validation.md](type-vs-runtime-and-validation.md) — erasure, the boundary problem, runtime validation (zod), `as` vs `satisfies`.
- [declaration-files-and-types.md](declaration-files-and-types.md) — `.d.ts`, `@types`/DefinitelyTyped, declaring globals/modules, `import type`.

## See also

- [../../configs/typescript/](../../configs/typescript/) — strict tsconfig presets.
- [../../snippets/typescript/](../../snippets/typescript/) · [../../playbooks/typescript/](../../playbooks/typescript/) · [../../resources/typescript/](../../resources/typescript/)
- [../node/](../node/) — the runtime · [../javascript/](../javascript/) — the language. ESLint/Prettier (the tooling domain) closes the cluster.
