// A Result<T, E> type: model success/failure as data instead of throwing, so the
// caller must handle both cases (the compiler enforces it via narrowing on `ok`).
// Reference: ../../references/typescript/narrowing-and-guards.md

export type Result<T, E = Error> =
  | { ok: true; value: T }
  | { ok: false; error: E };

export const ok = <T>(value: T): Result<T, never> => ({ ok: true, value });
export const err = <E>(error: E): Result<never, E> => ({ ok: false, error });

/** Wrap a throwing function into a Result. */
export function tryCatch<T>(fn: () => T): Result<T> {
  try {
    return ok(fn());
  } catch (e) {
    return err(e instanceof Error ? e : new Error(String(e)));
  }
}

// --- Usage -----------------------------------------------------------------
// const r = tryCatch(() => JSON.parse(input));
// if (r.ok) {
//   r.value;          // narrowed to the success type
// } else {
//   r.error.message;  // narrowed to the error type — both paths must be handled
// }
