# Git — resources

> Curated external material for learning and looking up Git. My own explainers on Git internals (objects/refs, reset modes, merge vs. rebase, line endings) are in [references/git/](../../references/git/); this catalog points outward.
>
> GitHub-platform material (PRs, Actions, the `gh` CLI) lives separately in `resources/github/`.

## Official docs & specs

- **[Git documentation](https://git-scm.com/doc)** — the canonical home for the reference manual, the book, and videos.
- **[Pro Git (2nd ed.)](https://git-scm.com/book/en/v2)** — the definitive free book by Chacon & Straub. Read the "Git Internals" chapter once; it makes every other command make sense.
- **[Git reference manual](https://git-scm.com/docs)** — per-command man pages (`git-rebase`, `git-reset`, …). Same content as `git help <command>` locally.
- **[Git glossary](https://git-scm.com/docs/gitglossary)** — precise definitions (ref, index, tree-ish, fast-forward) when terminology gets fuzzy.

## Learn

- **[Learn Git Branching](https://learngitbranching.js.org/)** — interactive, visual branching exercises in the browser. The fastest way to build an accurate mental model of merge/rebase/reset. Start here if the graph operations feel abstract.
- **[Atlassian Git tutorials](https://www.atlassian.com/git/tutorials)** — clear, well-illustrated topic guides (workflows, rewriting history, merging strategies).
- **[Software Carpentry: Version Control with Git](https://swcarpentry.github.io/git-novice/)** — a from-zero lesson aimed at people new to version control.

## Cheatsheets & quick-reference

- **[GitHub Git cheat sheet](https://training.github.com/downloads/github-git-cheat-sheet/)** — one-page command reference (PDF/printable, multiple languages).
- **[Interactive Git cheatsheet (ndpsoftware)](https://ndpsoftware.com/git-cheatsheet.html)** — shows which commands move data between workspace, index, local repo, and remote. Good for internalizing *where* each command acts.

## Tools & utilities

- **[Visualizing Git](https://git-school.github.io/visualizing-git/)** — type real commands and watch the commit graph update live. Useful for explaining or experimenting without a real repo.
- **[Oh My Git!](https://ohmygit.org/)** — an open-source game that teaches Git through a visual interface; good for beginners or for making branching tangible.

## When things go wrong (recovery)

- **[Oh Shit, Git!?!](https://ohshitgit.com/)** — the most common "I broke it" situations with copy-paste fixes. ([dangitgit.com](https://dangitgit.com/) is the identical, profanity-free mirror.)
- **[On undoing, fixing, or removing commits in git](https://sethrobertson.github.io/GitFixUm/fixup.html)** — a decision-flowchart for recovery scenarios, more thorough than the quick-fix sites.

## Conventions

- **[Conventional Commits](https://www.conventionalcommits.org/)** — the structured commit-message spec (`feat:`, `fix:`, scopes, breaking changes) that many changelog/release tools consume.

---

_Last checked: 2026-05. External links rot — see [maintenance notes](../README.md#maintenance)._
