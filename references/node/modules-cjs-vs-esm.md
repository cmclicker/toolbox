# Modules: CommonJS vs. ES Modules

**TL;DR:** Node has two module systems. **CommonJS (CJS)** — `require()`/`module.exports`, synchronous, the historical default. **ES Modules (ESM)** — `import`/`export`, the standard, what new code should use. Node decides which a file is by extension (`.mjs` = ESM, `.cjs` = CJS) or, for `.js`, by the nearest `package.json`'s `"type"` field. The migration pain is in the differences: `__dirname`, `require`, and top-level `await` all behave differently.

## How Node picks the mode

- `.mjs` → always ESM. `.cjs` → always CJS.
- `.js` → depends on the nearest `package.json`: `"type": "module"` makes `.js` files **ESM**; `"type": "commonjs"` or absent makes them **CJS**.

(Verified on Node 24: a `.js` under `"type":"module"` has no `require`; `.mjs` has no `__dirname`; `.cjs` has both.)

## The syntax

```js
// CommonJS
const fs = require('node:fs');
module.exports = { foo };

// ES Modules
import fs from 'node:fs';
export { foo };
export default bar;
```

Prefix Node built-ins with `node:` (`node:fs`, `node:path`) — it's unambiguous and works in both systems.

## The differences that bite

| | CommonJS | ES Modules |
|---|---|---|
| Import | `require()` (synchronous, anywhere) | `import` (static, hoisted) + dynamic `import()` |
| Export | `module.exports` / `exports` | `export` / `export default` |
| `__dirname`, `__filename` | available | **not defined** — use `import.meta.dirname`/`import.meta.url` |
| Top-level `await` | not allowed | **allowed** |
| Loading | synchronous | asynchronous |
| `require()` of ESM | historically threw; newer Node allows `require()` of ESM | — |

### Replacing `__dirname` in ESM

```js
// Node 20.11+ / 21.2+ (and 24): the easy way
const dir = import.meta.dirname;
const file = import.meta.filename;

// Portable older form:
import { fileURLToPath } from 'node:url';
import { dirname } from 'node:path';
const __dirname = dirname(fileURLToPath(import.meta.url));
```

## Interop

- **ESM can import CJS:** `import express from 'express'` works; the CJS `module.exports` becomes the default export. Named exports from CJS are best-effort (Node statically analyzes them).
- **CJS importing ESM:** historically required dynamic `import()` (async). Recent Node versions allow `require()` of ESM graphs that have no top-level `await`, easing the boundary — but don't rely on it for code that must run on older Node.
- **Dual packages:** a library can ship both via `package.json` `exports` with `import`/`require` conditions ([package-json.md](package-json.md)).

## Which to use

- **New projects → ESM.** It's the standard, supports top-level `await`, and tooling has caught up. Set `"type": "module"` and use `.js`.
- **Use `.cjs`/`.mjs` extensions** to be explicit when a single file must be a specific mode regardless of `"type"` (e.g. a CommonJS config file in an ESM project).
- This repo's own scripts are ESM (`.mjs`) for exactly this reason — explicit, no `package.json` ambiguity.

## How I use it

- ESM by default (`"type": "module"`, `.js`); `import.meta.dirname` instead of `__dirname`.
- `node:` prefix on built-ins; `.cjs`/`.mjs` extensions to force a mode for a one-off file.
- Expect to import CJS deps from ESM freely; treat CJS→ESM as the awkward direction and prefer dynamic `import()` there for portability.

## Links

- [Node — Modules: ECMAScript modules](https://nodejs.org/api/esm.html)
- [Node — Determining module system](https://nodejs.org/api/packages.html#determining-module-system)
