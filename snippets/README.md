# `snippets/`

> Small, copy-and-adapt code/config fragments — too small to be a project, not complete enough to be a drop-in config. You paste them and tweak.

## What lives here

The granular layer. A snippet is:
- Small (a single file or a tight cluster of two or three).
- Self-contained — no dependency on anything else in this repo to use.
- Made to be pasted and modified; nobody tracks the derivatives.

Examples:
- `snippets/node/safe-write-file.ts` — atomic write-then-rename helper.
- `snippets/typescript/tsconfig-strict-block.json` — the `compilerOptions` block I splice into a project's `tsconfig`.
- `snippets/bash/strict-mode.sh` — `set -euo pipefail` + IFS header with notes.
- `snippets/powershell/argument-completer.ps1` — register a tab-completer.
- `snippets/web/css-reset.css` — minimal modern reset.

## What does NOT live here

| Type | Where it goes | Why |
|---|---|---|
| A *complete* drop-in config (whole `.eslintrc`, full `tsconfig`) | [configs/](../configs/) | Usable as-is, not a fragment |
| A prose explanation of the pattern | [references/](../references/) | Doctrine, not the code |
| Text you'd send to an LLM | [prompts/](../prompts/) | Different artifact |
| Something importable as a library with tests | (its own project) | If it runs and others depend on it, it's not a snippet |

The tests: **snippet vs. config = completeness** (fragment vs. drop-in). **Snippet vs. project = does anyone import it?** (paste-and-adapt vs. depend-on).

## How to add one

1. Pick the tool/language shard.
2. Keep it small; add a header comment saying what it does, what it needs, and when to use it.
3. For variants, suffix the name (`-strict`, `-minimal`).
4. No tests here — if it needs tests, it's outgrown a snippet.

## Sharding

By language/tool, lazily: `snippets/node/`, `snippets/typescript/`, `snippets/python/`, `snippets/java/`, `snippets/bash/`, `snippets/powershell/`, `snippets/web/`, `snippets/sql/`. Keep each file's natural extension.

## See also

- [ARTIFACTS.md](../ARTIFACTS.md) — taxonomy.
- [configs/](../configs/) — for complete drop-in configs.
- [references/](../references/) — for the *why* behind a pattern.
