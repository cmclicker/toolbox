# Objects and the pipeline

**TL;DR:** PowerShell's defining feature: the pipeline passes **.NET objects**, not text. `Get-Process` hands the next command real `Process` objects with typed properties — so you filter and sort on properties (`Where-Object CPU -gt 100`) instead of parsing columns of text like in Bash. This is why PowerShell needs far less `awk`/`sed`/`cut`: the structure is already there.

## Objects, not text

In Bash, `ps | grep node | awk '{print $2}'` slices text by column position. In PowerShell the pipeline carries objects, so you ask for the property by name:

```powershell
Get-Process | Where-Object Name -eq node | Select-Object Id, CPU
```

Each item is a `System.Diagnostics.Process` (verified), not a line of text. No column counting, no fragile field splitting.

## Discovering an object's shape: `Get-Member`

The most important habit in PowerShell — when you don't know what you've got, pipe it to `Get-Member` to see its type, properties, and methods:

```powershell
Get-Process | Get-Member            # type + all properties/methods
Get-Process | Select-Object -First 1 | Format-List *   # see every property's value
```

Once you know the property names, the rest of the pipeline writes itself.

## The core pipeline cmdlets

| Cmdlet | Alias | Does |
|---|---|---|
| `Where-Object` | `?` | filter objects by a condition |
| `Select-Object` | `select` | pick properties, or `-First/-Last N`, or `-Unique` |
| `Sort-Object` | `sort` | sort by property |
| `ForEach-Object` | `%` | run a script block per object |
| `Group-Object` | `group` | group by property value |
| `Measure-Object` | `measure` | count/sum/average a property |

```powershell
Get-ChildItem -File |
  Where-Object Length -gt 1MB |
  Sort-Object Length -Descending |
  Select-Object Name, @{ n='MB'; e={ [math]::Round($_.Length/1MB, 2) } }
```

`$_` (or `$PSItem`) is the current pipeline object inside a `Where-Object`/`ForEach-Object` block. The `@{ n=...; e={...} }` is a **calculated property** — a computed column.

## `ForEach-Object` vs the `foreach` statement

Two different things with similar names:

- **`ForEach-Object`** (pipeline cmdlet) — processes objects **streaming**, one at a time as they arrive. Use mid-pipeline.
- **`foreach (... in ...)`** (language statement) — iterates an in-memory collection; faster for an array you already hold, but it materializes everything first.

```powershell
1..3 | ForEach-Object { $_ * 2 }     # pipeline, streaming
foreach ($n in 1..3) { $n * 2 }       # statement, collection in memory
```

## Output is objects too

A function/cmdlet "returns" by emitting objects to the pipeline (not by `return` of text). `Format-*` cmdlets (`Format-Table`, `Format-List`) are for **display only** — never pipe their output to further processing; they emit formatting objects, not data. Keep `Format-*` at the very end of a pipeline.

## How I use it

- `... | Get-Member` whenever I'm unsure what properties exist — it's the entry point to everything.
- Filter/sort on **properties** (`Where-Object X -gt N`), not by parsing text.
- `Format-Table`/`Format-List` only as the final, display step.
- `ForEach-Object` mid-pipeline; the `foreach` statement for arrays already in memory.

## Links

- [about_Pipelines](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_pipelines)
- [about_Objects](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_objects)
