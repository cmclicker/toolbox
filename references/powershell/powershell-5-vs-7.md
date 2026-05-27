# Windows PowerShell 5.1 vs. PowerShell 7+

**TL;DR:** There are two PowerShells. **Windows PowerShell 5.1** (`powershell.exe`, "Desktop" edition) ships in Windows and is frozen — no new features. **PowerShell 7+** (`pwsh.exe`, "Core" edition) is the actively-developed, cross-platform, separately-installed successor. They coexist. Scripts that must run on a stock Windows box (or under a tool pinned to 5.1) have to avoid 7-only syntax: `&&`/`||`, ternary `? :`, null-coalescing `??`/`?.`, and several newer cmdlet parameters are **5.1 parser/runtime errors**.

## Which one am I in?

```powershell
$PSVersionTable.PSVersion     # 5.1.x  vs  7.x
$PSVersionTable.PSEdition     # Desktop (5.1)  vs  Core (7+)
```

(Verified here: `5.1.26100`, edition `Desktop`.) `powershell` launches 5.1; `pwsh` launches 7+ if installed. Install 7 via `winget install Microsoft.PowerShell`; it installs side-by-side, it does not replace 5.1.

## What's 7-only (and breaks under 5.1)

| Feature | 7+ | 5.1 equivalent |
|---|---|---|
| Pipeline chain `A && B` / `A \|\| B` | ✅ | use `if ($?) { B }` / explicit `if` |
| Ternary `cond ? a : b` | ✅ | `if (cond) { a } else { b }` |
| Null-coalescing `$x ?? 'd'` | ✅ | `if ($null -ne $x) { $x } else { 'd' }` |
| Null-conditional `$x?.Prop` | ✅ | explicit `$null -ne $x` check |
| `ConvertFrom-Json -AsHashtable` | ✅ | not available in 5.1 (verified) — parse to PSCustomObject |
| `Get-Error`, parallel `ForEach-Object -Parallel` | ✅ | absent |

These aren't "discouraged" in 5.1 — `&&`, ternary, etc. are **syntax errors** the 5.1 parser rejects outright, so a single such line fails the whole script.

## Other behavioral differences that bite

- **Default output encoding.** 5.1's `Out-File`/`Set-Content`/`>` default to **UTF-16 LE (with BOM)**; 7+ defaults to **UTF-8 (no BOM)**. When writing files other tools will read under 5.1, pass `-Encoding utf8` explicitly. (See [strings-and-quoting.md](strings-and-quoting.md).)
- **`ConvertFrom-Json`** returns a `PSCustomObject` in both; `-AsHashtable` (7+) is unavailable in 5.1.
- **Cross-platform.** 7+ runs on Linux/macOS; 5.1 is Windows-only. Path separators, case sensitivity, and available cmdlets differ accordingly.
- **Module compatibility.** Some old Windows-only modules work only in 5.1 (7 offers a `-UseWindowsPowerShell` compatibility shim); most modern modules target 7.

## Practical guidance

- **Target 7+ for your own work** — install it (`pwsh`), set your terminal to use it, and enjoy the modern syntax and speed.
- **Write to the 5.1 floor only when you must** — scripts that run on un-provisioned Windows machines, in `powershell.exe`-pinned tooling, or under automation you don't control. In that case avoid every 7-only feature above and test under `powershell.exe`, not `pwsh`.
- **Declare your requirement** at the top of a script so it fails clearly on the wrong host:
  ```powershell
  #requires -Version 7.0
  ```

## How I use it

- Default to `pwsh` (7+) for interactive work and personal scripts; `#requires -Version 7.0` to make the dependency explicit.
- Drop to the 5.1-safe subset (no `&&`/ternary/`??`, explicit `-Encoding utf8`) only for scripts that must run on stock Windows.
- Check `$PSVersionTable` first when a script "works on my machine but not theirs" — it's often a 5.1-vs-7 gap.

## Links

- [What's new in PowerShell 7](https://learn.microsoft.com/en-us/powershell/scripting/whats-new/what-s-new-in-powershell-70)
- [Migrating from Windows PowerShell 5.1 to PowerShell 7](https://learn.microsoft.com/en-us/powershell/scripting/whats-new/migrating-from-windows-powershell-51-to-powershell-7)
