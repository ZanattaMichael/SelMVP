$VerbosePreference = 'Continue'

$TestsPath = (Split-Path $PSCommandPath -Parent) -Replace "Build","Tests"
# DotSource Functions
Write-Verbose $Path

Invoke-Pester -Path $Path