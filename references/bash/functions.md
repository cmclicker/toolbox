# Functions

**TL;DR:** A Bash function groups commands under a name. Arguments arrive as `$1`, `$2`, …, `"$@"` — there's no parameter list in the definition. Declare variables `local` or they leak into the caller. Functions "return" data by **printing to stdout** (captured with `$(...)`); the `return` statement sets only the **exit status** (0–255), used for success/failure.

## Defining and calling

```bash
greet() {                 # preferred form
  echo "hello, $1"
}
greet "world"             # called like a command, args space-separated
```

Arguments mirror script positional parameters:

- `$1`, `$2`, … — individual args
- `"$@"` — all args, each a separate quoted word (use this to forward)
- `$#` — argument count
- `$0` — still the script name, **not** the function name (use `${FUNCNAME[0]}` for that)

## `local` is not optional

Variables are global by default — a function that assigns `x=...` overwrites a caller's `x`. Declare them `local`:

```bash
parse() {
  local input="$1"          # scoped to this function
  local -a parts            # local array
  IFS=: read -ra parts <<< "$input"
  ...
}
```

Forgetting `local` is a top source of action-at-a-distance bugs. Declare every working variable `local`.

## Returning values: stdout vs. exit status

These are different channels:

- **Data out → print to stdout**, capture with command substitution:
  ```bash
  timestamp() { date +%Y%m%d-%H%M%S; }
  name="backup-$(timestamp).tar"
  ```
- **Success/failure → `return N`** (0 = success), tested by `if`/`&&`:
  ```bash
  is_installed() { command -v "$1" >/dev/null; }   # exit status IS the answer
  if is_installed jq; then ...; fi
  ```

`return` only accepts 0–255; it is **not** for returning strings or large numbers. Don't `return "$some_string"` — print it instead. A common pattern combines both: print the result, `return 1` on error.

> Gotcha: `local result=$(cmd)` masks `cmd`'s exit status (the `local` assignment succeeds even if `cmd` fails). Split it when you need the status: `local result; result=$(cmd) || return 1`.

## Caller-friendly functions

```bash
log()  { printf '%s\n' "$*" >&2; }          # diagnostics to stderr, not stdout
die()  { printf 'error: %s\n' "$*" >&2; exit 1; }

backup() {
  local src="${1:?usage: backup <src>}"     # required-arg guard
  [[ -e "$src" ]] || die "no such path: $src"
  ...
}
```

Send logs/prompts to **stderr** so they don't pollute a function's stdout "return value" when the caller does `x=$(backup ...)`.

## How I use it

- `name()` form, every working variable `local`, args via `"$@"`.
- Result printed to stdout; `return`/exit status for success/failure only.
- `log`/`die` helpers writing to stderr; `${1:?usage}` to guard required args.
- Split `local x; x=$(cmd) || return 1` when the command's exit status matters.

## Links

- [Bash manual — Shell Functions](https://www.gnu.org/software/bash/manual/bash.html#Shell-Functions)
