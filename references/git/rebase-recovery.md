# Recovering from a bad rebase and lost commits

**TL;DR:** A rebase, reset, or amend moves refs; it does not delete committed objects. `git reflog` lists every position `HEAD` has held, including the one immediately before the rebase. `git reset --hard HEAD@{n}` moves the current branch back to that position.

## Why this works

A commit is only truly unreachable once it's both (a) not referenced by any branch/tag and (b) garbage-collected. GC doesn't run immediately (default ~90 days for reachable-via-reflog objects). The **reflog** is a per-repo log of where `HEAD` (and each branch) has been — rebases, resets, merges, checkouts all leave entries. So the pre-rebase state is still reachable by its reflog entry even when no branch points at it anymore.

## The recovery

```bash
git reflog                      # find the entry just BEFORE the rebase
# ... e.g. "abc1234 HEAD@{5}: commit: the work I thought I lost"
git reset --hard HEAD@{5}       # move current branch back to that exact state
```

If you'd rather not move your branch yet, inspect first:

```bash
git show HEAD@{5}               # look at it
git branch rescue HEAD@{5}      # park it on a new branch, decide later
```

## Common scenarios

- **Rebase produced garbage / wrong conflict resolution.** During the rebase: `git rebase --abort`. After it finished: `git reset --hard ORIG_HEAD` (git stashes the pre-rebase tip in `ORIG_HEAD`).
- **Hard reset to the wrong commit.** Same fix — `git reflog`, then reset back.
- **Deleted a branch by mistake.** `git reflog` still has its tip; `git branch <name> <sha>` recreates it.
- **`git commit --amend` replaced a commit.** The pre-amend commit is in the reflog; cherry-pick or reset to it.

## How I use it

Run `git reflog` first, before any other recovery command, whenever a committed change appears to be missing. Rebase, reset, amend, and merge move refs without deleting committed objects, so the prior state is reachable through a reflog entry; `reset --hard` or `git branch` against that entry restores it.

This does not recover *uncommitted* changes. `git reset --hard` and `git checkout` overwrite the working tree, and uncommitted work has no reflog entry. Commit or `git stash` before running either.

## Links

- `git help reflog`
- [Pro Git — Maintenance and Data Recovery](https://git-scm.com/book/en/v2/Git-Internals-Maintenance-and-Data-Recovery)
