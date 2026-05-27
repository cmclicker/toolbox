# Playbook: split one commit into several

> **Trigger:** a single (unpushed) commit bundles unrelated changes that should be separate commits — e.g. a bug fix and a refactor landed together. Est. time: 5–15 min. This rewrites history, so apply only to local/unpushed commits ([../../references/git/merge-vs-rebase.md](../../references/git/merge-vs-rebase.md)).

## Case A — it's the most recent commit (fast path)

```bash
git reset HEAD~1        # undo the commit, keep its changes unstaged (mixed reset)
```

Now the changes sit in your working tree. Stage and commit them in logical groups:

```bash
git add -p              # interactively stage only the first logical change
git commit -m "fix: …"
git add -p              # stage the next group
git commit -m "refactor: …"
# repeat until `git status` is clean
```

`git add -p` (patch mode) is the key tool — it lets you stage individual hunks, so a single file's changes can be divided across commits. See [reset-modes.md](../../references/git/reset-modes.md) for why `reset HEAD~1` leaves changes unstaged.

## Case B — it's an older commit in the branch

Use interactive rebase to stop *at* that commit and split it there.

```bash
git rebase -i <commit>~1     # base = the parent of the commit to split
```

In the todo list, change `pick` to `edit` for the target commit, save, and close. Git replays up to that commit and pauses. Then:

```bash
git reset HEAD~1             # uncommit it, keep changes unstaged
git add -p && git commit -m "…"   # commit the first part
git add -p && git commit -m "…"   # commit the rest (as many as needed)
git rebase --continue       # replay the remaining commits on top
```

If later commits conflict during `--continue`, resolve them ([resolve-merge-conflict.md](resolve-merge-conflict.md)) and continue.

## Verify

```bash
git log --oneline -8        # confirm the new commits look right
git diff <original-parent> HEAD --stat   # the net change should be identical to before
```

The combined diff of the new commits must equal the original commit's diff — splitting changes *organization*, not *content*. If the net diff differs, you dropped or double-staged a hunk.

## Bail-out

Mid-rebase and want out: `git rebase --abort`. After finishing but unhappy: `git reset --hard ORIG_HEAD` (the pre-rebase tip), per [rebase-recovery.md](../../references/git/rebase-recovery.md).

## Notes

- If the commit was already pushed to a shared branch, don't do this — the rewrite diverges everyone else. Split only local work, before the PR.
- The mirror operation (combining several commits into one) is `git reset --soft` to the base then a single commit, or `squash`/`fixup` in `rebase -i`.
