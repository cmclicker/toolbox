# Checklist: before `npm publish`

> Walk this before publishing a package to the npm registry. Each item is yes/no; a publish is hard to undo (unpublish is restricted), so treat it like a release. Concepts: [../../references/node/package-json.md](../../references/node/package-json.md), [../../references/node/semver.md](../../references/node/semver.md).

## Contents (blocking)

- [ ] `npm pack --dry-run` reviewed — the file list and size are what you intend (no `src/`, tests, `.env`, or scratch files unless deliberate).
- [ ] `files` allowlist in `package.json` (or `.npmignore`) limits the tarball to what consumers need (usually `dist`).
- [ ] `main`/`exports` point at the **built** output that exists in the tarball, with `types` first in each `exports` conditions block.
- [ ] Build ran and `dist` is current (`prepublishOnly`/`prepare` script wired so it can't be forgotten).

## Correctness (blocking)

- [ ] `version` bumped per semver — MAJOR for any breaking change (consumers' `^` ranges auto-adopt below the next major).
- [ ] Tests, typecheck, and lint pass.
- [ ] `dependencies` vs `devDependencies` correct — no build/test tooling in `dependencies`, no runtime need in `devDependencies`.
- [ ] Type declarations included and resolve (`tsc --noEmit` against a consumer, or `arethetypeswrong`/`publint` if available).

## Metadata (blocking)

- [ ] `name` is available/owned (and scope set if scoped); `license` set; `repository`/`homepage` point at the right place.
- [ ] README reflects the version's actual API.
- [ ] `engines.node` reflects what's actually supported.

## Publish (blocking)

- [ ] Logged in to the right registry/account (`npm whoami`).
- [ ] Correct access for scoped packages (`--access public` for a public `@scope/...`).
- [ ] Dist-tag intended: `--tag next`/`beta` for pre-releases so they don't become `latest`.
- [ ] For a real release, prefer `npm version <bump>` (commits + tags) then `npm publish` — keeps git and the registry in sync ([../../playbooks/github/ship-a-release.md](../../playbooks/github/ship-a-release.md)).

## After

- [ ] `npm view <pkg>` shows the new version; a fresh `npm install <pkg>` in a scratch dir works.
- [ ] Git tag pushed; GitHub release notes written if you use them.
