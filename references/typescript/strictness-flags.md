# Strictness flags

**TL;DR:** `"strict": true` turns on a family of flags that make the type checker actually catch bugs — most importantly `strictNullChecks` (you must handle `null`/`undefined`) and `noImplicitAny` (no silently-untyped values). Always enable `strict`. Then consider the extra non-`strict` flags (`noUncheckedIndexedAccess` especially) that close further holes. Strictness is what makes TypeScript worth using; without it you have lightly-annotated JavaScript.

## What `strict: true` includes

Setting `strict` enables all of these (you rarely toggle them individually):

| Flag | Catches |
|---|---|
| `strictNullChecks` | using a value that might be `null`/`undefined` without checking — the single highest-value flag |
| `noImplicitAny` | parameters/variables that silently become `any` |
| `strictFunctionTypes` | unsound function-parameter variance |
| `strictBindCallApply` | wrong args to `bind`/`call`/`apply` |
| `strictPropertyInitialization` | class fields not assigned in the constructor |
| `useUnknownInCatchVariables` | `catch (e)` typed as `unknown` (not `any`) — forces you to narrow errors |
| `alwaysStrict` | emits `"use strict"` |

(Verified: under `--strict`, `function f(x?: string){ return x.length }` errors with "x is possibly undefined" — that's `strictNullChecks` working.)

## `strictNullChecks` — the one that matters most

Without it, every type silently includes `null`/`undefined` and the checker lets you dereference them. With it, `string | undefined` is distinct from `string`, and you must narrow before use:

```ts
function len(x?: string) {
  // return x.length;          // error: x is possibly undefined
  return x?.length ?? 0;       // handled
}
```

This catches the entire class of "cannot read property of undefined" runtime errors at compile time. If you adopt nothing else, adopt this.

## Worthwhile flags NOT in `strict`

These add safety beyond `strict`; enable them on new code:

- **`noUncheckedIndexedAccess`** — `arr[i]` and `record[key]` become `T | undefined`, reflecting that the index might miss. Catches a huge class of off-by-one/missing-key bugs. The highest-value non-`strict` flag.
- **`exactOptionalPropertyTypes`** — distinguishes "property absent" from "property set to `undefined`."
- **`noImplicitOverride`** — requires `override` when overriding a base method.
- **`noFallthroughCasesInSwitch`** — flags missing `break`.
- **`noImplicitReturns`** — all code paths must return.

`noUncheckedIndexedAccess` occasionally feels noisy (you handle `undefined` more), but it's reflecting a real possibility the looser setting hides.

## `any` vs `unknown`

- **`any`** disables checking for that value — it's an escape hatch that silently spreads. Avoid; `noImplicitAny` stops it appearing by accident.
- **`unknown`** is the safe top type: you can hold anything, but must **narrow** before using it ([narrowing-and-guards.md](narrowing-and-guards.md)). Use `unknown` at untyped boundaries (JSON, `catch`) and narrow.

## Adopting strict on an existing codebase

Turning `strict` on a large JS/loose-TS codebase can surface hundreds of errors. Ratchet it incrementally — see [../../playbooks/typescript/adopt-strict-incrementally.md](../../playbooks/typescript/adopt-strict-incrementally.md).

## How I use it

- `strict: true` always; `noUncheckedIndexedAccess` on for new projects.
- `unknown` (never `any`) at boundaries, then narrow; reserve `any` for genuinely-untypable escapes with a comment.
- On legacy code, enable strict flags one at a time rather than all at once.

## Links

- [TSConfig — Strict Checks](https://www.typescriptlang.org/tsconfig#strict)
- [`noUncheckedIndexedAccess`](https://www.typescriptlang.org/tsconfig#noUncheckedIndexedAccess)
