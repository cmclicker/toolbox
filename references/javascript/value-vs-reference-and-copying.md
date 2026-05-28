# Value vs. reference, and copying

**TL;DR:** Primitives are copied **by value**; objects, arrays, and functions are handled **by reference** — the variable holds a pointer, so assigning or passing it shares the same object. Mutating a shared object is visible everywhere it's referenced. To avoid surprises, copy deliberately: spread/`Object.assign` for a **shallow** copy, `structuredClone` for a **deep** one.

## The core distinction

```js
let a = 1; let b = a; b++;       // a === 1 — numbers copied by value
const o = { n: 1 };
const p = o; p.n = 2;            // o.n === 2 — same object, two names
o === p                          // true  (same reference)
{ n: 1 } === { n: 1 }            // false (different objects, even if equal-looking)
```

Equality of objects is **identity**, not contents. For value-equality you compare fields yourself or deep-equal (see [snippets/javascript/](../../snippets/javascript/)).

## Function arguments are passed the same way

JavaScript is always pass-by-value — but for objects the *value passed is the reference*. So a function **can mutate** the object you passed, but **reassigning the parameter** doesn't affect the caller:

```js
function f(obj, num) {
  obj.x = 99;   // ✓ caller sees this (same object)
  num = 99;     // ✗ caller's number unchanged (reassigned local copy)
  obj = {};     // ✗ caller's variable unchanged (reassigned local copy)
}
```

## Shallow copy

Spread and `Object.assign` copy **one level**; nested objects are still shared:

```js
const orig = { a: 1, nested: { b: 2 } };
const copy = { ...orig };          // or Object.assign({}, orig)
copy.a = 9;                        // orig.a unchanged ✓
copy.nested.b = 9;                 // orig.nested.b ALSO 9 ✗ (nested object shared)

const arr2 = [...arr];             // shallow array copy
const arr3 = arr.slice();          // same
```

Spread is also how you update immutably (the React/Redux pattern): `{ ...state, count: state.count + 1 }`.

## Deep copy

`structuredClone(value)` (built into Node 17+ and modern browsers) recursively clones, handles cycles, `Map`/`Set`/`Date`/typed arrays — and is the right default:

```js
const deep = structuredClone(orig);
deep.nested.b = 9;                 // orig.nested.b unchanged ✓
```

Limits: it **can't** clone functions, DOM nodes, or class prototypes (throws / returns a plain object). The old `JSON.parse(JSON.stringify(x))` trick is a last resort — it silently drops `undefined`, functions, and symbols, and mangles `Date` (→ string), `NaN`/`Infinity` (→ `null`), `Map`/`Set`, and `BigInt` (throws).

## Practical guidance

- Treat shared objects as dangerous to mutate; copy before changing if others hold a reference.
- Prefer **immutable updates** (`{ ...obj, k: v }`, `arr.map`, `arr.filter`, `[...arr, x]`) over in-place mutation in shared/state code.
- Reach for `structuredClone` for deep copies; `Object.freeze` to make accidental mutation throw.

## How I use it

- Spread for shallow copies and immutable updates; `structuredClone` when I need a true deep copy of plain data.
- I never rely on `===` to compare object contents — that's identity.
- In functions, I document/avoid mutating arguments; if I must return a changed version, I copy first.

## Links

- [MDN — structuredClone](https://developer.mozilla.org/en-US/docs/Web/API/Window/structuredClone)
- [MDN — Spread syntax](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Spread_syntax)
