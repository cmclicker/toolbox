# Paths and the filesystem on Windows

**TL;DR:** Windows paths use drive letters (`C:\`) and historically backslashes, though most APIs and shells now accept forward slashes too. The filesystem is **case-insensitive** (but case-preserving). Two long-standing traps: the legacy **260-character path limit** (`MAX_PATH`) and a set of **reserved filenames** (`CON`, `NUL`, `PRN`, `COM1`…) that can't be used. Special folders are referenced by environment variables (`%USERPROFILE%`, `%APPDATA%`).

## Path forms

| Form | Example | Notes |
|---|---|---|
| Absolute (drive) | `C:\Users\me\file.txt` | rooted at a drive letter |
| Forward slashes | `C:/Users/me/file.txt` | accepted by Windows APIs and PowerShell/most tools |
| UNC (network) | `\\server\share\file` | no drive letter |
| Relative | `..\sibling\file` | resolved against the working directory |
| Extended-length | `\\?\C:\very\long\...` | opts out of `MAX_PATH` (API-level) |

In code, build paths with helpers rather than string-concatenating: PowerShell `Join-Path`/`Split-Path` ([../powershell/providers-and-filesystem.md](../powershell/providers-and-filesystem.md)), Node `path.join`, Python `os.path`/`pathlib`. They handle the separator and avoid double-slash bugs.

## Case-insensitive but case-preserving

`File.txt` and `file.txt` refer to the same file on a default NTFS volume, but the original casing is stored and shown. This bites cross-platform projects: a Git repo that works on Windows can break on Linux (case-sensitive) if two files differ only by case, or if an import's casing doesn't match the filename. Match casing exactly in imports/paths to stay portable. (WSL can enable per-directory case sensitivity — see [wsl.md](wsl.md).)

## The 260-character limit (`MAX_PATH`)

Historically a full path couldn't exceed ~260 characters, which broke deep `node_modules` trees and nested builds. Two fixes:

- **Enable long paths** (Windows 10 1607+): set the policy/registry `LongPathsEnabled=1`, after which modern apps and tools (including Git: `git config --system core.longpaths true`) can exceed 260.
- Keep project roots **short** (`C:\src\proj`, not deep under `Documents`) to avoid hitting it at all.

## Reserved names and illegal characters

These device names can't be used as a file/folder name (with or without extension): `CON`, `PRN`, `AUX`, `NUL`, `COM1`–`COM9`, `LPT1`–`LPT9`. Illegal characters in names: `< > : " / \ | ? *`. A repo containing a file named `aux.js` or `nul` (legal on Linux) can fail to check out on Windows — worth knowing when a clone mysteriously errors.

## Special folders (use the variables, not hardcoded paths)

| Variable | Typical location | For |
|---|---|---|
| `%USERPROFILE%` | `C:\Users\<you>` | home directory |
| `%APPDATA%` | `…\AppData\Roaming` | per-user config that roams |
| `%LOCALAPPDATA%` | `…\AppData\Local` | per-user, machine-local data/cache |
| `%PROGRAMDATA%` | `C:\ProgramData` | all-users app data |
| `%TEMP%` | `…\AppData\Local\Temp` | scratch files |

Reference these via the variable (`$env:APPDATA`, `%APPDATA%`) so paths work across machines and user names. In PowerShell, `[Environment]::GetFolderPath('ApplicationData')` resolves them programmatically.

## Forward vs. back slashes in practice

- **Shells/tools:** PowerShell, Git, Node, Python all accept `/`. Using `/` in scripts improves cross-platform portability.
- **`cmd` and some Windows-native args:** may require `\`.
- **Display/UNC:** Windows shows `\`; UNC requires `\\`.

## How I use it

- Build paths with `Join-Path`/`path.join`/`pathlib`, prefer `/` in code for portability.
- Short project roots (`C:\src\...`) and `core.longpaths true` to dodge `MAX_PATH`.
- Match filename casing exactly; avoid reserved names in repos that also run on Linux.
- `$env:LOCALAPPDATA` / special-folder APIs instead of hardcoding `C:\Users\...`.

## Links

- [Naming Files, Paths, and Namespaces (MS Learn)](https://learn.microsoft.com/en-us/windows/win32/fileio/naming-a-file)
- [Maximum Path Length Limitation](https://learn.microsoft.com/en-us/windows/win32/fileio/maximum-file-path-limitation)
