# Artifact taxonomy

> The one rule this repo enforces: **every file has exactly one right home.** This document is the map and the decision procedure. When you're unsure where something goes, the tree below answers it. Every folder `README.md` links back here.

## The eight kinds

| Kind | Folder | One-line test |
|---|---|---|
| Reference | [references/](references/) | My *own* written explanation of how something works. |
| Resource | [resources/](resources/) | A curated, annotated list of *external* material to learn from or look up. |
| Snippet | [snippets/](snippets/) | A small fragment you paste into a project and adapt. |
| Config | [configs/](configs/) | A *complete* tool config, usable with no further editing. |
| Prompt | [prompts/](prompts/) | Text you'd literally send to an LLM / agent. |
| Checklist | [checklists/](checklists/) | A list of binary yes/no verifications. |
| Playbook | [playbooks/](playbooks/) | A multi-step procedure with branches or judgment calls. |
| Script | [scripts/](scripts/) | Machinery that runs (validation, generation). Not "content." |

## Decision tree

Ask these in order; stop at the first yes.

1. **Does it run / execute as automation for this repo?** → `scripts/`
2. **Is it text you'd send to an LLM or agent?** → `prompts/`
3. **Is it a list of binary yes/no checks?** → `checklists/`
4. **Is it a multi-step procedure with branches or judgment?** → `playbooks/`
5. **Is it code/config you'd paste and adapt?**
   - It's a *complete* drop-in config for a tool (needs no edits) → `configs/`
   - It's a *fragment* you paste and modify → `snippets/`
6. **Is it about a topic — understanding it or finding material on it?**
   - A curated list of *external* links/materials (docs, courses, cheatsheets, tools) → `resources/`
   - My *own* written explanation of how it works or how I use it → `references/`

## The distinctions that actually trip people up

- **Snippet vs. config** — *completeness*. A whole `.eslintrc` that works as-is → `configs/`. A `compilerOptions` block you splice into a `tsconfig` → `snippets/`.
- **Checklist vs. playbook** — *shape*. Pure binary verifications with no branching → `checklists/`. Anything with "if A do X, else do Y" or steps needing judgment → `playbooks/`.
- **Reference vs. checklist/playbook** — *intent*. A reference explains so you understand; a checklist/playbook drives an action you perform.
- **Prompt vs. reference** — a prompt is sent to a model; a reference (even one *about* prompting) is read by a human.
- **Reference vs. resource** — *authorship*. A reference is content I wrote (my explanation, my distillation). A resource points at someone else's material (an annotated link). A reference may *cite* resources in a "Links" section; a resource entry is *nothing but* curated, annotated pointers. If the value is the prose, it's a reference; if the value is the curation, it's a resource.

## Sharding

Within a folder, shard by **tool or language** as content grows — `references/git/`, `snippets/node/`, `configs/eslint/`, `prompts/code-review/`. Don't pre-create empty shards; add a shard the first time it has a real file. File names are kebab-case and describe the thing, not the date (`rebase-recovery.md`, not `notes-2026-05.md`).

## What this repo deliberately does NOT hold

- **Importable libraries / runnable packages.** If it has a `src/` and tests and you'd depend on it, it's its own project, not a toolbox entry.
- **Project-specific files.** One-off configs or runbooks tied to a single product live in that product's repo. Only the *reusable* distillation comes here.
- **Secrets, credentials, machine-specific paths.** Sanitize before it lands here.

## Adding something

1. Run the decision tree → pick the folder.
2. Pick or create the tool/language shard.
3. Add the file with a short header comment or intro explaining what it is and when to use it.
4. If the folder's README has an index/"active" section, add an entry.
5. Run `npm run check` (or `node scripts/check-links.mjs`) so no dead links ship.
