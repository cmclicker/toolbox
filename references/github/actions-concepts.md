# GitHub Actions concepts

**TL;DR:** GitHub Actions runs automated workflows in response to repo events. A **workflow** (a YAML file in `.github/workflows/`) is triggered by an **event** (push, pull_request, schedule…), and contains **jobs** that run on **runners**; each job is a series of **steps** that either run shell commands or invoke a reusable **action**. Jobs run in parallel by default and on fresh VMs, so anything one job needs from another must be passed explicitly.

## The hierarchy

```yaml
name: ci                       # workflow name
on: [push, pull_request]       # events that trigger it

jobs:
  test:                        # a job id
    runs-on: ubuntu-latest     # the runner (VM image)
    steps:
      - uses: actions/checkout@v5     # a step: invoke a reusable action
      - run: npm ci && npm test       # a step: run shell commands
```

- **Event** — what triggers the run: `push`, `pull_request`, `schedule` (cron), `workflow_dispatch` (manual), `release`, etc. Filter by branch/path: `on: { push: { branches: [main], paths: ['src/**'] } }`.
- **Job** — a unit that runs on one runner. Jobs run **in parallel** unless ordered with `needs:`. Each gets a clean VM.
- **Runner** — the machine. GitHub-hosted: `ubuntu-latest`, `windows-latest`, `macos-latest`. Self-hosted is also possible.
- **Step** — either `uses:` (a published action, pinned by version) or `run:` (shell). Steps in a job share the same filesystem and run in order.

## Things that trip people up

- **Jobs don't share a filesystem.** Each job is a fresh VM. To pass files between jobs, use `actions/upload-artifact` / `download-artifact`; to pass values, use job `outputs`.
- **Checkout isn't automatic.** The first step is almost always `actions/checkout` — without it the runner has no repo contents.
- **Pin actions to a version.** `actions/checkout@v5` (major) or a full commit SHA for stricter supply-chain safety. Floating `@main` can change under you.
- **Secrets aren't available to forked-PR workflows by default** (a security measure). Design CI so untrusted PRs don't need secrets.

## Matrix builds

Run the same job across combinations (versions, OSes):

```yaml
strategy:
  matrix:
    node: [20, 22, 24]
    os: [ubuntu-latest, windows-latest]
runs-on: ${{ matrix.os }}
steps:
  - uses: actions/setup-node@v5
    with: { node-version: ${{ matrix.node }} }
```

## Caching and speed

`actions/setup-node` (and the other `setup-*` actions) can cache the dependency store: `with: { cache: 'npm' }`. For arbitrary caches use `actions/cache`. Caching dependencies is usually the biggest CI speedup.

## Secrets, variables, and permissions

- **Secrets** — `${{ secrets.NAME }}`, set in repo/org settings, masked in logs.
- **Variables** — `${{ vars.NAME }}`, non-sensitive config.
- **`GITHUB_TOKEN`** — an automatically-provided token for the workflow to call the API. **Scope it down** with a top-level `permissions:` block (default to `contents: read` and grant only what a job needs). See [repo-security.md](repo-security.md).

```yaml
permissions:
  contents: read          # least privilege; raise per-job only where needed
```

## Reusing logic

- **Composite actions** / `uses:` a local action (`./.github/actions/x`) to factor out repeated steps.
- **Reusable workflows** (`on: workflow_call`) let one workflow call another, sharing CI across repos.

## How I use it

- One `validate`/`ci` workflow per repo, `permissions: contents: read` at the top, checkout + `setup-node` with `cache: npm`, then lint/typecheck/test/build.
- Matrix only when multi-version/multi-OS support is a real requirement.
- A ready-to-use Node CI workflow is in [../../configs/github/workflows/node-ci.yml](../../configs/github/workflows/node-ci.yml).

## Links

- [GitHub Actions documentation](https://docs.github.com/en/actions)
- [Workflow syntax](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)
- [Security hardening for GitHub Actions](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions)
