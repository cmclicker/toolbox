# `git stash`

**TL;DR:** `git stash` sets aside uncommitted changes (tracked, modified files by default) and returns your working tree to a clean `HEAD`, so you can switch context. The stash is a LIFO stack of saved states you re-apply later with `pop` (apply + remove) or `apply` (apply + keep). Stashes are local and not pushed.

## Core commands

```bash
git stash push -m "wip: refactoring auth"   # save tracked changes with a label
git stash                                   # same, no label (push is implied)
git stash list                              # stack: stash@{0} is the most recent
git stash show -p stash@{0}                 # view a stash as a diff
git stash pop                               # apply stash@{0} and drop it
git stash apply stash@{1}                   # apply a specific stash, keep it on the stack
git stash drop stash@{0}                    # delete one stash
git stash clear                             # delete all stashes
```

## What gets stashed (and what doesn't)

By default `git stash` saves **tracked** files that are modified or staged. It does **not** include untracked or ignored files unless told:

```bash
git stash -u    # --include-untracked: also stash untracked files
git stash -a    # --all: also stash ignored files (rarely wanted)
```

A common surprise: stashing before a checkout, then finding a brand-new file still present — because it was untracked and `-u` wasn't passed. If a new file should travel with the stash, use `-u`.

## Useful variants

```bash
git stash push -p                 # interactively choose hunks to stash (leave the rest)
git stash push path/to/file       # stash only specific paths
git stash branch newbranch        # create a branch from HEAD-at-stash-time and pop onto it
```

`git stash branch` is the clean fix when a stash no longer applies because `HEAD` moved: it recreates the original base, so the stash applies without conflicts.

## How it's stored

A stash is implemented as commits (a WIP commit, plus one for the index, plus one for untracked when `-u`), reachable from `refs/stash`. That's why a dropped stash can sometimes be recovered through the reflog (`git fsck --no-reflogs | grep commit` or `git stash list` history) — though stashes expire from gc faster than branch commits, so don't rely on it.

## Conflicts on pop

If the working tree changed since stashing, `pop` can conflict. Resolve the conflict markers as usual ([../../playbooks/git/resolve-merge-conflict.md](../../playbooks/git/resolve-merge-conflict.md)); note that a **conflicting `pop` does not drop the stash**, so you can retry. After resolving, `git stash drop` it manually.

## How I use it

- Quick context switch (urgent fix on another branch) → `git stash` (or `-u` if new files matter), switch, return, `git stash pop`.
- For anything I'll keep for more than a few minutes, I prefer a **WIP commit on a branch** over a stash — stashes are easy to forget, unlabeled, and local-only. A commit is named, pushable, and survives gc.
- Always `-m` a label so `git stash list` is readable.

## Links

- [Pro Git — Stashing and Cleaning](https://git-scm.com/book/en/v2/Git-Tools-Stashing-and-Cleaning)
