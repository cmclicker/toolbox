# `type` vs. `interface`

**TL;DR:** Both name a shape. `interface` is for object/class shapes and supports declaration merging and `extends`; `type` aliases anything — unions, intersections, primitives, tuples, mapped/conditional types. Practical rule: use `interface` for object shapes you might extend (especially public API and class contracts), `type` when you need a union or a computed type. Pick one as your default for plain objects and be consistent; the differences rarely matter day to day.

## What each can do

```ts
interface User { id: string; name: string; }
type User2 = { id: string; name: string };   // equivalent for a plain object

type Id = string | number;                    // union — interface CANNOT do this
type Pair = [number, number];                 // tuple
type Keys = keyof User;                        // computed — type only
type Nullable<T> = T | null;                   // generic alias
```

- **`interface`** — object and class shapes only. Supports `extends`, is implemented by classes (`class C implements User`), and **merges** (below).
- **`type`** — aliases *any* type: unions, intersections (`A & B`), tuples, primitives, mapped types, conditional types. Can't be reopened/merged.

## Declaration merging (interface only)

Two `interface` declarations with the same name **merge** into one:

```ts
interface Window { myGlobal: number; }   // augments the existing DOM Window
```

This is essential for **augmenting** existing types (the global `Window`, a library's types, Express's `Request`). `type` cannot do this — a duplicate `type` name is an error. So ambient augmentation must use `interface`.

## Extending

```ts
interface Admin extends User { role: string; }      // interface extends
type Admin2 = User & { role: string };               // type via intersection
```

Both work; `extends` gives slightly better error messages and is the natural fit for object hierarchies. Intersections (`&`) are more flexible (combine with unions/generics) but can produce `never` on conflicting properties.

## Performance / errors (minor)

For large object hierarchies, `interface extends` is marginally faster for the compiler and tends to produce clearer error messages than deep intersection chains. Rarely decisive, but a tiebreaker for big public APIs.

## The practical rule

- **Object shape, especially public API or a class contract, possibly extended** → `interface`.
- **Union, tuple, primitive alias, mapped/conditional, or anything `interface` can't express** → `type`.
- **Augmenting an existing/global/library type** → `interface` (merging).
- For ordinary internal object types either is fine — **pick a default and stay consistent** across the codebase rather than mixing arbitrarily.

## How I use it

- `interface` for object/class shapes and any public API surface (extendable, mergeable, clear errors).
- `type` the moment I need a union, tuple, or computed type — which is often, so plenty of both.
- `interface` for augmenting globals/library types (the only option that merges).
- One consistent default for plain internal objects; I don't agonize over equivalent cases.

## Links

- [TS Handbook — Type Aliases vs Interfaces](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#differences-between-type-aliases-and-interfaces)
- [Declaration Merging](https://www.typescriptlang.org/docs/handbook/declaration-merging.html)
