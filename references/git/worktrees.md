# `git worktree` — multiple working trees, one repo

**TL;DR:** `git worktree` lets one repository have several working directories checked out at once, each on a different branch, all sharing the same `.git` object store. It's the clean alternative to cloning again or stashing constantly when you need to work on two branches in parallel (e.g. review a PR while your feature is half-built).

## The problem it solves

A normal repo has one working tree, so one branch is checked out at a time. To touch another branch you must commit/stash, switch, switch back. Worktrees remove that: check out branch B in a *second* directory while branch A stays exactly as it is in the first.

Because all worktrees share one object database, there's no extra clone, no re-download, and commits/branches made in any worktree are immediately visible to the others.

## Commands

```bash
git worktree add ../feature-x feature-x     # check out existing branch in a new dir
git worktree add -b hotfix ../hotfix main    # create branch 'hotfix' off main in a new dir
git worktree list                            # show all worktrees, their paths and branches
git worktree remove ../feature-x             # remove a worktree (must be clean)
git worktree prune                           # clean up records of manually-deleted worktree dirs
```

Verified flow: `add -b` creates the branch and directory, `list` shows each path with its checked-out branch, `remove` deletes a clean worktree.

## Rules and gotchas

- **A branch can be checked out in only one worktree at a time.** Trying to `add` a branch already checked out elsewhere fails. This is a feature — it prevents two trees from fighting over the same branch ref.
- **Removing** requires the worktree to be clean (or `--force`). Deleting the directory by hand leaves a stale record; `git worktree prune` (or `remove`) cleans it.
- The main worktree (the original clone) can't be removed; it owns the real `.git` directory. Linked worktrees get a small `.git` *file* pointing back to it.
- Submodules and worktrees interact awkwardly; test if your repo uses submodules.

## When to use it vs. alternatives

- **Worktree** — you need two branches *simultaneously present on disk* (build/run branch A while editing branch B; review a PR without disturbing your WIP).
- **Stash** — a brief context switch on the *same* directory; see [stash.md](stash.md).
- **Second clone** — rarely needed now; a worktree gives the same isolation without duplicating objects or losing shared branches/stash.

## How I use it

- Reviewing or testing a PR branch while my feature branch stays untouched: `git worktree add ../review pr-branch`, work, then `git worktree remove ../review`.
- Running a long build on one branch while continuing to edit another.
- Keeping worktree directories *outside* the main repo dir (`../name`) so they don't get caught by tooling that scans the project.

## Links

- [`git worktree` docs](https://git-scm.com/docs/git-worktree)
