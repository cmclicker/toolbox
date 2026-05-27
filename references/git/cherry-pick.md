# `git cherry-pick`

**TL;DR:** `git cherry-pick <commit>` applies the *changes introduced by* one (or more) existing commits onto your current branch as **new** commits — same diff, new hash, new parent. Use it to move a specific fix between branches without merging the whole branch.

## What it does

Given a commit `C` on another branch, `git cherry-pick C` computes `C`'s diff against its parent and applies that diff on top of your current `HEAD`, creating a new commit with the same message and author but a different hash (different parent → different commit object). It does not bring `C`'s history, only `C`'s change.

```bash
git cherry-pick abc1234              # one commit
git cherry-pick abc1234 def5678      # several, in order
git cherry-pick A^..B                # a contiguous range (A exclusive .. B inclusive)
git cherry-pick -x abc1234           # append "(cherry picked from commit …)" to the message
```

`-x` is worth using when picking *published* commits: it records the source hash in the message, leaving a trail of where the change came from.

## When to reach for it

- **Backporting a fix** to a release/maintenance branch without merging unreleased work from `main`.
- **Recovering one commit** from an abandoned or wrong branch.
- **Promoting a single hotfix** made on the wrong branch onto the right one.

If you find yourself cherry-picking many commits between two branches, that's usually a sign a merge or rebase is the right tool instead — repeated cherry-picks duplicate commits and make later merges conflict.

## Conflicts and control flow

A cherry-pick can conflict if the target branch lacks context the change assumed. The flow mirrors a rebase:

```bash
# resolve conflict markers, then:
git add <files>
git cherry-pick --continue
# or
git cherry-pick --abort     # return to the pre-pick state
git cherry-pick --skip      # skip this commit, continue with the rest
```

Conflict resolution mechanics: [../../playbooks/git/resolve-merge-conflict.md](../../playbooks/git/resolve-merge-conflict.md).

```bash
git cherry-pick -n abc1234   # --no-commit: apply changes to the index, don't commit yet
```

`-n` lets you cherry-pick several commits and combine them into one commit, or adjust before committing.

## Duplicate-commit caveat

Because cherry-pick creates a new hash for the same change, if the source branch is later merged into the target, the change can appear twice (Git often detects and drops the duplicate during merge/rebase via patch-id, but not always). Prefer cherry-pick for genuinely isolated changes; prefer merge/rebase when you'll integrate the whole branch eventually.

## How I use it

- Backport a single fix to a release branch with `-x` so the origin is recorded.
- Pull one good commit off a branch I'm otherwise discarding.
- Reach for merge/rebase instead the moment it's more than a couple of commits.

## Links

- [Pro Git — `git cherry-pick`](https://git-scm.com/docs/git-cherry-pick)
