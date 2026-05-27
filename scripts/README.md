# `scripts/`

> Repo automation. Machinery that runs — not content. Invoked from the repo root.

`scripts/` is the only folder that isn't part of the [artifact taxonomy](../ARTIFACTS.md): it doesn't hold reusable assets, it maintains them. Keep scripts dependency-free where possible (plain Node `.mjs`) so the repo needs no install to validate itself.

## Conventions

- **Plain `.mjs`, zero deps** is the default. If a script needs real dependencies, reconsider whether it belongs here.
- **Wire each script through `npm run`** so the canonical interface is the script name (`npm run check`), not the file path.

## Current scripts

| Script | What it does | Run via |
|---|---|---|
| `check-links.mjs` | Fails if any internal Markdown link points at a missing file. Run before committing; CI runs it on every push. | `npm run check` |

## See also

- [ARTIFACTS.md](../ARTIFACTS.md) — why `scripts/` sits outside the taxonomy.
- [.github/workflows/validate.yml](../.github/workflows/validate.yml) — the CI job that runs the validator.
