# Repository security features

**TL;DR:** GitHub provides several built-in security layers: **secret scanning + push protection** (blocks commits containing known credential formats), **Dependabot** (alerts + automated dependency-update PRs), **CodeQL code scanning** (static analysis for vulnerabilities), and scoped **`GITHUB_TOKEN` permissions** in Actions. For public repos most are free and several are on by default. Turn them on; they catch real problems cheaply.

## Secret scanning and push protection

- **Secret scanning** detects known credential patterns (API keys, tokens) committed to the repo and alerts you.
- **Push protection** goes further: it **blocks the push** when a recognized secret is detected, before it ever lands. This is the one that prevents the leak rather than reporting it after.

Both are **enabled by default for public repositories**. If push protection blocks you and it's a false positive, you can bypass it with a reason; if it's real, **rotate the secret** and remove it — and if it was already pushed, see [../../playbooks/git/purge-a-secret-from-history.md](../../playbooks/git/purge-a-secret-from-history.md) (rotation is what actually limits exposure).

## Dependabot

Three related features:

- **Dependabot alerts** — notifies you when a dependency has a known vulnerability (from the GitHub Advisory Database).
- **Dependabot security updates** — opens PRs that bump vulnerable dependencies to a fixed version.
- **Dependabot version updates** — opens routine PRs to keep dependencies current, configured by a committed [`.github/dependabot.yml`](../../configs/github/dependabot.yml).

```yaml
# .github/dependabot.yml (minimal)
version: 2
updates:
  - package-ecosystem: npm
    directory: "/"
    schedule: { interval: weekly }
```

Treat Dependabot PRs like any change: read the changelog, let CI run, merge when green. Don't auto-merge majors blindly.

## Code scanning (CodeQL)

Static analysis that flags vulnerability patterns (injection, unsafe deserialization, etc.) on push/PR, surfacing findings in the Security tab. Set it up from Settings → Code security, or add the CodeQL workflow. Most valuable on application code; lighter value on a docs/content repo like this toolbox.

## Actions token permissions

A workflow's automatically-provided `GITHUB_TOKEN` can read/write repo resources. Default to least privilege:

```yaml
permissions:
  contents: read      # top-level default for the whole workflow
```

Grant more only on the specific job that needs it (e.g. `contents: write` for a release job, `pull-requests: write` to comment on PRs). Also pin third-party actions to a version or SHA — a compromised action runs with your token. See [actions-concepts.md](actions-concepts.md).

## The Security tab and policy

- **Security overview / advisories** — central view of alerts.
- **`SECURITY.md`** — tells people how to report a vulnerability privately; GitHub surfaces it under the Security tab.
- **Private vulnerability reporting** — lets researchers report privately rather than opening a public issue.

## How I use it

- Leave secret scanning + push protection on (default for public); never bypass a real hit — rotate instead.
- Commit a `dependabot.yml` for any repo with dependencies; review its PRs like normal changes.
- `permissions: contents: read` at the top of every workflow, widened per-job only as needed; pin actions.
- CodeQL/`SECURITY.md` for application repos; lighter touch for a content repo.
- The full pass is in [../../checklists/github/repo-hardening.md](../../checklists/github/repo-hardening.md).

## Links

- [GitHub code security documentation](https://docs.github.com/en/code-security)
- [About push protection](https://docs.github.com/en/code-security/secret-scanning/working-with-secret-scanning-and-push-protection/protecting-pushes-with-secret-scanning)
- [Dependabot](https://docs.github.com/en/code-security/dependabot)
