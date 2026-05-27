# Branching models

**TL;DR:** A branching model is the team agreement for how branches map to work and releases. The three common ones are trunk-based (everyone integrates to `main` constantly), GitHub Flow (short-lived feature branches off `main`, merged via PR, deploy from `main`), and Git Flow (long-lived `develop`/`release`/`hotfix` branches). For most modern continuous-delivery work, GitHub Flow or trunk-based is the right default; Git Flow fits versioned, scheduled-release software.

## Trunk-based development

Everyone commits to `main` (the trunk) frequently — at least daily — using very short-lived branches or direct commits behind feature flags. `main` is always releasable.

- **Strengths:** minimal merge divergence, fast integration, pairs naturally with CI/CD and feature flags.
- **Costs:** requires strong test automation and feature flags to keep `main` releasable while work is incomplete.
- **Fits:** teams deploying continuously; experienced teams with good CI.

## GitHub Flow

One long-lived branch (`main`), always deployable. Each change is a short-lived branch off `main`, opened as a pull request, reviewed, CI-checked, then merged back. Deploy from `main` (often automatically on merge).

```
main ─●─────────●───────────●──  (always deployable)
       \       / \         /
        ●─────●   ●───────●   (feature branches, merged via PR)
```

- **Strengths:** simple, PR-centric, excellent for web apps and services with continuous deployment.
- **Costs:** assumes you deploy roughly what's on `main`; no built-in concept of maintaining multiple released versions.
- **Fits:** most SaaS / web / service work. A good default.

## Git Flow

Two long-lived branches — `main` (released code) and `develop` (integration) — plus supporting `feature/*`, `release/*`, and `hotfix/*` branches. Releases are cut on `release/*`, merged to `main`, and tagged.

- **Strengths:** explicit support for scheduled releases and maintaining multiple versions; clear separation of in-progress vs. released.
- **Costs:** heavyweight; the `develop`/`main` split and long-lived branches create merge overhead. Its own author has since noted it's overkill for continuous-delivery web apps.
- **Fits:** installed/versioned software with discrete releases (desktop apps, libraries with multiple supported majors, firmware).

## Release / hotfix patterns (orthogonal)

Independent of the model, two needs recur:

- **Release branches** (`release/1.4`) — freeze a version for stabilization while `main` keeps moving. Tag the release commit (see [tags-and-signing.md](tags-and-signing.md)).
- **Hotfix branches** — branch from the released tag, fix, tag a patch release, then merge the fix back into `main` so it isn't lost.

## How I use it

- Default to **GitHub Flow**: short-lived branch → PR → CI → merge → deploy from `main`. It's what the [new-repo-setup checklist](../../checklists/git/new-repo-setup.md) and branch protection assume.
- Reach for **release branches + tags** only when I need to support a shipped version while `main` advances.
- Avoid full Git Flow unless the product genuinely has scheduled, multi-version releases.
- Whatever the model: keep branches short-lived, rebase/clean my own branch before the PR ([merge-vs-rebase.md](merge-vs-rebase.md)), and never rewrite shared history.

## Links

- [GitHub Flow](https://docs.github.com/en/get-started/using-github/github-flow)
- [Atlassian — Comparing workflows](https://www.atlassian.com/git/tutorials/comparing-workflows)
- [Trunk-Based Development](https://trunkbaseddevelopment.com/)
