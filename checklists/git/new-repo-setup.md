# Checklist: new repository setup

> Walk this when creating a new repository, before the first push. Each item is yes/no. Reusable configs referenced below live in [../../configs/git/](../../configs/git/).

## Local init (blocking)

- [ ] `git init` run, and `git branch --show-current` reports `main` (not `master`).
- [ ] `.gitignore` present and covers this project's build output, dependencies, and `.env*`. Starting point for Node: [../../configs/gitignore/node.gitignore](../../configs/gitignore/node.gitignore).
- [ ] `.gitattributes` present with at least `* text=auto`. Template: [../../configs/git/gitattributes](../../configs/git/gitattributes). Background: [../../references/git/line-endings.md](../../references/git/line-endings.md).
- [ ] `LICENSE` present if this will be public (or a deliberate decision made to omit it).
- [ ] `README.md` present, stating what the project is and how to run it.

## First commit (blocking)

- [ ] Author identity correct for this repo (`git config user.email`) — especially if you use different identities for work vs. personal.
- [ ] No secrets, credentials, or `.env` contents in the initial commit (`git diff --cached`).
- [ ] No dependencies or build output staged (`git status` — confirm `.gitignore` is doing its job before the first `git add`).

## Remote (blocking)

- [ ] Remote created at the intended visibility (private vs. public) — confirm before pushing, since a moment of public exposure can leak secrets.
- [ ] `git remote -v` points at the correct remote.
- [ ] First push sets upstream (`git push -u origin main`, or rely on `push.autoSetupRemote`).

## Repo hardening (advisory, for shared/public repos)

- [ ] Branch protection on `main`: require PRs, require status checks to pass.
- [ ] Secret scanning / push protection enabled (GitHub: on by default for public repos).
- [ ] CI workflow present and passing on the first push.
- [ ] `CODEOWNERS` added if reviews should route to specific people.
- [ ] Dependabot or equivalent enabled for dependency/security updates.
