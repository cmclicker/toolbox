# Arrays

**TL;DR:** Bash has indexed arrays (`arr=(a b c)`) and associative arrays (`declare -A m`). They're the correct way to hold lists and maps — far safer than space-separated strings, which break on whitespace. The one rule that matters: expand with `"${arr[@]}"` (quoted, `@`) to get each element as a separate, intact word.

## Indexed arrays

```bash
arr=(alpha beta "two words")     # create
arr+=(gamma)                     # append
arr[10]="sparse"                 # indices can be sparse

echo "${arr[0]}"                 # one element
echo "${arr[@]}"                 # all elements (each a separate word when quoted)
echo "${#arr[@]}"                # count: 4 (sparse indices don't pad the count)
echo "${!arr[@]}"                # the indices: 0 1 2 3 10
echo "${arr[@]:1:2}"             # slice: 2 elements starting at index 1
```

**Always `"${arr[@]}"` quoted with `@`** to iterate or pass an array:

```bash
for item in "${arr[@]}"; do echo "$item"; done   # "two words" stays one item
some-command "${arr[@]}"                          # each element a separate argument
```

`"${arr[*]}"` (star) joins everything into one word using the first char of `IFS` — occasionally useful for display, almost never for iteration.

## Associative arrays (maps)

Require `declare -A` first (Bash 4+):

```bash
declare -A color
color[apple]=red
color[lime]=green
echo "${color[apple]}"           # red
echo "${!color[@]}"              # keys
echo "${color[@]}"              # values
echo "${#color[@]}"             # number of entries
[[ -v color[apple] ]] && echo "key exists"   # test for a key
```

**Key order is not preserved** — associative arrays are unordered (verified: insertion order is not the iteration order). If you need ordered keys, keep a separate indexed array of keys.

## Building arrays from input

```bash
mapfile -t lines < file.txt          # each line → an element (no trailing newlines)
IFS=',' read -ra parts <<< "a,b,c"   # split a string on a delimiter into an array
files=( *.txt )                      # glob results into an array (safe for spaces)
```

`mapfile -t` (a.k.a. `readarray -t`) is the clean way to read a file or command output into an array line by line — better than a `for` loop over unquoted `$(cmd)`.

## Why arrays instead of strings

A space-separated string (`list="a b 'c d'"`) can't represent an element containing spaces, and every use risks word-splitting/globbing ([quoting-and-word-splitting.md](quoting-and-word-splitting.md)). An array stores elements distinctly and round-trips them safely through `"${arr[@]}"`. Any time you're tempted to keep a list in a plain variable, use an array.

## How I use it

- Arrays for any list — args to forward, files to process, accumulated results.
- `mapfile -t` to read lines; `"${arr[@]}"` to iterate or pass on.
- Associative arrays for lookups/sets; a parallel indexed array of keys when order matters.
- Build command arguments as an array (`args=(--flag "$val"); cmd "${args[@]}")` so optional/spaced args stay correct.

## Links

- [Bash manual — Arrays](https://www.gnu.org/software/bash/manual/bash.html#Arrays)
