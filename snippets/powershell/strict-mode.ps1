# PowerShell "strict mode" header. Paste at the top of a script.
# Equivalent intent to bash's `set -euo pipefail`. Reference:
#   ../../references/powershell/error-handling.md

#requires -Version 7.0          # remove or lower if the script must run on 5.1

Set-StrictMode -Version Latest  # error on unset variables, bad property refs, bad syntax
$ErrorActionPreference = 'Stop' # make non-terminating errors terminating (fail fast)
$PSNativeCommandUseErrorActionPreference = $true  # (7.3+) native non-zero exit -> terminating

# Native .exe failures don't throw on their own under 5.1 / older 7 — guard them:
#   git push
#   if ($LASTEXITCODE -ne 0) { throw "git push failed ($LASTEXITCODE)" }

# Wrap risky work so cleanup/reporting is reliable:
try {
    # ... script body ...
}
catch {
    Write-Error "failed: $($_.Exception.Message)"
    exit 1
}
finally {
    # cleanup that must always run
}
