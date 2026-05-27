# Playbook: resolve a merge conflict

> **Trigger:** a `merge`, `rebase`, `pull`, `cherry-pick`, or `stash pop` stopped with "CONFLICT" and unmerged paths. Est. time: 2–20 min depending on count. Conflict-marker mechanics: [../../references/git/merge-vs-rebase.md](../../references/git/merge-vs-rebase.md).

## Step 1 — See what's conflicted

```bash
git status               # "Unmerged paths" lists the conflicted files
git diff --name-only --diff-filter=U   # just the conflicted filenames
```

## Step 2 — Decide your overall strategy first

Before editing, decide which operation you're in, because the "ours/theirs" meaning flips:

- In a **merge**, `--ours` is the branch you're on; `--theirs` is the branch being merged in.
- In a **rebase**, the sense is reversed: `--ours` is the base you're replaying onto, `--theirs` is your commit being replayed. (Rebase replays your work *onto* the base, so the base is "ours.")

If you want to take one side wholesale for a file:

```bash
git checkout --ours  path/to/file    # keep our version
git checkout --theirs path/to/file   # take their version
git add path/to/file
```

## Step 3 — Resolve by hand (the normal case)

Open each conflicted file. With `merge.conflictStyle = zdiff3` (set in [../../configs/git/gitconfig](../../configs/git/gitconfig)) markers look like:

```
<<<<<<< ours
our version
||||||| base
the common ancestor
=======
their version
>>>>>>> theirs
```

The `||||||| base` section (the common ancestor) is the key to a correct resolution: it shows what *both* sides started from, so you can tell what each side actually changed rather than guessing. Edit the file to the intended final content and **delete all marker lines** (`<<<<<<<`, `|||||||`, `=======`, `>>>>>>>`).

For a structured 3-way editor instead of raw markers:

```bash
git mergetool
```

## Step 4 — Mark each file resolved

```bash
git add path/to/file     # staging a formerly-conflicted file marks it resolved
git status               # confirm "Unmerged paths" is now empty
```

Verify nothing was left behind:

```bash
git diff --check         # flags leftover conflict markers and whitespace errors
```

## Step 5 — Complete the operation

The continuation command depends on what you were doing:

- Merge → `git commit` (the message is pre-filled).
- Rebase → `git rebase --continue` (resolves this commit; more conflicts may follow for later commits).
- Cherry-pick → `git cherry-pick --continue`.
- Stash pop → `git add` the resolved files; the stash is applied (drop it with `git stash drop` if it wasn't auto-dropped).

## Bail-out

To abandon and return to the pre-operation state at any point:

```bash
git merge --abort
git rebase --abort
git cherry-pick --abort
```

## Reducing repeat pain

`rerere.enabled = true` (in the shipped [gitconfig](../../configs/git/gitconfig)) records each resolution and replays it automatically if the identical conflict recurs — common when rebasing a branch repeatedly. Resolve once; later replays of the same conflict apply themselves.

## Notes

- Conflicts mean both sides changed the same region (or one side edited a file the other deleted). They are normal, not a mistake.
- Resolve, then **build/test before committing the resolution** — a syntactically merged file can still be logically wrong.
