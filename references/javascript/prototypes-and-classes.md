# Prototypes and classes

**TL;DR:** Every object has a hidden link to a **prototype** object; property lookups that miss walk up this **prototype chain** until they hit `null`. `class` is syntax sugar over this prototype mechanism — cleaner to write, same machinery underneath. Methods live on the prototype (shared); instance fields live on the object. Know the chain to understand inheritance, `instanceof`, and why monkey-patching built-ins is risky.

## The prototype chain

```js
const arr = [1, 2];
// arr → Array.prototype → Object.prototype → null
arr.map(...)        // found on Array.prototype
arr.hasOwnProperty // found on Object.prototype
arr.nope           // walked to null → undefined
```

Reading a property searches the object, then its prototype, then *its* prototype, up to `null`. **Writing** a property always sets it on the object itself (it doesn't modify the prototype). Inspect/set the link with `Object.getPrototypeOf(o)` / `Object.create(proto)` (avoid the legacy `__proto__`).

## `class` is sugar over prototypes

```js
class Animal {
  constructor(name) { this.name = name; }  // instance field
  speak() { return `${this.name} makes a sound`; } // → Animal.prototype.speak
}
class Dog extends Animal {
  speak() { return `${super.speak()} (woof)`; }   // override + super
}
new Dog("Rex").speak(); // "Rex makes a sound (woof)"
```

- `constructor` runs on `new`; `extends` sets the prototype chain; `super(...)` calls the parent constructor and `super.method()` the parent method.
- Methods go on `.prototype` (one shared copy). **Class fields** (`count = 0`) and anything set with `this.x =` are **per-instance**.
- `static` members live on the class itself, not instances.
- `#private` fields are truly private (enforced, not a convention); accessible only inside the class body.

## `new`, `instanceof`, and detection

`new Fn()`: creates an object whose prototype is `Fn.prototype`, runs `Fn` with `this` bound to it, and returns it. `x instanceof Fn` checks whether `Fn.prototype` appears anywhere in `x`'s chain — so it's true for subclasses too, and unreliable across realms (iframes/workers). For plain-shape checks prefer feature/`in` tests; for arrays use `Array.isArray`.

## `Object.create` and own vs inherited

```js
const proto = { greet() { return "hi"; } };
const o = Object.create(proto);   // o's prototype is proto
o.greet();                        // "hi" (inherited)
Object.hasOwn(o, "greet");        // false — it's on the prototype
```

Use `Object.hasOwn(o, key)` (or `Object.keys`, which is own+enumerable only) to distinguish own properties — important when iterating objects used as maps (though a real [`Map`](iterables-and-generators.md) is usually better).

## Don't monkey-patch built-ins

Adding to `Array.prototype`/`Object.prototype` affects **every** object in the program and breaks `for...in`, other libraries, and future language features that add the same name. Extend with your own functions/subclasses instead.

## How I use it

- `class` for types with shared behavior and inheritance; `#private` for real encapsulation.
- Methods on the prototype (automatic with `class`), per-instance state via fields/`this`.
- `Object.hasOwn` / `Object.keys` to read own properties; a `Map` when keys are dynamic data.
- Never patch built-in prototypes; `instanceof` only within one realm, `Array.isArray` for arrays.

## Links

- [MDN — Inheritance and the prototype chain](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Inheritance_and_the_prototype_chain)
- [MDN — Classes](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Classes)
