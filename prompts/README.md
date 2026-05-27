# `prompts/`

> Reusable LLM / agent prompts and instructions. The actual text you'd send to a model — or a template with `{{variables}}`.

## What lives here

Prompts I reuse across Claude Code sessions and other agentic workflows: system prompts, task prompts, and reusable instruction fragments.

Examples:
- `prompts/code-review/strict.md` — system prompt for a thorough diff review.
- `prompts/generate/readme-from-code.md` — "write a README for this project."
- `prompts/refactor/extract-and-test.md` — drive a refactor + test pass.
- `prompts/explain/eli-senior-dev.md` — explain a concept at the right depth.
- `prompts/agent/repo-audit.md` — assess whether a repo is structured for its stated purpose.

Each file is the text you'd literally paste/send, with variables marked `{{like-this}}`.

## What does NOT live here

| Type | Where it goes | Why |
|---|---|---|
| Prose *about* prompt engineering | [references/llm/](../references/) | Explains, isn't itself a prompt |
| A one-line prompt fragment used inside code | [snippets/](../snippets/) | Too small; lives with the code |
| A checklist an agent walks | [checklists/](../checklists/) | Verification list, not a prompt |

The test: **is this text you'd literally send to an LLM?** Yes → here.

## Shape of a file

1. Optional frontmatter — intended model, variables, expected output shape.
2. The prompt itself.
3. Usage notes at the bottom — when to use it, what good output looks like.

## Versioning

When a prompt changes meaningfully, add a `## Changelog` note rather than silently editing; for breaking changes use a versioned filename (`strict.v2.md`).

## Sharding

By purpose, lazily: `prompts/code-review/`, `prompts/generate/`, `prompts/refactor/`, `prompts/explain/`, `prompts/agent/`, `prompts/system/`. Top-level for prompts that don't fit a shard.

## See also

- [ARTIFACTS.md](../ARTIFACTS.md) — taxonomy.
- [references/](../references/) — for prompt-engineering doctrine.
