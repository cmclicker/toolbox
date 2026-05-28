# Destructuring, spread/rest, and optional syntax

**TL;DR:** Modern JavaScript has concise syntax that removes whole classes of boilerplate and bugs: **destructuring** pulls values out of objects/arrays (with defaults and renaming), **spread/rest** (`...`) copies and gathers, **optional chaining** (`?.`) short-circuits on `null`/`undefined`, and **nullish coalescing** (`??`) supplies a default *only* for `null`/`undefined`. Using `??`/`?.` correctly avoids the classic `||`-eats-`0`-and-`""` bug.

## Destructuring

```js
const { name, age = 0, address: { city } = {} } = user; // defaults + nested + rename via :
const [first, , third] = arr;                            // skip with holes
const { id, ...rest } = obj;                             // rest gathers remaining keys

function greet({ name, greeting = "Hi" }) {              // destructure params
  return `${greeting}, ${name}`;
}
const [a, b] = [b, a];                                   // swap without a temp
```

Defaults apply only when the value is **`undefined`** (not `null`). Renaming (`address: addr`) is useful to avoid name clashes.

## Spread and rest (`...`)

Same three dots, opposite jobs — **spread** expands, **rest** collects:

```js
const merged = { ...defaults, ...overrides };  // spread: later keys win
const copy = [...arr];                          // spread: shallow copy
const all = [...a, ...b];                        // concatenate

function sum(...nums) { return nums.reduce((t, n) => t + n, 0); } // rest: gather args
const [head, ...tail] = list;                    // rest in destructuring
sum(...[1, 2, 3]);                               // spread an array into args
```

Spread is **shallow** (nested objects stay shared — see [value-vs-reference-and-copying.md](value-vs-reference-and-copying.md)) and is the standard tool for immutable updates.

## Optional chaining `?.`

`a?.b` returns `undefined` instead of throwing when `a` is `null`/`undefined`. Works for property access, calls, and indexing:

```js
user?.address?.city          // undefined if user or address is null/undefined
user.profile?.()             // call only if it exists
data?.[key]                  // dynamic key, safe
obj?.fn?.()                  // optional access AND optional call
```

It short-circuits: if the left side is nullish, the rest isn't evaluated. Don't over-apply it — `a?.b.c` still throws if `a.b` is nullish; and using `?.` everywhere can mask bugs where a value should never be missing.

## Nullish coalescing `??` (and `??=`)

`a ?? b` yields `b` only when `a` is `null` or `undefined` — unlike `||`, it **keeps** `0`, `""`, `false`, and `NaN`:

```js
const port = config.port ?? 3000;   // 0 would be kept (it's a valid port-ish value)
const port2 = config.port || 3000;  // ✗ 0 → 3000 (the bug)
options.retries ??= 3;              // assign only if currently null/undefined
```

Use `??` for "default when absent"; reserve `||` for "default when falsy" (when you genuinely want to replace `""`/`0` too). `??` can't be mixed with `||`/`&&` without parentheses — the language requires them to prevent ambiguity.

## How I use it

- Destructure params and return objects for readable call sites; defaults for optional fields.
- Spread for shallow copies, merges, and immutable updates; rest to collect variadic args/remaining keys.
- `?.` to traverse data that may be partial (API responses, optional config) — but not as a blanket over real invariants.
- `??`/`??=` for defaults so `0`/`""`/`false` survive; `||` only when falsy-replacement is intended.

## Links

- [MDN — Destructuring assignment](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment)
- [MDN — Nullish coalescing (`??`)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Nullish_coalescing)
