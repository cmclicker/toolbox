# `configs/`

> Complete, drop-in tool configs. A file here **is** a working config for some tool — copy it in or `extends` it, no further editing required.

## What lives here

Files that are the whole config, not a fragment. The distinction from [snippets/](../snippets/) is completeness: if you can drop it into a project and the tool just works, it's a config.

Examples:
- `configs/typescript/node-strict.json` — strict `tsconfig` for Node.
- `configs/eslint/base.mjs` — base ESLint flat config.
- `configs/prettier/default.json` — canonical Prettier config.
- `configs/gitignore/node.gitignore` — Node `.gitignore`.
- `configs/editorconfig/default.editorconfig` — EditorConfig.
- `configs/vscode/settings.shared.json` — VS Code settings I reuse across projects.
- `configs/docker/node.dockerfile` — a complete Node Dockerfile.

## What does NOT live here

| Type | Where it goes | Why |
|---|---|---|
| A fragment of a config (one block) | [snippets/](../snippets/) | Incomplete — needs composing |
| Prose about what a config option does | [references/](../references/) | Explanation, not the file |
| A whole project scaffold | (its own project / starter) | Multi-file, not a single config |

The test: **is this file enough, on its own, to be the actual config for a tool?** Yes → here. Needs another file to compose → `snippets/`.

## How to add one

1. Find (or create) the tool's shard — `configs/<tool>/`.
2. Write it as a complete, drop-in file with the tool's expected name/extension.
3. Add a header comment (or shard `README.md`): when to use this variant, what it extends, any compatibility constraints.

## Sharding

By **tool**, not ecosystem — a `tsconfig` always lives under `configs/typescript/`, never `configs/node/`. Lazily created: `configs/typescript/`, `configs/eslint/`, `configs/prettier/`, `configs/gitignore/`, `configs/editorconfig/`, `configs/vscode/`, `configs/docker/`, `configs/github/` (Actions workflows worth reusing).

## See also

- [ARTIFACTS.md](../ARTIFACTS.md) — taxonomy.
- [snippets/](../snippets/) — for config *fragments*.
