# Playbook: recover from a bad rebase

> **Trigger:** a rebase finished (or is mid-conflict) and the history is wrong — lost commits, mangled conflict resolution, or commits in the wrong order. Est. time: 2–10 min.
>
> For the *why* behind reflog and reset, see [references/git/rebase-recovery.md](../../references/git/rebase-recovery.md). This is the do-it-now sequence.

## Step 1 — Are you still mid-rebase?

Run `git status`. If it says "interactive rebase in progress" or shows unmerged paths:

- **Bail out entirely** → `git rebase --abort`. You're back to the pre-rebase state. **Done.**
- Only continue past here if the rebase has already *completed*.

## Step 2 — Try the easy undo

Git saved the pre-rebase tip in `ORIG_HEAD`:

```bash
git reset --hard ORIG_HEAD
```

Check the log (`git log --oneline -10`). If history looks right again → **Done.**

> ⚠️ `reset --hard` discards uncommitted changes. If you have any worth keeping, `git stash` first, then `git stash pop` after.

## Step 3 — If `ORIG_HEAD` was overwritten, use the reflog

`ORIG_HEAD` only holds the *most recent* such operation. If you ran more commands after the rebase, find the good state manually:

```bash
git reflog
```

Read down to the entry **just before** the rebase began — typically labelled `commit:` or `checkout:` with your last good message. Note its `HEAD@{n}`.

- **If you want to verify before committing to it:** `git show HEAD@{n}` or `git branch rescue HEAD@{n}` (parks it safely), then inspect.
- **If you're confident:** `git reset --hard HEAD@{n}`.

Re-check `git log --oneline`. Good → **Done.**

## Step 4 — Already pushed the bad history?

- **Branch is yours / shared with no one** → force-push the recovered state: `git push --force-with-lease`. (`--force-with-lease`, not `--force`: it refuses if someone else pushed in the meantime.)
- **Others may have pulled the bad history** → do NOT force-push silently. Coordinate first, or move forward with a `git revert` instead of rewriting. Rewriting shared history is its own incident.

## Notes

- Nothing committed is ever lost to a rebase — only refs move. The reflog is the safety net.
- The only unrecoverable loss is *uncommitted* work wiped by `reset --hard`. Commit or stash before risky operations.
