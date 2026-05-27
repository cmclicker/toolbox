# Built-in modules (the standard library)

**TL;DR:** Node ships a substantial standard library — filesystem, paths, process/OS info, HTTP, streams, crypto, and more — importable with the `node:` prefix (`import fs from 'node:fs'`). Reach for built-ins before adding a dependency: modern Node covers a lot (including `fetch`, a test runner, and argument parsing) that used to need packages.

## The everyday modules

| Module | For | Notes |
|---|---|---|
| `node:fs` | files & directories | use `fs/promises` for async; `…Sync` for scripts |
| `node:path` | path manipulation | `join`, `resolve`, `dirname`, `extname` — cross-platform separators |
| `node:os` | OS info | `platform()`, `homedir()`, `cpus()`, `tmpdir()` |
| `node:process` | the running process | `argv`, `env`, `cwd()`, `exit()`, `platform` (global, no import needed) |
| `node:url` | URL parsing | `fileURLToPath` (ESM `__dirname` workaround) |
| `node:crypto` | hashing, random, ciphers | `randomUUID()`, `createHash` |
| `node:stream` | streaming data | back-pressure-aware piping of large data |
| `node:child_process` | run other programs | `spawn` (streaming), `execFile` (buffered) |
| `node:util` | helpers | `promisify`, `parseArgs` (CLI args), `inspect` |
| `node:events` | EventEmitter | the pub/sub base many APIs build on |

Always import with the **`node:`** prefix — it's unambiguous (can't be shadowed by an npm package named `fs`) and signals "built-in."

## `fs`: async vs. sync

```js
import { readFile, writeFile } from 'node:fs/promises';
const text = await readFile('config.json', 'utf8');   // async, non-blocking

import { readFileSync } from 'node:fs';
const text2 = readFileSync('config.json', 'utf8');     // sync — fine in a script
```

Use `fs/promises` in servers and anything concurrent (don't block the loop — [event-loop-and-async.md](event-loop-and-async.md)); `…Sync` is convenient and harmless in CLI startup/build scripts.

## `path`: build paths, don't concatenate

```js
import { join, resolve, dirname, extname } from 'node:path';
join('src', 'lib', 'x.js');   // 'src/lib/x.js' (or '\' on Windows)
resolve('./rel');             // absolute, from cwd
extname('a.tar.gz');          // '.gz'
```

`path.join`/`resolve` handle the OS separator and `..` correctly — never string-concatenate paths ([../windows/paths-and-filesystem.md](../windows/paths-and-filesystem.md)).

## Modern built-ins that replace dependencies

Recent Node (you're on 24) includes a lot that used to require packages:

- **`fetch`** — global, no `node-fetch` needed.
- **`node:test`** + `node:assert` — a built-in test runner (`node --test`), no Jest/Vitest required for simple cases.
- **`util.parseArgs`** — CLI argument parsing without `yargs`/`commander` for basic needs.
- **`structuredClone`** — deep clone, global.
- **`crypto.randomUUID()`** — UUIDs without the `uuid` package.
- **Watch mode** — `node --watch` reruns on file changes.
- **`.env` support** — `node --env-file=.env` loads env without `dotenv`.

Check whether a built-in covers the need before adding a dependency — it reduces install size, supply-chain surface, and maintenance.

## `child_process`: running other tools

```js
import { execFile } from 'node:child_process';
import { promisify } from 'node:util';
const { stdout } = await promisify(execFile)('git', ['rev-parse', 'HEAD']);
```

Prefer `execFile`/`spawn` with an **args array** over `exec` with a string — passing a command string invites shell-injection if any part is user-controlled. `spawn` streams output (good for long/large); `execFile` buffers (good for short).

## How I use it

- `node:`-prefixed built-ins first; add a dependency only when the stdlib genuinely doesn't cover it.
- `fs/promises` + `await` on hot paths; `…Sync` in scripts.
- `path.join`/`resolve` for paths; `execFile`/`spawn` with an args array (never `exec` with an interpolated string) for subprocesses.
- Lean on Node 24's `fetch`, `node --test`, `--env-file`, `--watch`, `randomUUID` instead of the packages they replace.

## Links

- [Node API documentation](https://nodejs.org/api/)
- [Node — Command-line options (`--test`, `--watch`, `--env-file`)](https://nodejs.org/api/cli.html)
