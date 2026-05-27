# The `gh` CLI

**TL;DR:** `gh` is GitHub's official command-line tool — it does from the terminal what you'd otherwise click through the web UI: PRs, issues, releases, runs, repo creation, and raw API calls. It uses your authenticated login, so it's the fastest way to script GitHub work without managing tokens by hand.

## Auth

```bash
gh auth login            # interactive: browser or token, picks https/ssh for git
gh auth status           # who you're logged in as, scopes, token
gh auth refresh -s workflow,repo   # add scopes (e.g. to push workflow files)
```

`gh` also acts as a git credential helper, so once logged in, `git push` over HTTPS just works. Token scopes matter: pushing `.github/workflows/*` requires the `workflow` scope.

## Pull requests

```bash
gh pr create --fill [--draft]      # open a PR (title/body from commits)
gh pr list                         # open PRs in this repo
gh pr status                       # PRs relevant to you (yours, review-requested)
gh pr view [<n>] [--web]           # details (or open in browser)
gh pr checks [<n>]                 # CI status for the PR
gh pr review --approve|--request-changes|--comment
gh pr merge --squash --delete-branch [--auto]
gh pr checkout <n>                 # check out someone's PR branch locally to test
```

## Issues, releases, runs

```bash
gh issue create --title "…" --body "…"
gh issue list --label bug --state open
gh release create v1.4.0 --generate-notes [dist/*]   # tag-based release + assets
gh run list                        # recent Actions runs
gh run watch <id> --exit-status    # follow a run; exit non-zero if it fails (CI-friendly)
gh run view <id> --log-failed      # just the failed step logs
```

`gh run watch --exit-status` is handy in scripts and after a push to block until CI resolves.

## Repos

```bash
gh repo create <name> --public --source . --remote origin --push   # create + push existing local repo
gh repo view [--web]               # repo overview (or open in browser)
gh repo clone <owner>/<name>
gh repo edit --add-topic toolbox --description "…"   # topics, description, settings
gh browse [<file>]                 # open the repo/file on github.com
```

## The escape hatch: `gh api`

Anything the dedicated commands don't cover, call the REST or GraphQL API directly with your auth:

```bash
gh api repos/{owner}/{repo}/branches/main/protection   # read branch protection
gh api -X PUT repos/OWNER/REPO/branches/main/protection --input rules.json
gh api graphql -f query='query { viewer { login } }'
```

`gh api` is how you script things like **rulesets** and detailed branch protection — `gh ruleset` only *views* rulesets, so creating them is a UI or `gh api` task (see [branch-protection-and-rulesets.md](branch-protection-and-rulesets.md)).

## Aliases and extensions

```bash
gh alias set prc 'pr create --fill --draft'   # then: gh prc
gh extension install <owner>/<repo>           # community subcommands
```

A set of useful aliases/one-liners is in [../../snippets/github/gh-aliases.sh](../../snippets/github/gh-aliases.sh).

## How I use it

- `gh pr create --draft --fill` → `gh pr checks` → `gh pr merge --auto --squash` is most of my PR flow.
- `gh run watch --exit-status` after a push to confirm CI without leaving the terminal.
- `gh release create vX.Y.Z --generate-notes` for releases ([../../playbooks/github/ship-a-release.md](../../playbooks/github/ship-a-release.md)).
- `gh api` for anything not covered by a first-class command.

## Links

- [`gh` manual](https://cli.github.com/manual/)
- [`gh api`](https://cli.github.com/manual/gh_api)
