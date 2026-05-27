# Text-processing tools (grep, sed, awk, find, and friends)

**TL;DR:** The Unix philosophy is small tools that read text on stdin and write to stdout, composed with pipes. The core set — `grep` (search), `sed` (stream-edit), `awk` (field processing), `find` (locate files), `xargs` (build commands from input), plus `sort`/`uniq`/`cut`/`wc`/`tr` — covers most data-wrangling on the command line. Learn these and you rarely need to write a script for ad-hoc text work.

## `grep` — search lines

```bash
grep "pattern" file              # matching lines
grep -r "TODO" src/              # recursive
grep -i "error" log              # case-insensitive
grep -n "func" file              # show line numbers
grep -v "debug" log              # invert: lines NOT matching
grep -E "foo|bar" file           # extended regex (alternation)
grep -c "warn" log               # count matches
grep -l "needle" *.txt           # just the filenames that match
```

(`rg`/ripgrep is a faster modern alternative with the same spirit — see [resources](../../resources/linux/README.md).)

## `sed` — stream editing

```bash
sed 's/old/new/' file            # replace FIRST match per line
sed 's/old/new/g' file           # replace ALL matches per line
sed -i 's/old/new/g' file        # edit the file IN PLACE (no output)
sed -n '10,20p' file             # print only lines 10–20
sed '/pattern/d' file            # delete matching lines
```

`sed -i` rewrites the file — test without `-i` first. (BSD/macOS `sed -i` needs an argument: `sed -i '' ...`; GNU/Linux doesn't.)

## `awk` — field-oriented processing

`awk` splits each line into fields (`$1`, `$2`, …; `$0` is the whole line) on whitespace by default:

```bash
awk '{print $1}' file            # first field of each line
awk -F: '{print $1}' /etc/passwd # custom field separator (:)
awk '$3 > 100 {print $1, $3}' f  # condition + multiple fields
awk '{sum += $1} END {print sum}' f   # accumulate, print at end
ps aux | awk '$3 > 50'           # rows where %CPU > 50
```

Reach for `awk` when you need columns or arithmetic across lines; `cut` (below) for simpler column extraction.

## `find` — locate files (and act on them)

```bash
find . -name "*.log"             # by name (glob)
find . -type f -mtime -1         # files modified in the last day
find . -type d -name node_modules # directories
find . -name "*.tmp" -delete     # delete matches
find . -name "*.js" -exec grep -l TODO {} +   # run a command per result
```

`-type f`/`d`, `-name`, `-mtime`/`-size`, and `-exec ... {} +` (or pipe to `xargs`) are the workhorses.

## `xargs` — turn input into command arguments

```bash
find . -name "*.log" | xargs rm           # rm each found file
find . -name "*.log" -print0 | xargs -0 rm  # SAFE for names with spaces
grep -rl TODO . | xargs sed -i 's/TODO/DONE/g'
ls *.txt | xargs -I{} cp {} backup/{}      # placeholder form
```

Use `find -print0 | xargs -0` (NUL-separated) for filenames that may contain spaces — the default whitespace splitting breaks on them, the same hazard as in [../bash/quoting-and-word-splitting.md](../bash/quoting-and-word-splitting.md).

## The connective tissue: sort, uniq, cut, wc, tr

```bash
cut -d: -f1 /etc/passwd          # field 1 by delimiter :
sort file | uniq -c | sort -rn   # count + rank unique lines (top offenders)
wc -l file                       # line count
tr 'a-z' 'A-Z' < file            # translate/clean characters
head -20 file ; tail -f log      # first lines ; follow a growing file
```

`sort | uniq -c | sort -rn` is the classic "what are the most frequent values" pipeline.

## How I use it

- `grep -rn` to find things; `rg` when a repo is large.
- `awk '{print $N}'` for columns, `cut -d -f` for simple delimited extraction, `awk` when arithmetic/conditions are involved.
- `find ... -print0 | xargs -0 ...` to act on many files safely; `sed -i` only after testing without `-i`.
- `sort | uniq -c | sort -rn` to rank frequencies (top IPs in a log, most-changed files, etc.).

## Links

- [GNU Coreutils manual](https://www.gnu.org/software/coreutils/manual/)
- [`grep`](https://man7.org/linux/man-pages/man1/grep.1.html) · [`sed`](https://man7.org/linux/man-pages/man1/sed.1.html) · [`awk`](https://man7.org/linux/man-pages/man1/awk.1p.html) · [`find`](https://man7.org/linux/man-pages/man1/find.1.html)
