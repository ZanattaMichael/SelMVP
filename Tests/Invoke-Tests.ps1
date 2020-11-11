# Invoke the Loader
. ..\Build\LocalLoader.ps1

# Set the FilePath
$Script:TestRootPath = Split-Path $MyInvocation.MyCommand.Path -Parent

# Invoke the Pester Tests
Invoke-Pester -Path 'Private'
Invoke-Pester -Path 'Public'

# Clear the Variable
Remove-Variable TestRootPath -Scope Script 