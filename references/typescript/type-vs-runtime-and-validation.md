# Types vs. runtime: erasure, `as`, `satisfies`, and validation

**TL;DR:** TypeScript types are **erased** at compile time — they do not exist when your code runs. So types cannot check external data (API responses, JSON, env vars, form input); a type annotation is a *promise*, not a *check*. At trust boundaries, validate at runtime (zod/valibot) and derive the type from the validator. Avoid `as` (it asserts without checking); prefer `satisfies` to check a value against a type while keeping its narrow type.

## Types are erased

TypeScript compiles to JavaScript with **all type information removed**. There's no reflection on types at runtime: you can't ask "is this value a `User`?" using the `User` type, and a wrong annotation produces no runtime error — it just lies to the compiler.

```ts
const data: User = JSON.parse(body);   // compiles fine; ZERO runtime checking
data.name.toUpperCase();                // crashes at runtime if body wasn't a User
```

This is the most important mental model: the type system checks your *code's internal consistency*, not the *actual shape of runtime data*.

## The boundary problem

Anything entering your program from outside is **untyped at runtime** regardless of its TypeScript type: HTTP request/response bodies, `JSON.parse`, `localStorage`, environment variables, file contents, form input. Annotating it (`as User`) tells the compiler to trust you — but nothing verifies it. A malformed response then crashes deep in your code with a confusing error, far from the boundary.

**Fix: validate at the boundary** with a runtime schema library and derive the static type from it, so there's one source of truth and the data is actually checked:

```ts
import { z } from "zod";
const User = z.object({ id: z.string(), name: z.string() });
type User = z.infer<typeof User>;          // the static type, derived from the schema

const data = User.parse(JSON.parse(body));  // throws (with a clear error) if invalid
data.name;                                  // now genuinely safe AND typed
```

`z.infer` keeps the type and the runtime check in sync — change the schema, the type follows. (valibot/arktype are alternatives with the same idea.)

## `as` — assertion, not conversion

`x as T` tells the compiler "trust me, this is `T`" with **no runtime effect or check**. It's an escape hatch that silently disables safety:

```ts
const el = document.getElementById("x") as HTMLInputElement;   // unchecked claim
const u = response.data as User;                               // a lie if it isn't
```

Use `as` sparingly — for genuinely-unavoidable cases (a DOM element you control, narrowing after your own validation). Never use it to "make the error go away" on external data; validate instead. `as any`/`as unknown as T` (double assertion) is a red flag — it fully bypasses the checker.

## `satisfies` — check without widening

`satisfies` verifies a value conforms to a type **without** changing the value's inferred (narrower) type:

```ts
const config = {
  port: 8080,
  host: "localhost",
} satisfies Record<string, string | number>;

config.port.toFixed(0);   // still known to be number — narrow type preserved
// vs `const config: Record<string, string|number>` which would WIDEN port to string|number
```

Use `satisfies` to get type-checking on a literal (catch typos/missing keys) while keeping precise literal types for downstream use. It's the right tool where people reach for `as` to annotate a constant.

## How I use it

- Treat every external input as untyped; **validate with zod** at the boundary and `z.infer` the type — one source of truth, real checking, clear errors where the bad data enters.
- `satisfies` for typed config/constants (keeps narrow types); plain annotations for internal values.
- `as` only for unavoidable, genuinely-safe assertions; `as any`/double-assertion treated as a code smell to justify or remove.
- Remember nothing about types survives to runtime — if a check must happen at runtime, it needs runtime code.

## Links

- [TS Handbook — Type assertions / `satisfies`](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-9.html#the-satisfies-operator)
- [Zod](https://zod.dev/) — runtime validation with static type inference
