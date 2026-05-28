# JavaScript — references

> My authored explainers for JavaScript the **language** — the semantics shared by every runtime. The runtime (Node) is in [../node/](../node/) and the type layer in [../typescript/](../typescript/); this domain is the language itself. For curated external material, see [../../resources/javascript/](../../resources/javascript/).

## Values & types

- [types-and-coercion.md](types-and-coercion.md) — the 7 primitives, `typeof` quirks, `null` vs `undefined`, truthiness, `===` vs `==`, number/`NaN` traps.
- [value-vs-reference-and-copying.md](value-vs-reference-and-copying.md) — value vs reference semantics, mutation, shallow copy (spread) vs deep copy (`structuredClone`).

## Scope & functions

- [scope-closures-and-hoisting.md](scope-closures-and-hoisting.md) — `const`/`let`/`var`, block scope, the TDZ, closures, and the classic loop bug.
- [this-call-apply-bind.md](this-call-apply-bind.md) — the four `this` rules, losing `this`, `call`/`apply`/`bind`, and why arrows are right for callbacks.

## Objects & inheritance

- [prototypes-and-classes.md](prototypes-and-classes.md) — the prototype chain, `class` as sugar over it, `new`/`instanceof`, own vs inherited, why not to patch built-ins.

## Iteration & modern syntax

- [iterables-and-generators.md](iterables-and-generators.md) — the iteration protocol, `for...of` vs `for...in`, generators, and `Map`/`Set` over objects/arrays.
- [destructuring-spread-and-optional-syntax.md](destructuring-spread-and-optional-syntax.md) — destructuring, spread/rest, optional chaining `?.`, nullish coalescing `??`.

## Async

- [promises-and-async.md](promises-and-async.md) — promises, `async`/`await`, sequential vs concurrent, the combinators, and floating-promise/`forEach` traps.

## See also

- [../../snippets/javascript/](../../snippets/javascript/) · [../../configs/javascript/](../../configs/javascript/) · [../../checklists/javascript/](../../checklists/javascript/) · [../../playbooks/javascript/](../../playbooks/javascript/) · [../../resources/javascript/](../../resources/javascript/)
- [../node/](../node/) — the runtime and event loop · [../typescript/](../typescript/) — the type layer. ESLint/Prettier (the tooling domain) closes the cluster.
