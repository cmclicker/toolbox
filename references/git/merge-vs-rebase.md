# Merge vs. rebase

**TL;DR:** Both integrate one branch's changes into another. `merge` records a new commit with two parents, preserving the actual history. `rebase` re-creates your commits on top of a new base, producing a linear history but changing their hashes. Merge for shared/published branches; rebase for cleaning up local work before sharing.

## What each does

Starting from this divergence — `main` advanced after you branched `feature`:

```
A---B---C  main
     \
      D---E  feature
```

**`git merge main`** (run on `feature`) creates a merge commit `M` whose parents are `E` and `C`:

```
A---B---C  main
     \   \
      D---E---M  feature
```

History is preserved exactly. `D` and `E` keep their original hashes. The cost is a non-linear graph and an extra commit.

**`git rebase main`** (run on `feature`) replays `D` and `E` as new commits `D'` and `E'` on top of `C`:

```
A---B---C  main
         \
          D'---E'  feature
```

History is linear, as if you had branched from `C` all along. The cost is that `D'`/`E'` are **new objects with new hashes** — the originals `D`/`E` become unreachable.

## The one rule that prevents pain

**Do not rebase commits that exist outside your local repository.** Rebasing rewrites hashes; anyone who already has the old commits now has a diverged history, and the next `git pull` produces duplicate commits and conflicts. Rebase only commits that are still local and unpushed (or on a branch you alone use).

Merge is always safe for shared history because it adds a commit rather than rewriting existing ones.

## Fast-forward: the third outcome

If the target branch has not advanced since you branched, there is nothing to merge — Git can just move the branch ref forward. This is a **fast-forward** and produces no merge commit:

```bash
git merge --ff-only main   # succeed only if a fast-forward is possible, else stop
git merge --no-ff feature  # always create a merge commit, even when ff is possible
```

`--no-ff` is used to keep a visible record that a feature branch existed; `--ff-only` is used to refuse unexpected divergence.

## `git pull` is merge-or-rebase

`git pull` = `git fetch` + integrate. The integration step is a merge by default, which is why a pull on a diverged branch creates merge commits. To make pulls rebase instead:

```bash
git config --global pull.rebase true   # pull = fetch + rebase
git config --global pull.ff only       # pull only when fast-forward; otherwise stop and let you decide
```

`pull.ff only` is the most predictable default: it never silently creates a merge or rewrites; it stops and makes you choose.

## Interactive rebase

`git rebase -i <base>` opens an editor listing the commits to replay, where you can `reword`, `squash`/`fixup`, `edit`, `drop`, or reorder them. This is the standard way to clean up a messy local branch before opening a PR — squash "wip" commits, fix a message, drop a debug commit. It is a history rewrite, so the same "local-only" rule applies.

## How I use it

- **Integrating an updated `main` into a long-lived feature branch I share** → `merge`.
- **Tidying my own unpushed commits before a PR** → `rebase -i`.
- **Keeping a personal branch current with `main`** → `rebase main` (mine alone, safe to rewrite).
- **Default pull behavior** → `pull.ff only`, and rebase or merge deliberately when it stops.
- Never `rebase` or force-push a branch teammates build on.

## Links

- [Pro Git — Rebasing](https://git-scm.com/book/en/v2/Git-Branching-Rebasing)
- [Pro Git — Basic Branching and Merging](https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging)
