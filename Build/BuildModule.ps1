#Requires -Version 7.0

Write-Verbose "Building PowerShell Module"

$BuildDirectory = Split-Path -parent $PSCommandPath
$ModuleDirectory = ([System.IO.Path]::Join($BuildDirectory, "Module"))



$ModuleFunctions = $BuildDirectory.Replace('Build','Functions')



$ModuleFile = [System.IO.Path]::Join($BuildDirectory,'Module.ps1')
$ContributionsDirectory = $BuildDirectory.Replace('Contributions')

# Create Module Directory
if (Test-Path -LiteralPath $ModuleDirectory) { 
    Remove-Item $ModuleDirectory -Force -Recurse -Confirm:$false
}

$ModuleObj = New-Item $ModuleDirectory -ItemType Directory -Force

# Create PowerShell Module File
$PSMFile = New-Item ([System.IO.Path]::Join($ModuleObj,'SelMVP.psm1')) -ItemType File  

'#CompiledByBuildScript' | Out-File $PSMFile.FullName -Append

# Interpolate the PowerShell Module


# Interpolate the Localized Data 


# Interpolate the Private Functions in:
Get-ChildItem -LiteralPath ([System.IO.Path]::Join($ModuleFunctions,'Private')) -File |
    ForEach-Object {
        ('#BuildFileName: {0}' -f $_.Name) | Out-File $PSMFile.FullName -Append
        Get-Content $_.FullName | Out-File $PSMFile.FullName -Append
    }

# Interpolate the Public Functions in:
Get-ChildItem -LiteralPath ([System.IO.Path]::Join($ModuleFunctions,'Public')) -File -Recurse |
    ForEach-Object {
        ('#BuildFileName: {0}' -f $_.Name) | Out-File $PSMFile.FullName -Append
        Get-Content $_.FullName | Out-File $PSMFile.FullName -Append
    }


# Interpolate the Contributions into a Seperate Directory
