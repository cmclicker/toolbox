# `resources/`

> Curated, annotated links to **external** learning material — the websites, docs, courses, cheatsheets, and tools worth going to for a topic. The value here is the curation and the annotation, not the prose.

## What lives here

A vetted catalog, organized by topic. Each entry is a link plus a one-line annotation saying **what it is and when to reach for it** — enough that you can pick the right resource without opening five tabs. Think "the good bookmarks, with notes."

Examples:
- `resources/git/` — official Git docs, the Pro Git book, interactive learners, recovery sites, cheatsheets.
- `resources/typescript/` — the handbook, the playground, type-challenge collections.
- `resources/llm/` — model docs, prompt libraries, eval tooling.

## What does NOT live here

| Type | Where it goes | Why |
|---|---|---|
| My own written explanation of a topic | [references/](../references/) | That's authored prose, not a link to someone else's material |
| A fragment I paste into a project | [snippets/](../snippets/) | Reusable code, not a pointer |
| A complete drop-in config | [configs/](../configs/) | A usable artifact, not a link |

The test: **is the value the curation of external material, or content I wrote?** External links I've vetted and annotated → here. Prose I authored → [references/](../references/). A reference may end with a short "Links" section; a resource entry is *entirely* annotated links. See the reference-vs-resource note in [ARTIFACTS.md](../ARTIFACTS.md).

## Shape of a catalog

Each topic is a folder with a `README.md` that **is** the catalog, organized into sections by material type. Standard sections (include the ones that apply; omit the rest):

- **Official docs & specs** — the authoritative primary sources.
- **Learn** — courses, guided tutorials, recommended books.
- **Cheatsheets & quick-reference** — dense lookup material.
- **Tools & utilities** — playgrounds, validators, visualizers, generators.
- **Domain-specific** — whatever else fits this topic (e.g. for Git: interactive history visualizers and "undo my mistake" sites; for a language: style guides; for LLMs: prompt libraries).

Each link is `**[Title](url)** — one line on what it is and when to use it.` Mark anything paid, account-walled, or version-specific.

## Maintenance

External links rot. Keep entries trustworthy:

- Prefer **stable, authoritative** sources (official docs, canonical books) over individual blog posts, which move or vanish.
- Note "last checked YYYY-MM" at the bottom of a catalog when you verify it.
- When a link dies, replace it with the current home or remove it — a dead link in a "curated" list defeats the point.
- The repo's `npm run check` validates **internal** links only; external URLs are not auto-checked, so curate conservatively.

## Sharding

By tool or domain, mirroring [references/](../references/): `resources/git/`, `resources/github/`, `resources/typescript/`, `resources/python/`, `resources/docker/`, `resources/llm/`, etc. Created lazily — a shard appears when it has a real catalog.

## See also

- [ARTIFACTS.md](../ARTIFACTS.md) — taxonomy and the reference-vs-resource distinction.
- [references/](../references/) — my own authored explainers (which cite resources from here).
