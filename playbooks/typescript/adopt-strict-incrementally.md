# Playbook: adopt `strict` on an existing codebase

> **Trigger:** an existing JS or loosely-typed TS project where flipping `"strict": true` produces hundreds of errors at once. Est. time: hours to weeks, spread out. Goal: ratchet strictness up without a giant unreviewable change. Concepts: [../../references/typescript/strictness-flags.md](../../references/typescript/strictness-flags.md).

## Principle: ratchet, don't flip

Turning on all of `strict` at once on a large codebase buries you in errors and produces an unmergeable PR. Instead, enable one flag at a time, fix the fallout, merge, repeat — each step is small and reviewable, and the bar never moves backward.

## Step 1 — Get onto TypeScript at all (if it's still JS)

```jsonc
{ "compilerOptions": { "allowJs": true, "checkJs": false, "strict": false } }
```

Compile/check the JS as-is first (no strictness), so you have a green baseline before tightening anything.

## Step 2 — Enable the flags in order of value

Turn on **one** flag, fix errors, commit, move to the next. Suggested order (cheapest wins first, highest-value core last):

1. `noImplicitAny` — annotate the things that were silently `any`.
2. `strictNullChecks` — **the big one**; handle `null`/`undefined`. Usually the largest batch of fixes; consider doing it directory-by-directory (below).
3. `strictFunctionTypes`, `strictBindCallApply`, `strictPropertyInitialization` — usually smaller.
4. Then the extras: `noUncheckedIndexedAccess`, `noImplicitReturns`, `noFallthroughCasesInSwitch`.

Once they're all on, replace the individual flags with `"strict": true` plus the extras.

## Step 3 — Scope `strictNullChecks` if it's huge

If one flag (usually `strictNullChecks`) yields too many errors to fix in one PR:

- **By area:** fix the errors folder-by-folder across several PRs, keeping the flag on. (All-or-nothing per compile, so you can't half-enable a flag — but you can land the fixes incrementally while the flag stays on once the count is manageable.)
- **Triage tool:** temporarily mark unfixed lines with `// @ts-expect-error <ticket>` (preferred over `@ts-ignore` — it errors if the problem is later fixed, so it can't go stale silently), then burn down the list. Grep for them to track remaining debt.
- Avoid blanket `any` casts to silence errors — that defeats the purpose; fix or `@ts-expect-error` with a note.

## Step 4 — Prevent backsliding

- Add `tsc --noEmit` to CI as a required check ([../../references/github/branch-protection-and-rulesets.md](../../references/github/branch-protection-and-rulesets.md)) so new code can't reintroduce errors.
- Enable an ESLint rule to ban new `any` / unchecked `@ts-ignore` (the tooling domain covers `typescript-eslint`).
- Track remaining `@ts-expect-error` count; it should only go down.

## Step 5 — Finish

```jsonc
{ "compilerOptions": { "strict": true, "noUncheckedIndexedAccess": true } }
```

Remove the now-redundant individual flags. Confirm CI is green and the `@ts-expect-error` debt is gone (or down to a tracked, justified minimum).

## How I use it

`allowJs` baseline → enable flags one at a time (`noImplicitAny` → `strictNullChecks` → rest), fixing and merging each → `@ts-expect-error <ticket>` (never blanket `any`) for what can't be fixed yet → `tsc --noEmit` required in CI so it can't regress → collapse to `strict: true` at the end.
