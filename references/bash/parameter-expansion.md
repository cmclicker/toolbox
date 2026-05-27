# Parameter expansion

**TL;DR:** Bash can transform a variable's value as it expands it — defaults, substring removal, search/replace, length, case — without calling external tools like `sed`/`basename`. Knowing these makes scripts shorter, faster, and more portable. All forms use `${...}` (braces required for anything beyond a bare `$var`).

> Every result below is verified against Bash for the example `v="path/to/file.tar.gz"`.

## Defaults and presence

| Form | Meaning |
|---|---|
| `${var:-word}` | use `word` if `var` is unset or empty; `var` unchanged |
| `${var:=word}` | use `word` and **assign** it to `var` if unset/empty |
| `${var:+word}` | use `word` only if `var` **is** set/non-empty (else empty) |
| `${var:?msg}` | error out with `msg` if `var` is unset/empty (guard required vars) |

```bash
port="${PORT:-8080}"          # fallback default
: "${API_KEY:?must be set}"   # fail fast if a required var is missing
```

(Omit the `:` — `${var-word}` — to test only *unset*, treating empty as set.)

## Substring removal (prefix/suffix)

`#` trims from the **front**, `%` from the **back**; doubled (`##`/`%%`) trims the **longest** match instead of the shortest. Patterns are globs, not regex.

```bash
v="path/to/file.tar.gz"
${v##*/}    # file.tar.gz   → basename  (strip longest leading */)
${v%/*}     # path/to       → dirname   (strip shortest trailing /*)
${v%.gz}    # path/to/file.tar          (strip the .gz suffix)
${v%%.*}    # path/to/file              (strip from the FIRST dot to end)
${v##*.}    # gz                        (the extension)
```

Mnemonic: `#` is left of `$` on the keyboard (front); `%` is right (back).

## Search and replace

```bash
${v/from/to}    # replace FIRST match
${v//from/to}   # replace ALL matches
${v/#from/to}   # replace only if at the START (anchored)
${v/%from/to}   # replace only if at the END (anchored)
${v//\//_}      # path_to_file.tar.gz  (replace all / with _)
```

## Length, substring, case

```bash
${#v}        # 19         (length in characters)
${v:8:4}     # file       (substring: offset 8, length 4)
${v:(-2)}    # gz         (last 2 chars; space/parens needed before negative)
${v^^}       # PATH/TO/FILE.TAR.GZ   (uppercase all)
${v,,}       # lowercase all
${v^}        # uppercase first char only
```

## Indirection and listing

```bash
name=v; echo "${!name}"   # value of the variable NAMED by $name (indirect)
${!prefix*}               # names of all variables starting with `prefix`
```

(Array expansions like `${arr[@]}`, `${#arr[@]}`, `${!arr[@]}` are in [arrays.md](arrays.md).)

## How I use it

- `${var:-default}` and `${var:?msg}` for config/argument handling instead of `if` blocks.
- `${path##*/}` / `${path%/*}` instead of spawning `basename`/`dirname` — faster and dependency-free in a loop.
- `${v%.ext}` to swap extensions; `${v//x/y}` for replacements instead of `sed` on a single variable.
- Reach for `sed`/`awk` only when the transformation is genuinely beyond globs (real regex, multi-line).

## Links

- [Bash manual — Shell Parameter Expansion](https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion)
