# `git reset`: the three modes

**TL;DR:** `git reset [<mode>] <commit>` does up to two things — move the current branch ref to `<commit>`, then optionally update the index and working tree to match. `--soft` moves only the ref; `--mixed` (the default) also resets the index; `--hard` also resets the working tree. Only `--hard` can destroy uncommitted work.

## The three trees

`reset` operates on three things Git tracks at once:

- **HEAD / branch ref** — the commit your branch points at.
- **Index** (the staging area) — what `git commit` would record next.
- **Working tree** — the actual files on disk.

Each mode resets a successively larger set of these:

| Mode | Moves branch ref | Resets index | Resets working tree | Uncommitted work at risk |
|---|---|---|---|---|
| `--soft` | yes | no | no | no |
| `--mixed` *(default)* | yes | yes | no | no |
| `--hard` | yes | yes | yes | **yes** |

This table is verified empirically: after `reset --soft HEAD~1` the undone commit's changes remain **staged**; after `--mixed HEAD~1` the same changes remain in the working tree but **unstaged**; after `--hard HEAD~1` the working tree matches the target commit and `git status` is clean.

## What each mode is for

- **`--soft <commit>`** — move the branch back but keep everything staged. Use it to **recombine commits**: `git reset --soft HEAD~3` collapses the last three commits' changes into the staging area so you can re-commit them as one.
- **`--mixed <commit>`** (default) — move the branch back and unstage. `git reset HEAD~1` undoes the last commit and leaves its changes as modified-but-unstaged files to re-edit or re-stage selectively. `git reset` with no commit argument (`git reset <path>`) is the same mechanism used to **unstage** a file.
- **`--hard <commit>`** — move the branch back and discard all index and working-tree changes down to the target. Use it to **throw away** local work entirely. This is the only mode that deletes uncommitted changes, and they are not in the reflog.

## reset vs. revert vs. checkout/restore

- **`reset`** moves a branch ref. It rewrites the branch's position in history — appropriate for **local, unpushed** work.
- **`revert`** creates a *new* commit that undoes a previous commit's changes, leaving history intact — appropriate for **published** commits others may have pulled. See [../../playbooks/git/undo-published-commit.md](../../playbooks/git/undo-published-commit.md).
- **`git restore <path>`** (or older `git checkout -- <path>`) changes files without moving any branch ref. `git restore --staged <path>` unstages; `git restore <path>` discards working-tree edits.

## Recovering from a mistaken reset

Because `reset` only moves a ref, the prior position is in the reflog:

```bash
git reflog                 # find the entry before the reset
git reset --hard HEAD@{1}  # return to where the branch was
```

This recovers commits. It does **not** recover working-tree changes destroyed by `reset --hard` that were never committed. See [rebase-recovery.md](rebase-recovery.md).

## How I use it

- Undo the last commit but keep editing → `git reset HEAD~1` (mixed).
- Squash recent commits before pushing → `git reset --soft HEAD~N`, then one `git commit`.
- Discard a broken local experiment → `git reset --hard <good-commit>`, after confirming nothing uncommitted is worth keeping.
- Never `reset` a branch others have pulled; `revert` instead.

## Links

- [Pro Git — Reset Demystified](https://git-scm.com/book/en/v2/Git-Tools-Reset-Demystified)
