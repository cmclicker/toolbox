# Iterables, iterators, and generators

**TL;DR:** An **iterable** is any object with a `[Symbol.iterator]()` method (arrays, strings, `Map`, `Set`, `arguments`, NodeLists). That single protocol is what `for...of`, spread `[...x]`, destructuring, and `Array.from` all consume. **Generators** (`function*` + `yield`) are the easy way to *produce* iterables, including lazy and infinite sequences. Prefer `Map`/`Set` over plain objects when you need a real collection.

## The iteration protocol

`for...of`, spread, array/destructuring, `Array.from`, and `Promise.all` all work on **anything iterable** — not just arrays:

```js
for (const ch of "abc") {}            // strings are iterable
const arr = [...new Set([1, 1, 2])];  // [1, 2] — spread consumes the Set
const [first, ...rest] = someIterable;
Array.from(map.values());
```

An iterable has `[Symbol.iterator]()` returning an **iterator** — an object with `next()` that yields `{ value, done }`. You rarely write this by hand; generators produce it for you.

## Generators

A `function*` runs lazily: it pauses at each `yield` and resumes on the next `.next()` / loop step. This makes infinite and on-demand sequences trivial:

```js
function* range(start, end, step = 1) {
  for (let i = start; i < end; i += step) yield i;
}
[...range(0, 5)];                 // [0, 1, 2, 3, 4]
for (const n of range(0, 1e9)) {  // lazy — doesn't build a billion-element array
  if (n > 3) break;               // generator just stops; nothing wasted
}

function* naturals() { let n = 0; while (true) yield n++; } // infinite, safe to break out of
```

`yield*` delegates to another iterable. Generators are also handy for tree/graph traversal (yield as you walk) and for producing values without materializing a whole array.

## `for...of` vs `for...in` vs array methods

- **`for...of`** — iterates **values** of an iterable. The default for arrays/sets/maps/strings.
- **`for...in`** — iterates **enumerable keys** (including inherited ones) of an object. Use for plain-object keys, but prefer `Object.keys/entries`; **never** use it to loop arrays (order isn't guaranteed and it hits prototype keys).
- **Array methods** (`map`/`filter`/`reduce`/`some`/`every`/`find`) — declarative, return new arrays/values, and read better than manual loops. Use `for...of` when you need `await`, `break`, or side effects.

## `Map` and `Set` (use them instead of objects/arrays)

```js
const m = new Map();              // any key type (objects too), real .size, ordered, iterable
m.set(keyObj, "v"); m.get(keyObj); m.has(keyObj); m.delete(keyObj);
for (const [k, v] of m) {}

const s = new Set([1, 2, 2]);     // unique values; s.has(x) is O(1)
```

Prefer `Map` over a plain object when keys are **dynamic data** (no prototype-collision bugs like a key named `"__proto__"` or `"constructor"`, real `.size`, any key type, insertion order). Prefer `Set` for membership/uniqueness over `arr.includes` in a loop. (`WeakMap`/`WeakSet` hold keys weakly — good for per-object metadata without leaking.)

## How I use it

- `for...of` for value iteration and any loop that needs `await`/`break`; array methods for transforms.
- `Object.entries/keys/values` to iterate plain objects; `for...in` almost never.
- Generators for lazy, infinite, or traversal sequences instead of building big intermediate arrays.
- `Map`/`Set` for collections keyed by dynamic data or needing fast membership — objects only for fixed-shape records.

## Links

- [MDN — Iteration protocols](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Iteration_protocols)
- [MDN — Generators](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/function*)
