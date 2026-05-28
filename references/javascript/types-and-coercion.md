# Types, values, and coercion

**TL;DR:** JavaScript has **7 primitives** (`string`, `number`, `bigint`, `boolean`, `undefined`, `symbol`, `null`) plus `object` (which includes arrays and functions). `typeof` reports the type — with two historic quirks: `typeof null === "object"` and `typeof function(){} === "function"`. The language coerces types aggressively, so always compare with `===`, know the **falsy** set, and treat `==` and arithmetic-on-strings as traps.

## The types and `typeof`

```js
typeof "hi"        // "string"
typeof 42          // "number"   (all numbers are IEEE-754 doubles)
typeof 10n         // "bigint"
typeof true        // "boolean"
typeof undefined   // "undefined"
typeof Symbol()    // "symbol"
typeof null        // "object"   ← a famous bug, kept for compatibility
typeof {}          // "object"
typeof []          // "object"   ← use Array.isArray() to detect arrays
typeof function(){} // "function" (functions are callable objects)
```

Primitives are immutable values compared **by value**; objects are compared **by reference** (see [value-vs-reference-and-copying.md](value-vs-reference-and-copying.md)).

## `null` vs `undefined`

- `undefined` — "not assigned": missing variables, missing params, missing properties, no `return`.
- `null` — "deliberately empty": you set it to signal absence.

Test for "neither" with `x == null` (the one defensible use of `==`: it matches both `null` and `undefined` and nothing else), or the modern `x ?? fallback` ([nullish coalescing](destructuring-spread-and-optional-syntax.md)).

## Truthiness — the falsy set

Exactly **eight** values are falsy; everything else (including `[]`, `{}`, `"0"`, `"false"`) is truthy:

```
false   0   -0   0n   ""   null   undefined   NaN
```

So `if (arr.length)` is fine, but `if (value)` will reject `0` and `""` — use `if (value != null)` when you mean "present."

## `==` vs `===`

`===` (strict) checks type **and** value, no conversion. `==` (loose) coerces operands to a common type using rules almost no one remembers (`"" == 0`, `[] == ![]`, `"\n" == 0` are all `true`). **Use `===`/`!==` everywhere**; the only sanctioned `==` is `x == null`.

```js
0 === "0"   // false
0 == "0"    // true  ← string coerced to number
NaN === NaN // false ← NaN is never equal to anything; use Number.isNaN(x)
```

## Number coercion gotchas

- `+` is overloaded: if **either** side is a string it concatenates, otherwise it adds. `1 + "2" === "12"`, but `1 - "2" === -1` (`-` only does math).
- Parse user input explicitly: `Number("3.14")`, `parseInt(s, 10)` (always pass the radix), or unary `+s`. `Number("")` is `0` (a trap); `Number("12px")` is `NaN` while `parseInt("12px", 10)` is `12`.
- Float math is inexact: `0.1 + 0.2 === 0.30000000000000004`. Compare with a tolerance, use integers (cents), or `BigInt` for exact large integers.
- `NaN` is the result of invalid math and is poisonous (propagates). Detect with `Number.isNaN(x)` (not the coercing global `isNaN`).

## How I use it

- `===`/`!==` always; `== null` only, and only to mean "null or undefined."
- `Number.isNaN` / `Number.isInteger` over the coercing globals; `parseInt(s, 10)` with an explicit radix.
- `x ?? default` to fall back only on `null`/`undefined` (keeps `0`/`""`); `x || default` only when I genuinely want to replace all falsy values.
- `Array.isArray(x)` to detect arrays; never `typeof` for that.

## Links

- [MDN — Equality comparisons and sameness](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Equality_comparisons_and_sameness)
- [MDN — typeof](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/typeof)
