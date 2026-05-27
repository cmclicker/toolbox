# Semantic versioning (semver)

**TL;DR:** A semver version is `MAJOR.MINOR.PATCH`: bump MAJOR for breaking changes, MINOR for backward-compatible features, PATCH for backward-compatible fixes. Dependency ranges use this contract — `^1.2.3` accepts compatible updates up to (not including) `2.0.0`; `~1.2.3` accepts only patch updates. The lockfile pins the exact resolved version regardless of the range.

## The version number

`MAJOR.MINOR.PATCH` (e.g. `2.4.1`):

- **MAJOR** — incompatible/breaking API changes.
- **MINOR** — new functionality, backward-compatible.
- **PATCH** — backward-compatible bug fixes.

Pre-release/build suffixes: `1.0.0-rc.1`, `1.0.0-beta`. A pre-release is considered *lower* than its release (`1.0.0-rc.1` < `1.0.0`).

**`0.x` is special:** the spec treats pre-1.0 as "anything may change." npm reflects this — `^0.2.3` allows `0.2.x` but **not** `0.3.0` (a `0.MINOR` bump is treated as potentially breaking). Don't assume `0.x` deps are stable.

## Range operators (what npm installs)

| Range | Allows | Example: matches |
|---|---|---|
| `^1.2.3` | compatible: `>=1.2.3 <2.0.0` | 1.2.4, 1.5.0 — not 2.0.0 |
| `~1.2.3` | patch only: `>=1.2.3 <1.3.0` | 1.2.9 — not 1.3.0 |
| `1.2.3` | exactly that version | only 1.2.3 |
| `1.x` / `1.*` | any 1.minor.patch | 1.9.9 — not 2.0.0 |
| `>=1.2.3` | that or higher | any newer |
| `*` / `latest` | anything | newest (avoid) |
| `1.2.3 - 1.5.0` | inclusive range | within bounds |

**`^` is npm's default** when you `npm install pkg` — it accepts minor+patch updates, trusting that the publisher follows semver. `~` is more conservative (patch only).

For `^0.x` the caret degrades to "patch within the same minor" as noted above — a frequent surprise.

## Ranges vs. the lockfile

The range in `package.json` says what's *acceptable*; the lockfile records what was *actually resolved*. With `^1.2.3` and a lockfile pinning `1.4.0`, `npm ci` always installs `1.4.0` — the range only matters when the lockfile is regenerated (`npm install`, `npm update`). This is why committing the lockfile is what actually makes installs reproducible ([npm-and-dependencies.md](npm-and-dependencies.md)).

## Choosing what to publish / depend on

- **Publishing:** bump honestly — a breaking change is a MAJOR even if it feels small, because consumers' `^` ranges will auto-adopt anything below the next major. `npm version major|minor|patch` bumps and tags ([../../playbooks/github/ship-a-release.md](../../playbooks/github/ship-a-release.md)).
- **Depending:** `^` is a reasonable default for well-behaved libraries; pin exact (`save-exact`) for apps where you want zero surprise and rely on deliberate updates; be wary of `^0.x`.

## How I use it

- `^` for library deps that follow semver; exact pins (via `.npmrc` `save-exact=true`) for app dependencies I want fully controlled.
- Treat `0.x` deps as potentially-breaking on any minor bump.
- Bump honestly when publishing — MAJOR for anything breaking — since consumers auto-adopt within their range.
- Trust the lockfile, not the range, for what's actually installed.

## Links

- [Semantic Versioning spec](https://semver.org/)
- [npm semver calculator](https://semver.npmjs.com/) — paste a range, see what it matches
