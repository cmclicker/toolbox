# Bash — resources

> Curated external material for Bash and shell scripting. My own explainers are in [../../references/bash/](../../references/bash/); reusable templates in [../../snippets/bash/](../../snippets/bash/).

## Official docs & specs

- **[Bash Reference Manual](https://www.gnu.org/software/bash/manual/bash.html)** — the authoritative spec for every feature, builtin, and expansion.
- **[POSIX Shell Command Language](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html)** — what's portable to `sh`/`dash`, when a script must run beyond Bash.

## Learn

- **[BashGuide (Greg's Wiki)](https://mywiki.wooledge.org/BashGuide)** — the best from-scratch guide that teaches *correct* Bash, not cargo-cult habits.
- **[Bash Hackers Wiki](https://flokoe.github.io/bash-hackers-wiki/)** — topic-by-topic deep dives (the community-maintained revival of the original wiki).

## Cheatsheets & quick-reference

- **[Greg's BashFAQ](https://mywiki.wooledge.org/BashFAQ)** — answers to the questions everyone hits ("how do I read a file line by line", "why doesn't `set -e` work").
- **[Greg's BashPitfalls](https://mywiki.wooledge.org/BashPitfalls)** — a ranked list of the mistakes (mostly quoting) that break scripts. Read it once; it'll change how you write Bash.
- **[devhints — Bash](https://devhints.io/bash)** — a fast one-page syntax reminder.

## Tools & utilities

- **[ShellCheck](https://www.shellcheck.net/)** — static analyzer that catches quoting bugs, pitfalls, and misuse. Use the [online checker](https://www.shellcheck.net/) or install the CLI; run it on every script (see [../../checklists/bash/script-review.md](../../checklists/bash/script-review.md)).
- **[explainshell](https://explainshell.com/)** — paste any command line and it annotates each flag/word with the relevant man-page text.
- **[tldr pages](https://tldr.sh/)** — practical, example-first summaries of command-line tools (vs. full man pages).

## Style

- **[Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)** — a widely-used convention set: when to use Bash vs. another language, naming, structure.

---

_Last checked: 2026-05. External links rot — see [maintenance notes](../README.md#maintenance)._
