# The event loop and async execution

**TL;DR:** Node runs your JavaScript on a **single thread** with an **event loop**: synchronous code runs to completion, then queued callbacks run. I/O (files, network, timers) is offloaded so it doesn't block. The key rules: **don't block the loop** with long synchronous work, and understand that **microtasks** (promises) run before the next **macrotask** (timers, I/O callbacks). Blocking the loop freezes the entire process.

## Single thread, non-blocking I/O

Your JS executes on one thread. When you start I/O (read a file, make a request), Node hands it to the underlying system (libuv's thread pool or the OS) and **continues**; when it completes, the callback is queued to run on the main thread. So one thread serves many concurrent operations — as long as none of them *blocks* the thread.

This is why a slow `for` loop or a synchronous `fs.readFileSync` of a huge file is so damaging: while it runs, **nothing else** happens — no other requests, no timers, no I/O callbacks.

## Macrotasks vs. microtasks (the ordering rule)

After the current synchronous code finishes, Node drains the **microtask** queue completely before taking the next **macrotask**:

- **Microtasks:** resolved Promise callbacks (`.then`/`await` continuations), `queueMicrotask`, `process.nextTick` (which runs even before other microtasks).
- **Macrotasks:** `setTimeout`/`setInterval`, I/O callbacks, `setImmediate`.

```js
console.log('1');
setTimeout(() => console.log('4 (macrotask)'), 0);
Promise.resolve().then(() => console.log('3 (microtask)'));
console.log('2');
// Output: 1, 2, 3, 4 — sync first, then ALL microtasks, then the timer
```

Practical upshot: a promise chain that keeps resolving can **starve** timers and I/O, because microtasks always run before the next macrotask.

## `async`/`await` is promises

`await` doesn't block the thread — it suspends the async function and returns control to the event loop; the continuation runs as a microtask when the awaited promise settles. Patterns:

```js
// Sequential (each awaits the previous) — slower when independent:
const a = await fetchA();
const b = await fetchB();

// Concurrent (start both, then await) — faster for independent work:
const [a, b] = await Promise.all([fetchA(), fetchB()]);
```

`Promise.all` (fail-fast), `Promise.allSettled` (wait for all, collect results+errors), `Promise.race`/`any` round out the toolkit. (The language-level promise/async details live in the `javascript` domain.)

## Don't block the loop

- **CPU-bound work** (parsing huge data, crypto, image work) blocks everything. Move it off the main thread: a **Worker thread** (`node:worker_threads`), a child process, or chunk the work and yield (`await new Promise(r => setImmediate(r))`).
- **Prefer async I/O** (`fs.promises.readFile`) over the `…Sync` variants in anything handling concurrent work; `…Sync` is fine in CLI startup/scripts where nothing else is waiting.
- A server that "randomly hangs under load" is often one synchronous hot path blocking the loop.

## How I use it

- Async (`fs.promises`, `await`) on any server path; `…Sync` only in scripts/startup where blocking is harmless.
- `Promise.all` for independent awaits instead of awaiting them in series.
- Offload CPU-heavy work to a Worker thread rather than blocking the loop.
- When debugging a "frozen" Node process, look for synchronous work (a big loop, sync I/O, a runaway microtask chain) on the main thread.

## Links

- [Node — The Node.js Event Loop](https://nodejs.org/en/learn/asynchronous-work/event-loop-timers-and-nexttick)
- [Don't Block the Event Loop](https://nodejs.org/en/learn/asynchronous-work/dont-block-the-event-loop)
