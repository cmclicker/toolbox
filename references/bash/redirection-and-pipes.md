# Redirection, pipes, and here-docs

**TL;DR:** Every process has three standard streams: stdin (0), stdout (1), stderr (2). Redirection wires these to files or each other; pipes wire one command's stdout to the next's stdin. The classic gotcha is order: `2>&1` means "make stderr go wherever stdout currently goes," so `>file 2>&1` captures both but `2>&1 >file` does not.

## The three streams

| FD | Name | Default |
|---|---|---|
| 0 | stdin | keyboard |
| 1 | stdout | terminal |
| 2 | stderr | terminal |

## File redirection

```bash
cmd > out.txt       # stdout to file (truncate/create)
cmd >> out.txt      # stdout appended
cmd 2> err.txt      # stderr to file
cmd < in.txt        # stdin from file
cmd > out 2> err    # stdout and stderr to separate files
```

## Combining stdout and stderr

```bash
cmd > both.txt 2>&1   # BOTH to both.txt  (order matters — see below)
cmd &> both.txt       # Bash shorthand for the same
cmd 2>&1 | less       # send both down a pipe (pipe only takes stdout otherwise)
cmd 2>/dev/null       # discard stderr
cmd >/dev/null 2>&1   # discard everything
```

**Order matters.** `2>&1` copies stdout's *current* destination to stderr.

- `cmd > file 2>&1` — stdout → file, then stderr → (where stdout points) = file. ✅ both in file.
- `cmd 2>&1 > file` — stderr → (where stdout points) = terminal, then stdout → file. ❌ stderr still on terminal.

Read it left to right as "point this stream where that one currently goes."

## Pipes

A pipe connects the **stdout** of the left command to the **stdin** of the right one:

```bash
ps aux | grep node | awk '{print $2}'
```

Notes:

- Pipes carry stdout only; add `2>&1` (or `|&` in Bash) to also pipe stderr.
- Each stage runs in a **subshell**, so variables set inside the last stage of `... | while read` don't persist after the loop. Use process substitution or a here-string to avoid this (below).
- `set -o pipefail` makes a pipeline fail if *any* stage fails, not just the last — important for error handling ([error-handling.md](error-handling.md)).

## Here-docs and here-strings

Feed multi-line or fixed input to a command's stdin without a temp file:

```bash
cat <<EOF            # here-doc: expands $vars and $(cmd)
user=$USER
EOF

cat <<'EOF'          # quoted delimiter: NO expansion (literal)
$PATH stays literal
EOF

cat <<-EOF           # <<- strips leading TABS (lets you indent the body)
	indented with tabs
	EOF

grep foo <<< "$text" # here-string: feed one string as stdin
```

Quoting the delimiter (`<<'EOF'`) is the switch between "interpolate" and "literal" — the same distinction as single vs. double quotes.

## Process substitution

`<(cmd)` presents a command's output as a filename, letting you feed command output where a file is expected — and avoiding the subshell-variable-loss pipe problem:

```bash
diff <(sort a.txt) <(sort b.txt)     # compare two commands' outputs
while read -r line; do count=$((count+1)); done < <(grep foo log)
echo "$count"   # persists — the while ran in the current shell, not a pipe subshell
```

## How I use it

- `>file 2>&1` (or `&>file`) to capture everything; `2>/dev/null` to silence expected stderr.
- `set -o pipefail` in scripts so pipeline failures aren't swallowed.
- Process substitution `< <(cmd)` for `while read` loops so counters/vars survive the loop.
- Quoted here-doc delimiter when the body must stay literal (embedding config/scripts).

## Links

- [Bash manual — Redirections](https://www.gnu.org/software/bash/manual/bash.html#Redirections)
- [BashGuide — Input and Output](https://mywiki.wooledge.org/BashGuide/InputAndOutput)
