# Built-in utility types

**TL;DR:** TypeScript ships generic helper types that transform existing types so you don't redeclare shapes: `Partial<T>` (all optional), `Pick<T, K>`/`Omit<T, K>` (subset), `Record<K, V>` (map), `ReturnType<F>`/`Parameters<F>` (extract from functions), `Awaited<T>` (unwrap promises). Derive types from a single source of truth instead of hand-maintaining parallel definitions.

## Object-shape transforms

Given `interface User { id: string; name: string; email: string }`:

| Utility | Result | Use for |
|---|---|---|
| `Partial<User>` | all properties optional | update/patch payloads |
| `Required<User>` | all properties required | the inverse |
| `Readonly<User>` | all properties readonly | immutable views |
| `Pick<User, "id" \| "name">` | only those keys | a projection/subset |
| `Omit<User, "email">` | all keys except those | "everything but X" |
| `Record<string, User>` | `{ [k: string]: User }` | a dictionary/map type |

```ts
function update(id: string, patch: Partial<User>) { /* ... */ }
type UserPreview = Pick<User, "id" | "name">;
type UsersById = Record<string, User>;
```

`Omit`/`Pick` keep derived types in sync with the source — change `User` and they update automatically, unlike a hand-copied shape.

## Union transforms

```ts
type Status = "active" | "inactive" | "banned";
Exclude<Status, "banned">        // "active" | "inactive"
Extract<Status, "active" | "x">  // "active"
NonNullable<string | null>       // string  (drops null & undefined)
```

## Extract from functions and promises

```ts
function makeUser(id: string, name: string) { return { id, name }; }
type Mk = typeof makeUser;          // get the function's TYPE from the value
type User = ReturnType<Mk>;          // { id: string; name: string }
type Args = Parameters<Mk>;          // [string, string]
type R = Awaited<Promise<number>>;   // number (unwraps nested promises too)
```

`ReturnType`/`Parameters` + `typeof` let you **derive** a type from an existing function rather than declaring it twice — change the function and the derived types follow. `Awaited` unwraps the resolved type of a promise (what `await` gives you).

## String-manipulation types

`Uppercase<S>`, `Lowercase<S>`, `Capitalize<S>`, `Uncapitalize<S>` operate on string-literal types — used with template-literal types to compute key names (e.g. `get${Capitalize<K>}`).

## The principle: one source of truth

The point of utility types is to **derive, not duplicate**. Define the canonical type once and compute the variants:

```ts
interface User { id: string; name: string; email: string; createdAt: Date; }
type NewUser = Omit<User, "id" | "createdAt">;     // input to "create"
type UserUpdate = Partial<Omit<User, "id">>;        // patch payload
type UserList = User[];
```

When `User` changes, every derived type updates — no drift between parallel definitions. Compose them freely (`Partial<Omit<...>>`).

## How I use it

- `Omit`/`Pick`/`Partial` to derive request/response/patch shapes from one canonical entity type.
- `Record<K, V>` for dictionaries; `ReturnType<typeof fn>` to avoid re-declaring a function's result type.
- `Awaited<ReturnType<typeof asyncFn>>` to get the resolved type of an async function.
- Treat a hand-written type that mirrors another as a smell — derive it instead.

## Links

- [TS Handbook — Utility Types](https://www.typescriptlang.org/docs/handbook/utility-types.html)
- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html) · [Template Literal Types](https://www.typescriptlang.org/docs/handbook/2/template-literal-types.html)
