# Narrowing and type guards

**TL;DR:** TypeScript follows your control flow and **narrows** a broad type to a specific one inside branches — after `if (typeof x === "string")`, `x` is `string` in that block. The built-in narrowers are `typeof`, `instanceof`, `in`, equality, and truthiness. For your own logic, write **user-defined type guards** (`x is T`) and use **discriminated unions** + an exhaustive `switch` to handle every case safely.

## Built-in narrowing

```ts
function f(x: string | number | null) {
  if (x == null) return;          // narrows out null AND undefined
  if (typeof x === "string") {
    x.toUpperCase();              // x is string here
  } else {
    x.toFixed(2);                 // x is number here
  }
}
```

- **`typeof`** — primitives (`"string"`, `"number"`, `"boolean"`, `"object"`, `"function"`, `"undefined"`).
- **`instanceof`** — class instances (`if (e instanceof Error)`).
- **`in`** — property presence (`if ("role" in user)`).
- **equality / truthiness** — `=== null`, `if (x)` (narrows out falsy, but beware `0`/`""`).
- **`Array.isArray(x)`** — narrows to an array.

The compiler tracks these through assignments, early returns, and `&&`/`||`, so structuring code with guard clauses gives you correctly-typed branches for free.

## Discriminated unions (the workhorse pattern)

Give each member of a union a common literal **discriminant** field; switching on it narrows to the exact member:

```ts
type Shape =
  | { kind: "circle"; r: number }
  | { kind: "rect"; w: number; h: number };

function area(s: Shape): number {
  switch (s.kind) {
    case "circle": return Math.PI * s.r ** 2;   // s is the circle member
    case "rect":   return s.w * s.h;            // s is the rect member
    default:       return assertNever(s);        // exhaustiveness — see below
  }
}
```

This is the idiomatic way to model "one of several shapes" (API responses, state machines, events) with full type safety per case.

## Exhaustiveness checking

Make the compiler enforce that you handled every case: in the `default`, assign to `never`. If a new union member is added later, this line becomes a compile error until you handle it.

```ts
function assertNever(x: never): never {
  throw new Error(`unhandled case: ${JSON.stringify(x)}`);
}
```

A reusable version is in [../../snippets/typescript/exhaustiveness-check.ts](../../snippets/typescript/exhaustiveness-check.ts). This turns "I added a variant and forgot to handle it somewhere" from a runtime bug into a compile error.

## User-defined type guards (`x is T`)

When narrowing logic isn't expressible with the built-ins, write a function returning a **type predicate**:

```ts
function isUser(v: unknown): v is User {
  return typeof v === "object" && v !== null && "id" in v && "name" in v;
}

if (isUser(data)) data.name;     // data is User inside the block
```

The `v is User` return type tells the compiler "if this returns true, treat the argument as `User`." Use these at boundaries to turn `unknown` into a known type. **Caveat:** a type guard is only as correct as its body — the compiler trusts your predicate, so a wrong check produces an unsound narrow. For untrusted external data, prefer a runtime validator (zod/valibot) that returns a typed result ([type-vs-runtime-and-validation.md](type-vs-runtime-and-validation.md)).

## Assertion functions

```ts
function assert(cond: unknown, msg?: string): asserts cond {
  if (!cond) throw new Error(msg);
}
assert(x != null);   // after this line, x is narrowed (non-null)
```

`asserts cond` / `asserts x is T` narrow by throwing rather than branching — handy for invariants.

## How I use it

- Guard clauses (`if (x == null) return`) so branches are correctly typed without nesting.
- **Discriminated unions + exhaustive `switch` + `assertNever`** for any "one of N shapes" model — it's the pattern I reach for most.
- `unknown` + a runtime validator (not just a hand-written `x is T` guard) for external/untrusted data; type guards for internal narrowing where I trust the predicate.

## Links

- [TS Handbook — Narrowing](https://www.typescriptlang.org/docs/handbook/2/narrowing.html)
- [Discriminated unions](https://www.typescriptlang.org/docs/handbook/2/narrowing.html#discriminated-unions)
