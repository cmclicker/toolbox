# `this`, `call`/`apply`/`bind`

**TL;DR:** In a regular function, `this` is decided **by how the function is called**, not where it's defined — there are four rules (new > explicit `bind`/`call`/`apply` > method-call object > default). **Arrow functions** ignore all of that: they capture `this` from the enclosing scope, which is exactly why they're the right choice for callbacks. The classic bug is passing a method as a callback and losing its `this`.

## The four binding rules (highest precedence first)

1. **`new`** — `new Fn()` makes a fresh object and binds it as `this`.
2. **Explicit** — `fn.call(obj, ...)`, `fn.apply(obj, argsArray)`, or `fn.bind(obj)` force `this = obj`.
3. **Method call** — `obj.fn()` binds `this = obj` (the thing left of the dot).
4. **Default** — a plain `fn()` call: `this` is `undefined` in strict mode / ES modules (and the global object in sloppy mode).

```js
function whoAmI() { return this?.name; }
const obj = { name: "obj", whoAmI };
obj.whoAmI();              // "obj"      (method call)
const loose = obj.whoAmI;
loose();                   // undefined  (default — dot context lost)
loose.call({ name: "x" }); // "x"        (explicit)
```

## Losing `this` (the #1 bug)

Extracting a method detaches it from its object:

```js
class Timer {
  seconds = 0;
  tick() { this.seconds++; }      // `this` needed
}
const t = new Timer();
setInterval(t.tick, 1000);        // ✗ tick() called as plain fn → this is undefined
setInterval(() => t.tick(), 1000);// ✓ arrow keeps the call as a method on t
setInterval(t.tick.bind(t), 1000);// ✓ bind freezes this = t
```

## `call` vs `apply` vs `bind`

- `call(thisArg, a, b)` — invoke now, args listed.
- `apply(thisArg, [a, b])` — invoke now, args as an array (rare since spread: `fn(...args)`).
- `bind(thisArg, ...partial)` — **return a new function** with `this` (and optional leading args) permanently fixed. Doesn't call.

## Arrow functions don't have their own `this`

An arrow function captures `this` lexically from where it's **defined**, and ignores `call`/`apply`/`new`. That's perfect for callbacks inside a method:

```js
class Cart {
  items = [];
  total() {
    return this.items.reduce((sum, i) => sum + i.price, 0); // arrow sees Cart's this
  }
}
```

But it makes arrows **wrong** as object methods that need their own `this` (`{ get: () => this.x }` captures the outer `this`, not the object) and as constructors (can't `new` them).

## How I use it

- Arrow functions for callbacks and anything that should inherit `this` from its surroundings.
- Regular functions/methods when the caller (or `new`) should supply `this`.
- `bind` to pin a method before passing it as a callback when an arrow wrapper isn't convenient.
- In strict mode / modules a stray `this` is `undefined` (a loud failure) rather than the global object — let it fail loudly.

## Links

- [MDN — `this`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/this)
- [MDN — Function.prototype.bind](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/bind)
