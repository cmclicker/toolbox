# Playbook: troubleshoot npm dependency problems

> **Trigger:** install fails, the wrong version is resolved, `node_modules` is in a weird state, or "works on my machine" but not in CI. Est. time: 5–20 min. Concepts: [../../references/node/npm-and-dependencies.md](../../references/node/npm-and-dependencies.md), [../../references/node/semver.md](../../references/node/semver.md).

## Step 1 — Reproduce cleanly

Half of dependency weirdness is a stale `node_modules`. Reset to a clean, lockfile-faithful state:

```bash
rm -rf node_modules
npm ci            # strict install from package-lock.json (errors if lock is out of sync)
```

If `npm ci` itself errors that the lockfile is out of sync with `package.json`, that's the bug — someone changed `package.json` without updating the lock. `npm install` once to reconcile, then commit the lockfile.

## Step 2 — Identify the actual problem

| Symptom | Likely cause / fix |
|---|---|
| `ERESOLVE` peer dependency conflict | a package's `peerDependencies` aren't satisfied. See Step 3. |
| Wrong version installed | a range resolved higher than expected, or a transitive dep. `npm ls <pkg>` to see who pulls it. |
| `Cannot find module 'x'` | not installed, or it's a transitive dep you're importing directly (declare it explicitly). |
| Works locally, fails in CI | local `node_modules` is stale vs. lockfile; CI uses `npm ci`. Reproduce with Step 1. |
| Native build errors (`node-gyp`) | a package compiles native code; needs build tools / a matching Node version. |
| Different Node version | check `node -v` against `engines`; use the version manager ([../../references/node/versions-and-managers.md](../../references/node/versions-and-managers.md)). |

## Step 3 — Inspect the tree

```bash
npm ls <pkg>            # every path that depends on <pkg>, and the versions
npm ls <pkg> --all      # full tree
npm explain <pkg>       # why is this here? (who required it)
npm outdated            # what's behind its latest
```

`npm explain <pkg>` answers "why do I even have this / why this version" — the fastest way to understand a surprising dependency.

## Step 4 — Resolve a peer-dependency (`ERESOLVE`) conflict

1. Read the conflict: which package wants which peer version, and what you have.
2. **Preferred:** align the versions — upgrade/downgrade the offending package or the peer so they genuinely agree. Check each package's supported peer range.
3. If it's a known-compatible mismatch the maintainer hasn't updated, `npm install --legacy-peer-deps` (ignore peer conflicts) or pin an `overrides` entry in `package.json` — but understand you're overriding a stated constraint.
4. Avoid `--force` — it can produce a broken tree.

## Step 5 — Pin or override a transitive version

To force a nested dependency's version (e.g. for a security fix not yet released upstream), use `overrides` in `package.json`:

```jsonc
"overrides": { "vulnerable-pkg": "1.2.4" }
```

Then `rm -rf node_modules package-lock.json && npm install` to rebuild the tree, and verify with `npm ls vulnerable-pkg`.

## Step 6 — Verify

```bash
npm ci && npm test       # clean install + tests pass
npm ls <pkg>             # the version is what you intended now
```

Commit the updated `package-lock.json` so everyone (and CI) gets the fixed tree.

## Nuclear option (when truly stuck)

```bash
rm -rf node_modules package-lock.json
npm install
```

This rebuilds the lockfile from scratch against current `package.json` ranges. Use sparingly — it can pull newer versions within your ranges; re-run tests and review the lockfile diff before committing.

## How I use it

`rm -rf node_modules && npm ci` first (reproduce clean) → `npm explain <pkg>` / `npm ls` to understand → fix by aligning versions (not `--force`), `overrides` for transitive pins → `npm ci && npm test` → commit the lockfile.
