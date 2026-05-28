# Checklist: JavaScript correctness review

> Walk this over a JS diff (or before you commit) to catch the language's recurring footguns — coercion, `this`, async, and accidental mutation. Each item is yes/no. Concepts: [../../references/javascript/types-and-coercion.md](../../references/javascript/types-and-coercion.md), [../../references/javascript/promises-and-async.md](../../references/javascript/promises-and-async.md).

## Equality & types

- [ ] Comparisons use `===`/`!==` (the only `==` is `x == null` to mean null-or-undefined).
- [ ] Defaults that must keep `0`/`""`/`false` use `??`, not `||`.
- [ ] Numbers from input are parsed explicitly (`Number(x)`, `parseInt(x, 10)`) and `NaN` is checked with `Number.isNaN`.
- [ ] Array detection uses `Array.isArray`, not `typeof`.

## Scope & `this`

- [ ] No `var`; `const` by default, `let` only where reassigned.
- [ ] Loop variables that feed closures/callbacks are `let`/`const` (not a shared `var`).
- [ ] Methods passed as callbacks keep their `this` (arrow wrapper or `.bind`), and arrow functions aren't used where their own `this` is needed.

## Async

- [ ] Every promise is `await`ed, `return`ed, or has a `.catch` — no floating promises.
- [ ] No `async` callback passed to `forEach` (use `for...of` + `await`, or `Promise.all(map(...))`).
- [ ] Independent awaits run concurrently (`Promise.all`), not serially in a loop, unless ordering/rate-limiting requires it.
- [ ] `try/catch` around `await` rethrows or handles meaningfully (doesn't silently swallow).
- [ ] Long-lived / cancelable async work uses `AbortController`/timeout where appropriate.

## Mutation & data

- [ ] Shared objects/arrays aren't mutated in place where callers hold a reference (copy first, or update immutably with spread/`map`/`filter`).
- [ ] Deep copies use `structuredClone`, not `JSON.parse(JSON.stringify(...))` (which drops/mangles `Date`/`Map`/`undefined`/functions).
- [ ] Function arguments aren't mutated unexpectedly (or it's documented/intended).

## Collections & iteration

- [ ] Dynamic-keyed lookups use `Map`/`Set` (not plain objects vulnerable to `__proto__`/`constructor` keys), and own-key reads use `Object.hasOwn`/`Object.keys`.
- [ ] `for...in` isn't used to iterate arrays; object iteration uses `Object.entries/keys/values`.

## Errors

- [ ] Thrown values are `Error` objects (with `cause` when wrapping), not strings.
- [ ] No empty `catch {}` that hides failures.
