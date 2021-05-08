param([Switch]$CI)

$Location = Split-Path -Path (Get-Location) -Leaf
# Is the Executing Path of the Script inside the Tests Directory
if ($Location -eq 'Tests') {
    # Update the Root Path
    $RootPath = Split-Path -Path (Get-Location) -Parent
} else {
    $RootPath = (Get-Location).Path
}

# Set a Script Variable that sets the tests root path. This is used in Mocking with HTML
$Global:TestRootPath = Join-Path -Path $RootPath -ChildPath "Tests"
$UpdatedPath = Join-Path -Path $RootPath -ChildPath 'build\LocalLoader.ps1' 

if ($IsCoreCLR -and $CI) {
    $UpdatedPath = $UpdatedPath.Replace('/SelMVP/SelMVP/', '/SelMVP/')
}

# Invoke the Local Loader and Point it to the Module Directory
. $UpdatedPath $RootPath

# Import the Selenium Module
Import-Module Selenium -ErrorAction Stop

# Invoke the Pester Tests
Invoke-Pester -Path (Join-Path -Path $Global:TestRootPath -ChildPath 'Private') -CI:$CI
Invoke-Pester -Path (Join-Path -Path $Global:TestRootPath -ChildPath 'Public') -CI:$CI

# Clear the Variable
Remove-Variable TestRootPath -Scope Script 