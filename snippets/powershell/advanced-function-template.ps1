# Advanced function template: parameter validation, pipeline input, -WhatIf/-Confirm,
# -Verbose. `[CmdletBinding()]` turns a plain function into one that behaves like a
# compiled cmdlet (common parameters, $PSCmdlet). Reference:
#   ../../references/powershell/cmdlets-and-discovery.md
#   ../../references/powershell/error-handling.md

function Set-Widget {
    # SupportsShouldProcess gives free -WhatIf / -Confirm.
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        # Required, accepts pipeline input by property name; rejects null/empty.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        # Constrained to a fixed set — invalid values fail before the body runs.
        [Parameter()]
        [ValidateSet('Low', 'Medium', 'High')]
        [string]$Priority = 'Medium',

        [Parameter()]
        [ValidateRange(1, 100)]
        [int]$Count = 1
    )

    begin { Write-Verbose "Set-Widget starting (priority=$Priority)" }

    process {
        # Honor -WhatIf/-Confirm for state-changing actions.
        if ($PSCmdlet.ShouldProcess($Name, "Set widget x$Count")) {
            Write-Verbose "Applying to '$Name'"
            [pscustomobject]@{ Name = $Name; Priority = $Priority; Count = $Count }
        }
    }

    end { Write-Verbose "Set-Widget done" }
}

# Usage:
#   'a','b' | Set-Widget -Priority High -Verbose
#   Set-Widget -Name x -WhatIf
