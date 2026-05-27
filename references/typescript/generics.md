# Generics

**TL;DR:** Generics let a function or type work over a **type parameter** instead of a fixed type, preserving the relationship between inputs and outputs. `function first<T>(arr: T[]): T | undefined` returns the *same* element type it was given. Constrain parameters with `extends`, give them defaults, and let inference fill them in — you rarely pass type arguments explicitly.

## The basic idea

```ts
function identity<T>(value: T): T { return value; }
identity("hi");      // T inferred as string; returns string
identity(42);        // T inferred as number; returns number
```

`T` is a placeholder bound at each call. Without generics you'd either fix the type (loses flexibility) or use `any` (loses safety). Generics keep the input→output type relationship intact.

```ts
function first<T>(arr: T[]): T | undefined { return arr[0]; }
const x = first([1, 2, 3]);   // x: number | undefined
```

## Constraints (`extends`)

Limit what a type parameter can be, so you can use its members:

```ts
function longest<T extends { length: number }>(a: T, b: T): T {
  return a.length >= b.length ? a : b;     // .length is known to exist
}
longest("ab", "abc");        // ok (strings have length)
longest([1], [1, 2]);        // ok (arrays do too)
// longest(1, 2);            // error: number has no length
```

`T extends Constraint` means "T must be assignable to Constraint." A very common pair is `K extends keyof T` for type-safe property access:

```ts
function prop<T, K extends keyof T>(obj: T, key: K): T[K] {
  return obj[key];           // return type is exactly the property's type
}
```

## Defaults and inference

```ts
type Box<T = string> = { value: T };   // default type argument
const b: Box = { value: "hi" };         // T defaults to string
```

Prefer letting TypeScript **infer** type arguments from the values you pass; specify them explicitly (`identity<number>(x)`) only when inference can't (e.g. an empty array, or to widen/narrow deliberately).

## Generic types and classes

```ts
interface Repository<T> {
  get(id: string): T | undefined;
  save(entity: T): void;
}
class Stack<T> { private items: T[] = []; push(x: T) { this.items.push(x); } }
```

## A glimpse of type-level programming

Generics power TypeScript's computed types — useful to recognize even if you write them rarely:

```ts
type Awaited2<T> = T extends Promise<infer U> ? U : T;   // conditional + infer
type Getters<T> = { [K in keyof T as `get${Capitalize<string & K>}`]: () => T[K] }; // mapped + key remap
```

`extends ? :` (conditional types), `infer` (extract a type), and mapped types (`[K in keyof T]`) are how the standard utility types are built ([utility-types.md](utility-types.md)). You consume these far more than you author them.

## Guidance

- Reach for generics when a function/type's output type **depends on** its input type (containers, repositories, helpers). If a parameter's type is unrelated to the result, you may not need a generic.
- Constrain (`extends`) so you can actually use the parameter and to get good errors.
- Don't over-engineer: a single concrete type or a union is often clearer than an elaborate generic. Generics earn their complexity when they remove real duplication or preserve a real type relationship.

## How I use it

- Generics for reusable containers/helpers and anywhere the result type tracks the argument (`first`, `prop`, `Repository<T>`).
- `K extends keyof T` for type-safe key access; constraints on every parameter I need to use.
- Lean on inference; pass explicit type args only when inference fails. Avoid clever conditional/mapped types unless they remove genuine duplication.

## Links

- [TS Handbook — Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
