# Register tab-completion for a command's parameter. Drop into your $PROFILE so
# pressing Tab on the target parameter suggests/filters values.
# Reference: ../../references/powershell/cmdlets-and-discovery.md

# Example: complete a -Environment parameter for a hypothetical Deploy-App command.
Register-ArgumentCompleter -CommandName Deploy-App -ParameterName Environment -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $boundParameters)

    # Produce candidates (could come from a file, API, etc.); filter by what's typed.
    @('dev', 'staging', 'production') |
        Where-Object { $_ -like "$wordToComplete*" } |
        ForEach-Object {
            # CompletionResult: completionText, listItemText, resultType, tooltip
            [System.Management.Automation.CompletionResult]::new(
                $_, $_, 'ParameterValue', "Deploy to $_"
            )
        }
}

# Native-command completion (e.g. completing subcommands of an external CLI) uses
# the same cmdlet with -Native and -CommandName <exe>.
