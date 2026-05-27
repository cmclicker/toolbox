# `configs/github/`

> Drop-in GitHub repo files. These are stored here as reusable templates; copy them into a real project at the paths below (GitHub only acts on them when they live under `.github/` in that repo — here they're inert).

| File here | Copy to (in the target repo) | Purpose |
|---|---|---|
| [workflows/node-ci.yml](workflows/node-ci.yml) | `.github/workflows/ci.yml` | Node lint/typecheck/test/build CI |
| [dependabot.yml](dependabot.yml) | `.github/dependabot.yml` | Dependency + Actions update PRs |
| [CODEOWNERS](CODEOWNERS) | `.github/CODEOWNERS` (or repo root) | Auto-request reviewers by path |
| [pull_request_template.md](pull_request_template.md) | `.github/pull_request_template.md` | Default PR description |
| [ISSUE_TEMPLATE/bug_report.md](ISSUE_TEMPLATE/bug_report.md) | `.github/ISSUE_TEMPLATE/bug_report.md` | Bug issue form |
| [ISSUE_TEMPLATE/feature_request.md](ISSUE_TEMPLATE/feature_request.md) | `.github/ISSUE_TEMPLATE/feature_request.md` | Feature issue form |
| [ISSUE_TEMPLATE/config.yml](ISSUE_TEMPLATE/config.yml) | `.github/ISSUE_TEMPLATE/config.yml` | Issue template chooser settings |

Concepts behind these: [../../references/github/actions-concepts.md](../../references/github/actions-concepts.md), [../../references/github/repo-security.md](../../references/github/repo-security.md), [../../references/github/pull-requests.md](../../references/github/pull-requests.md).
