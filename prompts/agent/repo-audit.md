# Prompt: repository audit

> **Use when:** pointing an agent (Claude Code or similar) at a repo to assess whether it's well-structured for its stated purpose — before investing more in it. Produces a verdict, gaps, and over-engineering, not a rewrite.
>
> **Variables:** `{{purpose}}` — what the repo is supposed to be/do.

---

You are auditing this repository against its intended purpose: **{{purpose}}**

Do not change any files. Investigate the actual contents — read the structure, the READMEs, and a sample of real files — then report:

1. **Verdict.** In 1–2 sentences: is the repo set up to serve its purpose as-is? What proportion is real content vs. scaffolding?

2. **Identity check.** Does what's actually in the repo match the stated purpose, or is there a contradiction (e.g., named/described as one thing but built as another)? Name the single most important tension if there is one.

3. **Gaps (blocking).** What's missing that the purpose requires? Be concrete — missing files, broken internal links, absent tooling, no license/README if it's meant to be public. Distinguish blocking from nice-to-have.

4. **Over-engineering.** What's been built ahead of where the repo actually is — machinery for content that doesn't exist yet, governance for a scale not reached? Over-built scaffolding raises the bar to contribute and stalls a repo as surely as missing structure.

5. **The one decision that gates the rest.** If there's a fork in the road where the answer determines everything downstream, surface it as a question instead of guessing.

Be direct. Praise what's genuinely good, but don't pad. The goal is an honest map of where the repo stands and what to do next — not reassurance.
