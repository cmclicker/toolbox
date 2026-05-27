# Playbook: create and harden a new GitHub repo

> **Trigger:** starting a new project and publishing it to GitHub. Est. time: 10–15 min. Pairs with the local-side [../../checklists/git/new-repo-setup.md](../../checklists/git/new-repo-setup.md) and [../../checklists/github/repo-hardening.md](../../checklists/github/repo-hardening.md).

## Step 1 — Prepare the local repo first

Before publishing (so nothing unwanted goes up):

```bash
git init
git branch -M main                       # ensure the default branch is main
# add .gitignore, .gitattributes (* text=auto), LICENSE, README
git add -A && git commit -m "Initial commit"
```

Confirm no secrets or build output are staged (`git status`, `git diff --cached`). The local checklist [../../checklists/git/new-repo-setup.md](../../checklists/git/new-repo-setup.md) covers this in full.

## Step 2 — Decide visibility before creating

Public vs. private is the one consequential choice: a public repo is world-readable the instant it exists, and content can be cached/forked even if you flip it private later. Decide deliberately.

## Step 3 — Create the remote and push

```bash
gh auth status        # confirm you're logged in as the right account, with repo + workflow scopes
gh repo create <owner>/<name> --public --source . --remote origin --push \
  --description "One-line description"
```

`--source . --push` creates the remote from your existing local repo and pushes `main` in one step. (The `workflow` scope is needed if your first commit includes `.github/workflows/*`.)

## Step 4 — Set metadata

```bash
gh repo edit --add-topic <topic> --add-topic <topic>   # discoverability
# (description was set at creation; edit here if needed)
```

## Step 5 — Protect `main`

Create a ruleset (Settings → Rules → Rulesets, or `gh api`) with the baseline from [../../references/github/branch-protection-and-rulesets.md](../../references/github/branch-protection-and-rulesets.md):

- Require a pull request before merging.
- Require the CI status check (must match the workflow's job/check name exactly).
- Block force pushes and deletion.

> The required-check name only works once CI has run at least once so GitHub knows the check exists — push a commit that triggers the workflow first, then add it as required.

## Step 6 — Turn on security features

- Confirm secret scanning + push protection are on (default for public).
- Add `.github/dependabot.yml` ([../../configs/github/dependabot.yml](../../configs/github/dependabot.yml)) and enable Dependabot alerts.
- Ensure workflows use least-privilege `permissions:` ([../../references/github/repo-security.md](../../references/github/repo-security.md)).

## Step 7 — Drop in collaboration templates (optional)

Copy from [../../configs/github/](../../configs/github/): `pull_request_template.md`, `ISSUE_TEMPLATE/`, `CODEOWNERS`, and a CI workflow ([workflows/node-ci.yml](../../configs/github/workflows/node-ci.yml)).

## Step 8 — Verify

```bash
gh repo view --web                 # eyeball the landing page
gh run watch "$(gh run list --limit 1 --json databaseId -q '.[0].databaseId')" --exit-status
```

Confirm CI is green and the protection rule shows as active. Then walk [../../checklists/github/repo-hardening.md](../../checklists/github/repo-hardening.md) once to catch anything missed.
