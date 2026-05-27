# Playbook: undo a commit that's already pushed

> **Trigger:** a commit is already on a remote that others may have pulled, and it needs to be undone. Est. time: 1–5 min. The rule behind this: rewriting published history breaks every other clone — see [../../references/git/merge-vs-rebase.md](../../references/git/merge-vs-rebase.md) and [../../references/git/reset-modes.md](../../references/git/reset-modes.md).

## Step 1 — Is the commit actually published?

```bash
git fetch -q && git log --oneline @{u}..   # commits you have that upstream doesn't
```

- If the bad commit appears here, it is **still local** — you may `reset` or `rebase -i` it away and never read further. Use [../../references/git/reset-modes.md](../../references/git/reset-modes.md).
- If it does **not** appear here, it's published. Continue — do not `reset` or force-push a shared branch.

## Step 2 — Revert (the safe undo for published commits)

`git revert` creates a *new* commit that applies the inverse of the target, leaving history intact so other clones stay consistent:

```bash
git revert <hash>         # undo one commit; opens an editor for the message
git push
```

Range and special cases:

```bash
git revert <oldest>^..<newest>   # revert a contiguous range, newest applied first
git revert -m 1 <merge-hash>     # revert a merge commit, keeping parent 1's line
git revert --no-commit <a> <b>   # stage several reverts, commit them together
```

A merge revert needs `-m` to say which parent's branch to treat as mainline. Note that reverting a merge can complicate later re-merging of that branch; prefer reverting the individual commits if you intend to re-introduce the work.

## Step 3 — If it's only a bad commit *message* (not content)

Editing a published message is a history rewrite. Only do it on a branch you're certain no one else has built on, then:

```bash
git commit --amend        # if it's the latest commit
# or: git rebase -i <base>   # `reword` the target
git push --force-with-lease
```

`--force-with-lease` refuses the push if the remote moved since your last fetch, so you don't clobber someone else's work. Plain `--force` does not check; avoid it. Coordinate with anyone sharing the branch first, because they will need to reset their local copy.

## Step 4 — Secrets or large files committed and pushed

A revert does **not** remove the content from history — the secret/file is still in old commits. This is a separate, heavier procedure:

1. Treat any pushed secret as compromised: **rotate it now** (revoke the key/token), regardless of cleanup.
2. Rewrite history to purge the object with [`git filter-repo`](https://github.com/newren/git-filter-repo) (not the deprecated `filter-branch`).
3. Force-push the rewritten history and have all collaborators re-clone; old clones and any forks still contain it.

Because this rewrites shared history and invalidates every clone, it's a coordinated event, not a quick fix. Rotating the secret is the part that actually limits exposure.

## Decision summary

| Situation | Action |
|---|---|
| Commit still local (in `@{u}..`) | `reset` / `rebase -i` |
| Published, undo the change | `git revert` + push |
| Published, fix only the message, branch is yours | `amend`/`reword` + `push --force-with-lease` |
| Published secret or large blob | rotate the secret, then `git filter-repo` + coordinated re-clone |
