# PSScriptAnalyzer settings. Copy to a project root as PSScriptAnalyzerSettings.psd1,
# then lint with:  Invoke-ScriptAnalyzer -Path . -Recurse -Settings ./PSScriptAnalyzerSettings.psd1
# PSScriptAnalyzer is PowerShell's linter (the ShellCheck equivalent). Reference:
#   ../../references/powershell/error-handling.md  ../../checklists/powershell/script-review.md

@{
    # Run all default rules...
    IncludeDefaultRules = $true
    Severity            = @('Error', 'Warning', 'Information')

    # ...with a few high-value rules called out explicitly.
    Rules = @{
        # Flags `$x -eq $null` (should be `$null -eq $x`) — the array-filtering trap.
        PSPossibleIncorrectComparisonWithNull = @{ Enable = $true }
        # Discourages aliases (gci/ls) in scripts; prefer full cmdlet names.
        PSAvoidUsingCmdletAliases             = @{ Enable = $true }
        # Encourages approved Verb-Noun function names.
        PSUseApprovedVerbs                    = @{ Enable = $true }
        # Catches Write-Host where pipeline output/Write-Verbose is more appropriate.
        PSAvoidUsingWriteHost                 = @{ Enable = $true }
    }

    # Example of excluding a rule project-wide if it doesn't fit:
    # ExcludeRules = @('PSUseShouldProcessForStateChangingFunctions')
}
