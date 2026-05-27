# Variables, types, and operators

**TL;DR:** Variables are `$name`. PowerShell uses **word operators**, not symbols, for comparison: `-eq`, `-ne`, `-lt`, `-gt`, `-match`, `-like`. Comparisons against a collection **filter** it (return matching items) rather than returning a single boolean — which is why the correct null test is `$null -eq $x`, with `$null` on the **left**. Collections are arrays; key/value maps are hashtables.

## Variables and types

```powershell
$count = 5                 # inferred [int]
[int]$n = '42'             # explicit type; coerces the string
$items = @()               # empty array
$map = @{ a = 1; b = 2 }   # hashtable
```

Useful automatic variables: `$_`/`$PSItem` (current pipeline object), `$?` (did the last command succeed), `$LASTEXITCODE` (exit code of the last **native** exe), `$Error` (recent errors), `$args` (unbound args), `$PSScriptRoot` (the script's folder), `$null`, `$true`/`$false`.

## Comparison operators are words

| Operator | Meaning |
|---|---|
| `-eq` `-ne` | equal / not equal |
| `-lt` `-le` `-gt` `-ge` | numeric comparisons |
| `-like` `-notlike` | wildcard match (`*`, `?`) |
| `-match` `-notmatch` | **regex** match; sets `$matches` with captures |
| `-contains` `-in` | collection membership |
| `-replace` | regex search/replace |

```powershell
'file.txt' -like '*.txt'                 # True (wildcards)
'v1.2.3' -match '^v(\d+)\.(\d+)'         # True; $matches[1]=1, $matches[2]=2  (verified)
@('a','b') -contains 'b'                 # True
```

Add `i`/`c` for explicit case sensitivity: `-imatch` (insensitive, the default) / `-cmatch` (sensitive).

## The collection-filtering behavior (and `$null` placement)

When the **left** side is a collection, a comparison returns the **matching elements**, not `$true`/`$false`:

```powershell
@(1,2,3,2) -eq 2        # returns 2,2  (the matches), not True
(@(1,$null,3) -ne $null).Count   # 2  — filters out the null (verified)
```

This is why the correct null check puts `$null` on the **left**:

```powershell
if ($null -eq $x) { ... }    # correct: scalar comparison, real boolean
if ($x -eq $null) { ... }    # WRONG if $x is an array: filters it instead of testing
```

Make `$null -eq $x` a reflex. (PSScriptAnalyzer flags the reversed form.)

## Logical operators and arithmetic

```powershell
($a -gt 0) -and ($b -lt 10)      # -and -or -not -xor (words, not && ||)
-not $flag                       # or: !$flag
$total = ($a + $b) * 2           # arithmetic with normal symbols
```

`&&`/`||` (pipeline chain) exist only in PowerShell 7+ ([powershell-5-vs-7.md](powershell-5-vs-7.md)); the **logical** operators are always `-and`/`-or`.

## Arrays and hashtables

```powershell
$a = 1,2,3            # or @(1,2,3)
$a += 4               # arrays are fixed-size; += creates a NEW array (costly in big loops)
$a[0]; $a[-1]; $a[1..2]

$h = @{ name = 'cody'; count = 3 }
$h['name']; $h.name                # index or dot access
$h.Keys; $h.ContainsKey('name')
[ordered]@{ first = 1; second = 2 } # preserves insertion order (plain hashtables don't)
```

For heavy appending, use `[System.Collections.Generic.List[object]]` and `.Add()` instead of `+=` on an array.

## How I use it

- `$null -eq $x` always — never the reverse.
- Word operators throughout; remember a collection on the left of `-eq`/`-ne` filters rather than returns a bool.
- `[ordered]` hashtables when key order matters; a generic `List` instead of `+=` in loops.
- `-match` when I need captures (`$matches`); `-like` for simple wildcards.

## Links

- [about_Comparison_Operators](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comparison_operators)
- [about_Automatic_Variables](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_automatic_variables)
