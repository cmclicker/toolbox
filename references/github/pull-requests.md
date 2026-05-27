# Pull requests and review

**TL;DR:** A pull request proposes merging one branch into another, with review, discussion, and CI attached. Open it early as a **draft** to get CI running; mark ready when it's reviewable. Keep PRs small and single-purpose. The merge method (merge commit / squash / rebase) decides what the base branch's history looks like — pick one per repo and stick to it.

## Lifecycle

1. Branch off the base (usually `main`), commit, push.
2. Open a PR — as a **draft** if it's not ready for review yet (CI still runs; reviewers aren't requested).
3. CI runs; reviewers comment, request changes, or approve.
4. Address feedback with new commits (don't force-push mid-review unless asked — it makes "what changed since I looked" harder; see [../git/merge-vs-rebase.md](../git/merge-vs-rebase.md)).
5. Once approved and checks pass, merge; delete the branch.

```bash
gh pr create --fill --draft        # open a draft PR, title/body from commits
gh pr ready                        # mark the current PR ready for review
gh pr view --web                   # open it in the browser
gh pr checks                       # show CI status for the PR
gh pr review --approve             # or --request-changes / --comment
```

## Merge methods

The base branch's resulting history depends on the method (set the allowed ones in repo Settings → General → Pull Requests):

| Method | Result on base | Use when |
|---|---|---|
| **Merge commit** | All the PR's commits + a merge commit | You want the full branch history preserved |
| **Squash and merge** | One new commit combining the whole PR | You want one tidy commit per PR (most common for app repos); branch commits can be messy |
| **Rebase and merge** | The PR's commits replayed onto base, no merge commit | You want linear history *and* individual commits preserved |

```bash
gh pr merge --squash --delete-branch     # squash, then delete the branch
gh pr merge --auto --squash              # auto-merge once checks pass + approvals met
```

`--auto` is useful with branch protection: queue the merge and walk away; GitHub completes it when required checks and reviews are satisfied.

## Keeping PRs reviewable

- **Small and single-purpose.** A 200-line PR gets a real review; a 2,000-line one gets a rubber stamp. Split unrelated work ([../git/merge-vs-rebase.md](../git/merge-vs-rebase.md), and `git rebase -i` to clean up first).
- **Describe the why.** The diff shows *what*; the description must explain *why* and how to verify. A repo PR template enforces this — see [../../configs/github/pull_request_template.md](../../configs/github/pull_request_template.md).
- **Link the issue** with a closing keyword in the description (`Closes #123`) so the issue closes on merge.
- **Draft first.** Opening as draft surfaces CI failures before you've asked anyone to look.

## Linking issues and automation

Keywords in the PR body — `Closes #N`, `Fixes #N`, `Resolves #N` — auto-close the referenced issue when the PR merges into the default branch. `CODEOWNERS` ([../../configs/github/CODEOWNERS](../../configs/github/CODEOWNERS)) auto-requests review from the right people based on which paths changed.

## How I use it

- Draft PR early (`gh pr create --draft --fill`), let CI run, then `gh pr ready`.
- Squash-merge for app repos (one commit per PR); preserve commits only where individual history matters (libraries).
- Small PRs, real descriptions, `Closes #N`, `--auto --squash` to merge on green.
- The review-side checklist is [../../checklists/github/pr-review.md](../../checklists/github/pr-review.md).

## Links

- [GitHub Docs — About pull requests](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests)
- [About merge methods](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/incorporating-changes-from-a-pull-request/about-pull-request-merges)
