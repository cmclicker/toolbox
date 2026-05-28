# Promises and `async`/`await`

**TL;DR:** A `Promise` is a placeholder for a value that arrives later; it's `pending`, then settles `fulfilled` or `rejected`. `async`/`await` is syntax over promises: `await` pauses the function until a promise settles and unwraps it, and a `throw` becomes a rejection. The rules that prevent bugs: **always handle rejections**, **`await` or `return` every promise** (don't fire-and-forget), and run independent work **concurrently** with `Promise.all`. (How this schedules on the event loop is in [../node/event-loop-and-async.md](../node/event-loop-and-async.md).)

## Promises and `async`/`await`

```js
// These are equivalent:
function getUserThen(id) {
  return fetch(`/u/${id}`).then(r => r.json()).catch(err => { throw new Error("failed", { cause: err }); });
}
async function getUser(id) {
  try {
    const r = await fetch(`/u/${id}`);
    return await r.json();
  } catch (err) {
    throw new Error("failed", { cause: err });
  }
}
```

An `async` function **always returns a promise**; `return x` fulfills it with `x`, `throw e` rejects it. `await p` yields `p`'s fulfilled value or throws its rejection (catchable with `try/catch`).

## Sequential vs. concurrent

`await` in a loop runs requests **one after another**. For independent work, start them all and await together:

```js
// ✗ Slow: each awaits the previous (sum of latencies)
for (const id of ids) results.push(await getUser(id));

// ✓ Fast: all in flight at once (max latency)
const results = await Promise.all(ids.map(getUser));
```

Sequential is correct only when each step **depends** on the previous, or you must rate-limit.

## The combinators

| Combinator | Settles when | Result |
|---|---|---|
| `Promise.all` | all fulfill / first rejects | array of values, **fail-fast** |
| `Promise.allSettled` | all settle | array of `{status, value/reason}` — never rejects |
| `Promise.race` | first **settles** | that value or rejection (timeouts) |
| `Promise.any` | first **fulfills** / all reject | first value, or `AggregateError` |

Use `allSettled` when you want every result even if some fail; `all` when any failure should abort the batch.

## The common mistakes

- **Floating promises** — calling an async function without `await`/`return`/`.catch`. Errors become unhandled rejections and the caller races ahead. Always consume the promise.
- **`forEach` with `async`** — `arr.forEach(async x => await f(x))` does **not** wait; `forEach` ignores the returned promises. Use `for...of` with `await` (sequential) or `Promise.all(arr.map(f))` (concurrent).
- **Mixing `await` and `.then`** for the same value — pick one style per function.
- **Swallowing errors** — `catch` that logs and continues hides failures; rethrow or handle meaningfully.
- **`new Promise` around a callback API** — fine, but resolve/reject exactly once and don't put `await` logic inside the executor. Many APIs (`fs.promises`, `fetch`, `setTimeout` via `timers/promises`) are already promise-based.

## Cancellation and timeouts

There's no built-in promise cancellation; use an `AbortController` (supported by `fetch`, many Node APIs). For a timeout, race against a rejecting timer or pass `AbortSignal.timeout(ms)`.

## How I use it

- `async`/`await` with `try/catch` as the default; `.then` chains only for short transforms.
- `Promise.all(items.map(fn))` for independent work; a plain `for...of` loop with `await` when steps depend on each other.
- I never leave a promise floating — `await` it, `return` it, or attach a `.catch`.
- `allSettled` for "do all of these and report what failed"; `AbortController`/`AbortSignal.timeout` for cancellation and deadlines.

## Links

- [MDN — Using Promises](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Using_promises)
- [MDN — async function](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/async_function)
