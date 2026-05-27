# Recovering from a bad rebase (and other "I lost commits" panics)

**TL;DR:** Your commits aren't gone. `git reflog` lists every position `HEAD` has pointed at, including the one right before the rebase that scared you. `git reset --hard HEAD@{n}` puts you back there.

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
- **`git commit --amend` ate a commit.** The pre-amend commit is in the reflog; cherry-pick or reset to it.

## How I use it

First move on *any* "where did my work go" moment is `git reflog`, before trying anything clever. Nothing in a normal workflow (rebase, reset, amend, bad merge) actually destroys committed work — it only moves refs. Reflog + `reset --hard`/`branch` undoes the ref move.

The one real way to lose committed work: never having committed it. Uncommitted changes blown away by `reset --hard` or `checkout` are *not* in the reflog. Commit (or `git stash`) before risky operations.

## Links

- `git help reflog`
- [Pro Git — Maintenance and Data Recovery](https://git-scm.com/book/en/v2/Git-Internals-Maintenance-and-Data-Recovery)
