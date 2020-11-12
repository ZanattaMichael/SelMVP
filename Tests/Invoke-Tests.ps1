$Location = Split-Path -Path (Get-Location) -Leaf
# Is the Executing Path of the Script inside the Tests Directory
if ($Location -eq 'Tests') {
    # Update the Root Path
    $RootPath = Split-Path -Path (Get-Location) -Parent
} else {
    $RootPath = (Get-Location).Path
}

$UpdatedPath = Join-Path -Path $RootPath -ChildPath 'build\LocalLoader.ps1' 

# Set a Script Variable that sets the tests root path. This is used in Mocking with HTML
$Script:TestRootPath = Join-Path -Path $RootPath -ChildPath "Tests"

# Set the FilePath
. $UpdatedPath $RootPath

# Import the Selenium Module
Import-Module Selenium

# Invoke the Pester Tests
Invoke-Pester -Path (Join-Path -Path $Script:TestRootPath -ChildPath 'Private')
#Invoke-Pester -Path (Join-Path -Path $Script:TestRootPath -ChildPath 'Public')

# Clear the Variable
Remove-Variable TestRootPath -Scope Script 