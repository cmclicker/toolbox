# Quoting and word splitting

**TL;DR:** Most Bash bugs come from *unquoted* expansions. After Bash substitutes a variable or command output, it splits the result on whitespace (`IFS`) and then expands globs — so an unquoted `$file` containing a space becomes two arguments, and one containing `*` expands to filenames. **Double-quote every expansion** (`"$var"`, `"$@"`, `"$(cmd)"`) unless you have a specific reason not to. This single habit prevents the majority of shell scripting failures.

## The order of operations

When Bash processes `cp $src $dst`, after parameter expansion it performs **word splitting** then **pathname (glob) expansion** on the *unquoted* results:

1. `$src` → its value, e.g. `my file.txt`
2. Word splitting on `IFS` (space/tab/newline) → two words: `my` and `file.txt`
3. `cp` now receives 3 arguments instead of 2 — broken.

Quoting suppresses both word splitting and globbing: `cp "$src" "$dst"` passes exactly two arguments regardless of spaces or special characters.

## Single vs. double quotes

- **Double quotes `"..."`** — suppress word splitting and globbing, but **still expand** `$var`, `$(cmd)`, and `` `cmd` ``. This is what you want almost always.
- **Single quotes `'...'`** — fully literal; nothing is expanded. Use for fixed strings, regexes, sed/awk programs, and anything with `$` you want kept verbatim.

```bash
name="world"
echo "hello $name"   # hello world
echo 'hello $name'   # hello $name
```

There's no escaping inside single quotes — to include a literal `'`, close, escape, reopen: `'it'\''s'`.

## `"$@"` vs `"$*"` vs unquoted

For passing script/function arguments through, this distinction matters:

- **`"$@"`** — expands to each argument as a **separate** quoted word. This is the correct way to forward arguments.
- `"$*"` — joins all arguments into a **single** word (separated by the first char of `IFS`). Rarely what you want.
- `$@` / `$*` unquoted — subject to word splitting and globbing; broken for any argument with spaces.

```bash
run() { some-command "$@"; }   # forwards args faithfully, spaces intact
```

## When NOT to quote (deliberately)

Quoting is the default; the exceptions are intentional:

- You *want* glob expansion: `for f in *.txt` (unquoted glob), `rm -- *.log`.
- You *want* word splitting of a known-safe list (rare; prefer arrays — see [arrays.md](arrays.md)).

If you're not deliberately invoking one of these, quote.

## `IFS` and word splitting

`IFS` (Internal Field Separator, default space/tab/newline) controls how unquoted expansions split. Two practical uses:

```bash
IFS=',' read -ra parts <<< "a,b,c"   # split a string into an array on commas
while IFS= read -r line; do ... done < file   # read lines safely (no trimming, no splitting)
```

`IFS= read -r` is the canonical safe line-reader: empty `IFS` prevents trimming whitespace, `-r` prevents backslash interpretation.

## How I use it

- Quote every expansion by default: `"$var"`, `"$(cmd)"`, `"${arr[@]}"`, `"$@"`.
- `set -u` ([error-handling.md](error-handling.md)) to catch unset-variable typos that quoting alone won't.
- `IFS= read -r line` for reading lines; arrays instead of relying on word splitting for lists.
- Run [ShellCheck](../../resources/bash/README.md) — it flags unquoted expansions automatically; the [script-review checklist](../../checklists/bash/script-review.md) makes that a step.

## Links

- [BashPitfalls (Greg's Wiki)](https://mywiki.wooledge.org/BashPitfalls) — most entries are quoting failures.
- [Bash manual — Word Splitting](https://www.gnu.org/software/bash/manual/bash.html#Word-Splitting)
