# Playbook: find the commit that introduced a regression

> **Trigger:** something works in an older version and is broken now, and you need the exact commit that broke it. Est. time: 5–20 min (mostly automated). Command reference: [../../references/git/bisect.md](../../references/git/bisect.md).

## Step 1 — Pin down "bad" and "good"

- **Bad:** a commit where the problem is present. Usually `HEAD`.
- **Good:** an earlier commit where it was definitely absent. A release tag is ideal (`v1.2.0`). Be honest here — a wrong "good" mark points the search at the wrong half and fingers an innocent commit.

Confirm the bug actually reproduces at `bad` and actually does *not* at `good` before bisecting. If you can't reproduce reliably, fix that first; bisect on a flaky signal gives a wrong answer.

## Step 2 — Make the test reproducible

Write the smallest command that exits **0 when good, non-zero when bad**. It should test *only* this regression:

```bash
# test.sh — exit 0 = good, 1 = bad, 125 = can't test (skip)
#!/usr/bin/env bash
npm ci --silent || exit 125     # if it can't even build here, skip this commit
npm run build  --silent || exit 125
node ./repro.js                 # exits non-zero only on THE bug
```

Use exit `125` for "can't build/test this commit" so bisect skips it instead of mislabeling.

## Step 3 — Run the search

Automated (preferred when the bug is scriptable):

```bash
git bisect start HEAD v1.2.0    # bad first, then good
git bisect run ./test.sh
```

Manual (when the check needs a human eye):

```bash
git bisect start
git bisect bad
git bisect good v1.2.0
# Git checks out the midpoint; test it; then `git bisect good` or `git bisect bad`.
# Repeat until Git names the first bad commit.
```

## Step 4 — Read the result and clean up

Git prints `<hash> is the first bad commit` and shows that commit. Inspect it:

```bash
git show <hash>
git bisect reset        # ALWAYS run this — returns you to the original branch/commit
```

`git bisect reset` is mandatory; until you run it you're left on a detached checkout from the search.

## Step 5 — Act on the culprit

- Understand *why* that commit broke things (the diff plus the bug usually makes it obvious).
- Fix forward with a new commit, or — if the commit is isolated and safe to undo — `git revert <hash>` (see [undo-published-commit.md](undo-published-commit.md)).
- Consider adding a regression test so bisect isn't needed for this again.

## If it goes sideways

- Too many `125`/skip results in one area → bisect reports a *range*; inspect those commits manually.
- Suspect a mislabel → `git bisect log` shows your marks; `git bisect replay <log>` re-runs them after correcting.
- Just want out → `git bisect reset`.
