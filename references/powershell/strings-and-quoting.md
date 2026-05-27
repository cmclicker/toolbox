# Strings, quoting, and formatting

**TL;DR:** Double-quoted strings **interpolate** (`"hi $name"`); single-quoted strings are **literal** (`'hi $name'` stays `$name`). For property/expression interpolation use `"$($obj.Prop)"`. Here-strings (`@"..."@`) hold multi-line text. The `-f` format operator and `[math]`/`.ToString()` handle number/date formatting. On Windows PowerShell 5.1, remember files are written as UTF-16 unless you pass `-Encoding utf8`.

## Quoting

```powershell
$name = 'Cody'
"hello $name"            # hello Cody         (double quotes interpolate)
'hello $name'            # hello $name        (single quotes are literal)
"path is $env:USERPROFILE"   # env vars interpolate too
```

To interpolate anything beyond a bare `$var` — a property, index, or expression — wrap it in `$( )`:

```powershell
"first proc: $($procs[0].Name)"     # subexpression
"total: $($a + $b)"
"literal dollar: `$5"                # backtick escapes inside double quotes
```

The backtick `` ` `` is PowerShell's escape character (not backslash): `` `n `` newline, `` `t `` tab, `` `$ `` literal dollar.

## Here-strings (multi-line)

```powershell
$literal = @'
No $interpolation here.
Quotes " ' are fine.
'@                       # single-quoted here-string: literal

$expanded = @"
User: $name
Home: $($env:USERPROFILE)
"@                       # double-quoted here-string: interpolates
```

The opening `@'`/`@"` must end the line; the closing `'@`/`"@` must be at **column 0** (no leading whitespace) on its own line. Here-strings are the clean way to embed JSON, SQL, or another script as text.

## Formatting numbers and dates

```powershell
'{0,-10} {1,8:N2}' -f $name, 1234.5      # field width + 2-decimal number
"{0:P1}" -f 0.1234                        # 12.3%
(Get-Date).ToString('yyyy-MM-dd HH:mm')   # explicit date format
[math]::Round($bytes / 1MB, 2)            # 1KB/1MB/1GB are built-in multipliers
```

The `-f` operator uses .NET composite formatting: `{index,alignment:format}`.

## File encoding (the 5.1 trap)

Windows PowerShell 5.1 writes **UTF-16 LE with BOM** by default from `Out-File`, `Set-Content`, `Add-Content`, and `>`. Tools expecting UTF-8 (git, most parsers) then see a BOM or wide chars. Always specify encoding when writing files other tools read:

```powershell
$text | Set-Content out.txt -Encoding utf8     # 5.1: UTF-8 *with* BOM; 7+: no BOM
$text | Out-File out.txt -Encoding utf8
```

PowerShell 7+ defaults to UTF-8 (no BOM), so this matters most under 5.1 — see [powershell-5-vs-7.md](powershell-5-vs-7.md). (In 5.1, `utf8` still emits a BOM; for strictly BOM-free output use .NET `[System.IO.File]::WriteAllText($path,$text,[System.Text.UTF8Encoding]::new($false))`.)

## How I use it

- Single quotes by default; double quotes only when interpolating; `"$($x.Prop)"` for anything non-trivial.
- Here-strings (single-quoted unless I need interpolation) for embedded JSON/SQL/scripts, closing `'@` at column 0.
- `-Encoding utf8` on every file write under 5.1 so other tools can read it.
- `-f` and `.ToString(format)` for output formatting instead of string concatenation.

## Links

- [about_Quoting_Rules](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_quoting_rules)
- [about_Special_Characters](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_special_characters)
