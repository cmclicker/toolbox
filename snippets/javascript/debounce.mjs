// debounce + throttle — the two rate-limiters you reach for constantly, with no
// dependency (lodash not needed for the common case). Pure language; runs in any
// modern runtime. Concepts: ../../references/javascript/this-call-apply-bind.md
//   debounce: run fn only after `wait` ms of quiet (search input, resize, autosave)
//   throttle: run fn at most once per `wait` ms (scroll, mousemove, rAF-ish work)

/** Delay calling `fn` until `wait` ms after the last call. Returns a cancelable wrapper. */
export function debounce(fn, wait) {
  let timer;
  function debounced(...args) {
    clearTimeout(timer);
    // arrow keeps `this` from the call site so it works as a method, too
    timer = setTimeout(() => fn.apply(this, args), wait);
  }
  debounced.cancel = () => clearTimeout(timer);
  return debounced;
}

/** Call `fn` at most once per `wait` ms (leading edge), ignoring calls in between. */
export function throttle(fn, wait) {
  let last = 0;
  let timer;
  return function throttled(...args) {
    const now = Date.now();
    const remaining = wait - (now - last);
    if (remaining <= 0) {
      last = now;
      fn.apply(this, args);
    } else if (!timer) {
      // ensure the trailing call still fires once the window elapses
      timer = setTimeout(() => {
        last = Date.now();
        timer = undefined;
        fn.apply(this, args);
      }, remaining);
    }
  };
}

// --- demo (run: node debounce.mjs) ---
if (import.meta.url === `file://${process.argv[1]}`) {
  const log = debounce((msg) => console.log("debounced:", msg), 50);
  log("a"); log("b"); log("c"); // only "c" fires, ~50ms later
}
