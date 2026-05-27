# `git bisect` — binary search for a regression

**TL;DR:** `git bisect` finds the exact commit that introduced a problem by binary-searching history. You mark one known-bad commit and one known-good earlier commit; Git checks out the midpoint; you test and mark it good or bad; repeat. It narrows ~1000 commits to the culprit in ~10 steps, and can be fully automated with a test script.

## Manual flow

```bash
git bisect start
git bisect bad                 # current commit is broken
git bisect good v1.2.0         # this older commit/tag was fine
# Git checks out a commit halfway between. Test it, then:
git bisect good                # this midpoint is fine  -> search newer half
#   or
git bisect bad                 # this midpoint is broken -> search older half
# Repeat until Git prints "<hash> is the first bad commit".
git bisect reset               # return to where you started
```

Each answer halves the remaining range. Git tells you how many revisions and roughly how many steps remain after each mark.

## Automated flow

If the bug is detectable by a command's exit status, let Git run the whole search:

```bash
git bisect start HEAD v1.2.0   # bad ref, then good ref, in one line
git bisect run ./test.sh       # test.sh exits 0 = good, 1..124 (not 125) = bad
git bisect reset
```

`git bisect run` checks out each midpoint, runs the script, and interprets the exit code:

- **0** → good.
- **1–127 except 125** → bad.
- **125** → "cannot test, skip this commit" (e.g. it doesn't build). Equivalent to `git bisect skip`.

Write `test.sh` to reproduce *only* the specific regression (build + the one failing check), so an unrelated breakage doesn't mislabel a commit.

## Skipping untestable commits

```bash
git bisect skip                # this commit can't be tested (won't build, etc.)
```

Git routes around skipped commits. If too many in a region are skipped, it may report a range rather than a single commit.

## Practical notes

- Pick a `good` commit you're genuinely confident about; a wrong `good` mark sends the search down the wrong half and fingers an innocent commit.
- For a flaky bug, a single test run can mislabel a commit. Make the test script robust (run the check a few times) before trusting `bisect run`.
- `git bisect log` records your marks; `git bisect replay <logfile>` re-runs them — useful to resume or to share a reproduction.

## How I use it

The operational walkthrough with a real regression is in [../../playbooks/git/bisect-a-regression.md](../../playbooks/git/bisect-a-regression.md). In short: reach for `bisect run` whenever "it worked last week, not now" and the failure is scriptable — it's far faster than reading diffs.

## Links

- [Pro Git — Binary Search](https://git-scm.com/book/en/v2/Git-Tools-Debugging-with-Git#_binary_search)
- [`git bisect` docs](https://git-scm.com/docs/git-bisect)
