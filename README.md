# Toolbox

> A personal, product-agnostic toolbox: organized, validated, reusable dev assets I reach for across projects — snippets, configs, references, prompts, checklists, and playbooks.

This repo is **content, not a product.** Nothing here gets `npm install`ed or imported. You read it, copy out of it, or point a tool/agent at it. It's plain Markdown, browsed directly on GitHub (or in any editor) — every folder has a `README.md` index, and GitHub renders the prose and the raw config/snippet files without any build step.

## The folders

Each folder holds one **kind** of artifact. The full taxonomy — what goes where and the test for deciding — lives in [ARTIFACTS.md](ARTIFACTS.md). Quick map:

| Folder | What it holds | Shape |
|---|---|---|
| [references/](references/) | My own "how X works + how I use it" explainers | Read to learn |
| [resources/](resources/) | Curated, annotated links to external learning material | Go look it up |
| [snippets/](snippets/) | Small copy-and-adapt code/config fragments | Paste & tweak |
| [configs/](configs/) | Complete drop-in tool configs (eslint, tsconfig, etc.) | Use as-is |
| [prompts/](prompts/) | Reusable LLM / agent prompts and instructions | Send to a model |
| [checklists/](checklists/) | Binary "before-X-do-these" verification lists | Walk top-to-bottom |
| [playbooks/](playbooks/) | Multi-step procedures with branches & judgment | Follow a process |
| [scripts/](scripts/) | Repo automation (link validation) | Run from root |

## How to use it

- **Browse on GitHub** or in VS Code — every folder has a `README.md` index.
- **Copy what you need.** Snippets and configs are made to be lifted out.
- **Point a tool or agent at a path.** Prompts and references are written to be loaded into a Claude Code / LLM session.
- **Find where something goes** with the decision tree in [ARTIFACTS.md](ARTIFACTS.md) before adding to it.

## Scope of stacks/tools covered

Sharded by tool or language as content accumulates. Active areas reflect what I actually work in: Git/GitHub, Node/TypeScript/JavaScript, Python, Java, HTML/CSS, Bash/PowerShell, Windows/Linux, Docker/CI, VS Code, and Claude Code / LLM agents. Empty shards are created lazily — only when there's a real artifact to put in them.

## Validation

This repo is meant to stay trustworthy, so it validates itself:

- `node scripts/check-links.mjs` — fails if any internal Markdown link points at a missing file.
- CI runs the same check on every push (see [.github/workflows/validate.yml](.github/workflows/validate.yml)).

Run it locally before committing: `npm run check` (or `node scripts/check-links.mjs`).

## License

[MIT](LICENSE).
