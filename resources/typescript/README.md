# TypeScript — resources

> Curated external material for TypeScript. My own explainers are in [../../references/typescript/](../../references/typescript/); the runtime is in [../node/](../node/); the JavaScript-language catalog is in [../javascript/](../javascript/).

## Official docs & specs

- **[TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/intro.html)** — the authoritative guide; the "Everyday Types," "Narrowing," and "Generics" chapters are the core.
- **[TSConfig reference](https://www.typescriptlang.org/tsconfig)** — every compiler option with a description.
- **[Utility Types](https://www.typescriptlang.org/docs/handbook/utility-types.html)** — the built-in type helpers.
- **[Release notes](https://www.typescriptlang.org/docs/handbook/release-notes/overview.html)** — what each version added (`satisfies`, `const` type params, etc.).

## Learn

- **[Total TypeScript (Matt Pocock)](https://www.totaltypescript.com/)** — exercises and articles, especially strong on generics and real-world patterns. The free beginner/essentials material is excellent.
- **[Type Challenges](https://github.com/type-challenges/type-challenges)** — graded puzzles for type-level programming (when you want to go deep on conditional/mapped types).

## Cheatsheets & quick-reference

- **[TypeScript Cheat Sheets (official)](https://www.typescriptlang.org/cheatsheets)** — one-page visual references for types, interfaces, classes, control flow.
- **[The Concise TypeScript Book](https://github.com/gibbok/typescript-book)** — free, compact, well-organized reference.

## Tools & utilities

- **[TS Playground](https://www.typescriptlang.org/play)** — try types in the browser, share links, inspect emitted JS and errors. Indispensable for isolating a type question.
- **[ts-reset (Total TypeScript)](https://github.com/total-typescript/ts-reset)** — opt-in patches to make built-in types safer (e.g. `JSON.parse` returning `unknown`).
- **[Zod](https://zod.dev/)** — runtime validation with static inference, for the boundary problem ([../../references/typescript/type-vs-runtime-and-validation.md](../../references/typescript/type-vs-runtime-and-validation.md)).
- **[typescript-eslint](https://typescript-eslint.io/)** — lint rules that use type information (covered in the tooling domain).

---

_Last checked: 2026-05. External links rot — see [maintenance notes](../README.md#maintenance)._
