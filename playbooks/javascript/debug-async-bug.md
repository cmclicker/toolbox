# Playbook: debug an async/promise bug

> **Trigger:** code that "sometimes" fails, runs out of order, finishes before its data is ready, logs `UnhandledPromiseRejection`, or hangs forever. Est. time: 5–30 min. Concepts: [../../references/javascript/promises-and-async.md](../../references/javascript/promises-and-async.md), [../node/event-loop-and-async.md](../../references/node/event-loop-and-async.md).

## Step 1 — Classify the symptom

| Symptom | Usual cause | Jump to |
|---|---|---|
| `undefined`/empty value used too early | a promise not `await`ed | Step 2 |
| Unhandled rejection / silent failure | a floating promise with no `.catch` | Step 2 |
| Loop "doesn't wait" | `async` callback in `forEach`/`.map` not awaited | Step 3 |
| Slower than expected | sequential `await` where concurrent was possible | Step 3 |
| Hangs forever | a promise that never settles (resolve/reject never called) | Step 4 |
| Wrong order of logs | misunderstanding micro/macrotask ordering | Step 5 |

## Step 2 — Find the floating / un-awaited promise

Search for calls to `async` functions (and `.then` chains) whose result is **discarded**. Each must be `await`ed, `return`ed, or given a `.catch`. The quickest detector: add a process-level guard and reproduce —

```js
process.on("unhandledRejection", (reason) => { console.error("UNHANDLED:", reason); throw reason; });
```

If a value is `undefined` when used, confirm the producing call has `await` in front of it. Lint this permanently with `no-floating-promises` (typescript-eslint) / `require-await`.

## Step 3 — Fix loop concurrency

`arr.forEach(async x => { await f(x) })` returns immediately — `forEach` ignores the promises. Choose intent:

```js
for (const x of arr) await f(x);          // sequential: order/rate matters or steps depend
await Promise.all(arr.map(x => f(x)));     // concurrent: independent work, much faster
const results = await Promise.allSettled(arr.map(f)); // concurrent, want every result + failures
```

If concurrency must be bounded (e.g., 5 at a time), batch the array or use a small pool — don't fire thousands of requests at once.

## Step 4 — Hangs: a promise that never settles

A `new Promise((resolve, reject) => …)` whose `resolve`/`reject` is never reached (a branch that returns early, a callback that never fires, an error thrown before `resolve`) hangs the `await` forever. Verify **every** path calls resolve or reject exactly once. Add a timeout to localize it:

```js
const withTimeout = (p, ms) =>
  Promise.race([p, new Promise((_, rej) => setTimeout(() => rej(new Error("timeout")), ms))]);
```

For cancelable work, thread an `AbortSignal` (`AbortSignal.timeout(ms)`) through `fetch`/Node APIs instead.

## Step 5 — Ordering confusion

If logs print in an unexpected order, recall: all **synchronous** code runs first, then the **microtask** queue (promise continuations) drains completely, then the next **macrotask** (`setTimeout`, I/O). A promise chain can starve timers. See [event-loop-and-async.md](../../references/node/event-loop-and-async.md) for the exact rules. Don't "fix" ordering with `setTimeout(…, 0)` — express the real dependency with `await`.

## Step 6 — Lock it in

- Add the lint rules (`no-floating-promises`, `no-misused-promises`) so the class of bug can't return.
- Add a test that reproduces the timing (await the operation and assert on the settled result, not on a sleep).

## How I use it

Classify the symptom → hunt the un-awaited/floating promise first (it's usually that) → make loop concurrency explicit (`for await` vs `Promise.all`) → for hangs, prove every path settles and add a timeout → then enable the lint rules so it can't recur.
