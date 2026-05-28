# Scope, closures, and hoisting

**TL;DR:** Use `const` by default and `let` when you must reassign; never `var`. Scope is **lexical** — an inner function can see the variables of the functions that enclose it, and it keeps that access even after the outer function returns. That captured access is a **closure**. `let`/`const` are block-scoped and live in a **temporal dead zone** until their declaration line, which turns silent `var` bugs into loud errors.

## `var` vs `let`/`const`

| | `var` | `let` / `const` |
|---|---|---|
| Scope | function | block (`{ }`) |
| Redeclare in same scope | allowed | error |
| Before declaration | `undefined` (hoisted) | ReferenceError (TDZ) |
| Reassign | yes | `let` yes, `const` no |

`const` prevents **reassignment of the binding**, not mutation of the value — `const o = {}; o.x = 1` is fine; `o = {}` throws. Reach for `Object.freeze` if you need shallow immutability.

## Hoisting and the temporal dead zone

Declarations are processed before any code runs. `var` is hoisted and initialized to `undefined`, so reading it early is silently wrong. `let`/`const` are hoisted too but **not initialized** — accessing them before their line throws, the "temporal dead zone" (TDZ):

```js
console.log(a); // undefined  (var: hoisted + initialized)
var a = 1;

console.log(b); // ReferenceError: Cannot access 'b' before initialization
let b = 1;
```

**Function declarations** hoist entirely (callable before their line); **function expressions**/arrow functions assigned to `let`/`const` follow the TDZ rule.

## Closures

A closure is a function plus the variables it captured from its defining scope. The captured variables are live references, not snapshots:

```js
function counter() {
  let n = 0;
  return () => ++n;        // closes over n
}
const next = counter();
next(); next();            // 1, 2 — n persists between calls
```

Closures power private state, memoization, and callbacks that "remember" context. They also **retain** what they capture — a closure held in a long-lived structure (event listener, cache, timer) keeps its captured objects alive, a common memory leak.

## The classic loop bug

```js
for (var i = 0; i < 3; i++) setTimeout(() => console.log(i)); // 3, 3, 3
for (let i = 0; i < 3; i++) setTimeout(() => console.log(i)); // 0, 1, 2
```

`var i` is one shared function-scoped binding; all callbacks see its final value. `let i` creates a **fresh binding per iteration**, so each closure captures its own `i`. This alone is a reason to never use `var`.

## How I use it

- `const` everywhere; `let` only for genuine reassignment; `var` never.
- Closures for private state and to bind context into callbacks — and I watch what they retain (clean up listeners/timers).
- `let` in `for` loops so each iteration's callbacks capture their own value.
- TDZ errors are a feature: they catch use-before-define instead of yielding `undefined`.

## Links

- [MDN — Closures](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Closures)
- [MDN — Hoisting](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Glossary/Hoisting)
