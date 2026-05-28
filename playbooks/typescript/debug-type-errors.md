# Playbook: debug a confusing TypeScript error

> **Trigger:** a type error you don't understand — a wall of text, "not assignable to," or an error that points at the wrong place. Est. time: 2–20 min. Concepts: [../../references/typescript/narrowing-and-guards.md](../../references/typescript/narrowing-and-guards.md), [../../references/typescript/type-vs-runtime-and-validation.md](../../references/typescript/type-vs-runtime-and-validation.md).

## Step 1 — Read the error bottom-up

TypeScript errors nest: the top line is the high-level mismatch, and it drills down. The **most specific, deepest line** ("Type 'undefined' is not assignable to type 'string'") usually names the real problem; the top line is just where it surfaced. Read the innermost reason first.

## Step 2 — See the actual types (hover / `tsc`)

The fastest tool is your editor: **hover** the value to see its inferred type, and hover the error squiggle for the full message. To force the compiler to *print* a type, assign it somewhere typed, or use a helper:

```ts
type Show<T> = { [K in keyof T]: T[K] };   // expands a type in hover tooltips
type Expanded = Show<TheConfusingType>;     // hover Expanded to see it flattened
```

Run `tsc --noEmit` to get the canonical error (the editor and CLI should agree; if they differ, you're on different TS versions or tsconfigs).

## Step 3 — Localize: is it the value or the type?

- **Annotate the value explicitly** at the error site. If `const x: ExpectedType = expr` errors, the problem is `expr`'s type, not downstream use.
- **Check what was inferred** vs. what you expected — often a value is wider (`string` not the literal `"a"`) or includes `undefined` you didn't account for (especially under `strictNullChecks`/`noUncheckedIndexedAccess`).

## Step 4 — Map the message to a cause

| Message fragment | Usual cause |
|---|---|
| `'X' is possibly 'undefined'` | `strictNullChecks`/`noUncheckedIndexedAccess` — narrow it ([narrowing](../../references/typescript/narrowing-and-guards.md)) |
| `Type 'A' is not assignable to type 'B'` | shapes differ; read the nested reason for the exact property |
| `Object is of type 'unknown'` | a `catch` var or validated input — narrow before use |
| `Property 'x' does not exist on type` | wrong type, or a union where only some members have `x` (narrow first) |
| `No overload matches this call` | argument types don't fit any signature; check each arg's type |
| `Excessively deep / possibly infinite` | a recursive conditional/mapped type — simplify it |
| error in `node_modules` / a `.d.ts` | enable `skipLibCheck`; or a `@types` version mismatch |

## Step 5 — Resolve correctly (not by silencing)

- **Narrow** (`if`, type guard, discriminated union) so the type genuinely is what you use.
- **Fix the type** if the annotation is wrong; **derive** with utility types instead of redeclaring ([utility-types](../../references/typescript/utility-types.md)).
- Use `satisfies` (not `as`) to check a literal against a type while keeping its narrow type.
- Only as a last resort: `// @ts-expect-error <reason>` (errors if later fixed) — never a blanket `as any` to make it disappear, which hides real bugs ([type-vs-runtime](../../references/typescript/type-vs-runtime-and-validation.md)).

## Step 6 — Version-specific sanity check

If an error makes no sense, confirm the editor's TS version matches the project's (`tsc --version` vs. the editor's "TypeScript version"), and that you're editing the tsconfig that actually governs the file. Mismatched versions/configs produce phantom errors.

## How I use it

Read the **deepest** error line first → hover (or `Show<T>`) to see real inferred types → annotate at the site to localize → narrow/fix/`satisfies` rather than `as any` → check TS version/tsconfig alignment if it's truly baffling.
