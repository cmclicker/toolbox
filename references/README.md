# `references/`

> Notes, cheatsheets, and "how X works + how I actually use it" writeups. Read to learn or refresh — not copied wholesale.

## What lives here

Long-form explanatory content: the distilled version of something I figured out once and don't want to re-derive. After reading docs, debugging a subtle issue, or learning a tool, the durable understanding lands here so future-me (or a Claude session) can reload it fast.

Examples of what fits:
- `references/git/rebase-recovery.md` — what reflog actually does and how to undo a bad rebase.
- `references/node/package-json.md` — field-by-field, with the conventions I follow.
- `references/typescript/strictness-flags.md` — what each strict flag buys you.
- `references/bash/parameter-expansion.md` — the `${var%/*}` family, explained.
- `references/llm/prompt-patterns.md` — prompting doctrine in my own words.

## What does NOT live here

| Type | Where it goes | Why |
|---|---|---|
| A fragment you paste into a project | [snippets/](../snippets/) | It's code to reuse, not an explanation |
| A complete drop-in tool config | [configs/](../configs/) | Same — a usable artifact, not doctrine |
| A binary verification list | [checklists/](../checklists/) | A reference explains; a checklist verifies |
| A step-by-step procedure | [playbooks/](../playbooks/) | Narrative *process* vs. narrative *understanding* |
| Text you send to an LLM | [prompts/](../prompts/) | Even prompting *notes* differ from a usable prompt |

The test: **does this explain understanding rather than drive an action?** If yes → here.

## Shape of an entry

1. One-paragraph TL;DR at the top.
2. The explanation (sections as needed; length is fine — a reference can be a small essay).
3. "How I use it" — the bridge from general knowledge to my actual practice.
4. External links that informed it (docs, posts, papers).

## Sharding

By tool or domain, created lazily: `references/git/`, `references/node/`, `references/typescript/`, `references/python/`, `references/java/`, `references/web/` (HTML/CSS), `references/bash/`, `references/powershell/`, `references/windows/`, `references/linux/`, `references/docker/`, `references/ci/`, `references/vscode/`, `references/llm/`. File names are kebab-case nouns.

## See also

- [ARTIFACTS.md](../ARTIFACTS.md) — the taxonomy and decision tree.
- [snippets/](../snippets/) — when the thing is code to paste, not prose to read.
