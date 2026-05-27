# Tests and conditionals: `[[ ]]`, `[ ]`, `if`, `case`

**TL;DR:** In Bash, prefer `[[ ... ]]` over the older `[ ... ]` (a.k.a. `test`): `[[ ]]` doesn't word-split or glob its operands, supports `&&`/`||`/`<`/`>` without escaping, and adds `=~` regex and glob `==` pattern matching. Use `(( ))` for arithmetic. `if`/`while` branch on a command's **exit status** (0 = success/true), not on a boolean value.

## `[[ ]]` vs `[ ]`

```bash
[[ -f "$file" ]]            # file exists and is a regular file
[ -f "$file" ]             # same test, POSIX form — but quoting is mandatory here
```

Why `[[ ]]` is safer and more capable:

- **No word splitting / globbing** inside it, so `[[ $x == $y ]]` works even with empty or spaced values (`[ $x = $y ]` breaks if `$x` is empty or has spaces).
- `&&`, `||`, `<`, `>` work directly: `[[ $a == foo && $b -gt 3 ]]`.
- Adds `=~` (regex) and glob patterns on the right of `==`.

Use plain `[ ]` only when you need strict POSIX `sh` portability. In Bash scripts, use `[[ ]]`.

## Common test operators

```bash
# strings
[[ -z "$s" ]]      # empty       [[ -n "$s" ]]   # non-empty
[[ "$a" == "$b" ]] # equal       [[ "$a" != "$b" ]]
# files
[[ -e p ]] exists   [[ -f p ]] regular file   [[ -d p ]] directory
[[ -r p ]] readable [[ -w p ]] writable        [[ -x p ]] executable
[[ -s p ]] non-empty file        [[ p1 -nt p2 ]] p1 newer than p2
# numbers (use -eq/-ne/-lt/-le/-gt/-ge in [[ ]] or [ ])
[[ "$n" -gt 3 ]]
```

## Glob and regex matching

```bash
[[ "$file" == *.txt ]]              # glob: right side is a PATTERN (don't quote it)
[[ "$ver" =~ ^v[0-9]+\.[0-9]+ ]]    # regex; captures land in BASH_REMATCH
echo "major=${BASH_REMATCH[1]}"     # verified: matches & captures work
```

Quoting flips the meaning: `[[ $f == "*.txt" ]]` matches the literal string `*.txt`; unquoted `*.txt` is a pattern. Same for `=~` — quoting the regex makes it literal.

## Arithmetic: `(( ))`

For numeric conditions and math, `(( ))` is cleaner than `-gt` etc. — it's true when the result is non-zero:

```bash
(( count > 3 ))            # arithmetic comparison
(( i++ ))                  # arithmetic without $ on names
x=$(( (a + b) * 2 ))       # arithmetic expansion to a value
```

## `if` / `&&` / `||` branch on exit status

`if cmd; then` runs `then` when `cmd` exits **0**. There's no separate boolean type — success/failure is the exit code.

```bash
if grep -q "ERROR" log.txt; then echo "found"; fi
command -v jq >/dev/null || { echo "jq required" >&2; exit 1; }   # guard a dependency
mkdir -p "$dir" && cd "$dir"                                      # chain on success
```

Note: under `set -e`, a failing command inside an `if`/`&&`/`||` condition does **not** abort the script — that's intended ([error-handling.md](error-handling.md)).

## `case` for multiple patterns

```bash
case "$1" in
  start)        start_service ;;
  stop|halt)    stop_service ;;       # multiple patterns with |
  *.log)        rotate "$1" ;;        # glob patterns allowed
  *)            echo "unknown: $1" >&2; exit 1 ;;   # default
esac
```

`case` matches globs (not regex) top to bottom; first match wins. Cleaner than a long `if/elif` chain when branching on one value.

## How I use it

- `[[ ]]` for all tests in Bash scripts; `(( ))` for numbers; `case` for multi-way branches.
- `command -v tool >/dev/null || { ...; exit 1; }` to assert dependencies up front.
- Reserve POSIX `[ ]` for scripts that must run under `sh`/`dash`.

## Links

- [Bash manual — Conditional Constructs](https://www.gnu.org/software/bash/manual/bash.html#Conditional-Constructs)
- [BashGuide — Tests and Conditionals](https://mywiki.wooledge.org/BashGuide/TestsAndConditionals)
