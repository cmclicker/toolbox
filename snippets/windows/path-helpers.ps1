# PowerShell helpers for editing PATH safely on Windows. Dot-source or paste into
# $PROFILE. Background: ../../references/windows/environment-variables-and-path.md
#
# Why these exist: the common mistakes are (1) overwriting PATH instead of
# appending, (2) reassembling PATH from $env:PATH (the MERGED value) and writing
# it back to one scope, duplicating Machine entries into User, and (3) using setx,
# which truncates PATH at 1024 chars. These read the correct scope and append.

# Append a directory to the persisted User PATH (idempotent; no admin needed).
function Add-ToUserPath {
    param([Parameter(Mandatory)][string]$Directory)
    $resolved = Resolve-Path -LiteralPath $Directory -ErrorAction SilentlyContinue
    $dir = if ($resolved) { $resolved.Path } else { $Directory }   # 5.1- and 7-safe
    $user = [Environment]::GetEnvironmentVariable('PATH', 'User')
    if (($user -split ';' | Where-Object { $_ }) -notcontains $dir) {
        $newValue = if ($user) { "$user;$dir" } else { $dir }
        [Environment]::SetEnvironmentVariable('PATH', $newValue, 'User')
        Write-Host "Added to User PATH: $dir (open a new terminal, or run Update-SessionPath)"
    } else {
        Write-Host "Already on User PATH: $dir"
    }
}

# Refresh the CURRENT session's PATH from the persisted Machine+User scopes,
# so a just-installed tool is found without opening a new terminal.
function Update-SessionPath {
    $machine = [Environment]::GetEnvironmentVariable('PATH', 'Machine')
    $user    = [Environment]::GetEnvironmentVariable('PATH', 'User')
    $env:PATH = (@($machine, $user) | Where-Object { $_ }) -join ';'
    Write-Host "Session PATH refreshed ($(($env:PATH -split ';' | Where-Object {$_}).Count) entries)."
}

# These helpers use only syntax valid on both Windows PowerShell 5.1 and PowerShell 7+.
