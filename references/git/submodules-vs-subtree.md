# Submodules vs. subtree (vendoring another repo)

**TL;DR:** Both let one repo include another. A **submodule** stores a *pointer* (a commit hash) to an external repo cloned into a subdirectory — the outer repo records "which commit," not the code. A **subtree** copies the other repo's files *into* your repo's history. Submodules keep histories separate and pin versions but add per-clone ceremony; subtrees make consumption transparent at the cost of a heavier merge process. For most cases, prefer a real package manager over either.

## Submodules

The outer repo stores a gitlink: a special tree entry recording the path and the exact commit of the inner repo, plus a `.gitmodules` file with the URL. The inner repo's files are *not* in the outer repo's history — only the pointer is.

```bash
git submodule add https://example.com/lib.git vendor/lib
git clone --recurse-submodules <repo>      # clone and populate submodules
git submodule update --init --recursive     # populate after a normal clone
# update the pinned commit:
cd vendor/lib && git checkout <newer> && cd ../..
git add vendor/lib && git commit -m "Bump lib"
```

- **Strengths:** exact version pinning; clean separation of histories; the inner repo stays an independent repo you can push to.
- **Costs:** every clone needs `--recurse-submodules` or a follow-up `update`; contributors routinely forget and get empty directories; detached-HEAD state inside the submodule confuses people; updating is a two-step commit dance.

## Subtree

`git subtree` merges the other repo's contents into a subdirectory of yours, bringing its files (and optionally history) into your repo. There's no pointer and no `.gitmodules`; clones "just work" with no extra commands.

```bash
git subtree add --prefix vendor/lib https://example.com/lib.git main --squash
git subtree pull --prefix vendor/lib https://example.com/lib.git main --squash
git subtree push --prefix vendor/lib https://example.com/lib.git main
```

- **Strengths:** invisible to consumers (normal clone gets everything); no special clone flags; the subdir is just files.
- **Costs:** the outer history grows with the vendored code; the `subtree` commands are verbose and easy to get wrong; contributing changes back upstream is more manual.

## Decision

| Want | Use |
|---|---|
| A dependency with versions | **a package manager** (npm, pip, Maven, Cargo…) — first choice |
| To pin an exact external commit, keep histories separate, push back upstream | **submodule** |
| Consumers to clone normally with zero extra steps; vendoring code you rarely change | **subtree** |
| A monorepo of code you control | just put it in the repo; neither tool needed |

The honest default: if the thing is a published dependency, a package manager beats both. Reach for submodule/subtree only for source you must vendor directly (a fork you patch, a non-packaged dependency, tightly-coupled internal repos).

## How I use it

- Package manager whenever the dependency is published — avoids both tools entirely.
- **Submodule** when I need a separate-but-pinned repo I also push to, and I accept the clone ceremony (and document `--recurse-submodules` in the README).
- **Subtree** when consumers must clone with no extra steps and the vendored code changes rarely.

## Links

- [Pro Git — Submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules)
- [`git subtree` docs](https://git-scm.com/docs/git-subtree)
