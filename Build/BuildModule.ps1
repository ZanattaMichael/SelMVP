#Requires -Version 7.0

UpWrite-Verbose "Building PowerShell Module:"

$BuildDirectory = Split-Path -parent $PSCommandPath
$BuildModuleDirectory = [System.IO.Path]::Join($BuildDirectory, "Module")
$BuildModuleDirectoryLibraries = [System.IO.Path]::Join($BuildDirectory, "Libraries")
$BuildModuleDirectoryContributions = [System.IO.Path]::Join($BuildDirectory, "Contributions")

$ModuleDirectory = $BuildDirectory -replace "Build","Module"
$ModuleFile = [System.IO.Path]::Join($ModuleDirectory, "Module.ps1")
$ModuleDirectoryPrivateFunctions = [System.IO.Path]::Join($ModuleDirectory, "Functions","Private")
$ModuleDirectoryPublicFunctions = [System.IO.Path]::Join($ModuleDirectory, "Functions","Public")
$ModuleDirectoryDLLibraries = [System.IO.Path]::Join($ModuleDirectory, "Libraries")
$ModuleDirectoryContributions = [System.IO.Path]::Join($ModuleDirectory, "ModuleFileContributions")
$ModuleDirectoryLocalizedData = [System.IO.Path]::Join($ModuleDirectory, "Resources","LocalizedData.ps1")

Write-Debug "`$BuildDirectory: $BuildDirectory"
Write-Debug "`$BuildModuleDirectory: $BuildModuleDirectory"
Write-Debug "`$BuildModuleDirectoryLibraries: $BuildModuleDirectoryLibraries"
Write-Debug "`$BuildModuleDirectoryContributions: $BuildModuleDirectoryContributions"
Write-Debug "`$ModuleFile: $ModuleFile"
Write-Debug "`$ModuleFilePrivateFunctions: $ModuleFilePrivateFunctions"
Write-Debug "`$ModuleFilePublicFunctions: $ModuleFilePublicFunctions"
Write-Debug "`$ModuleFileDLLibraries: $ModuleFileDLLibraries"
Write-Debug "`$ModuleFileLocalizedData: $ModuleFileLocalizedData"

#
# Create Module Directory
#

Write-Verbose "Creating Module Directory:"

if (Test-Path -LiteralPath $BuildModuleDirectory) { 
    Remove-Item $BuildModuleDirectory -Force -Recurse -Confirm:$false
}

$null = New-Item $BuildModuleDirectory -ItemType Directory -Force
# Create SubDirectories
$null = New-Item $BuildModuleDirectoryContributions -ItemType Directory -Force
$null = New-Item $BuildModuleDirectoryLibraries -ItemType Directory -Force

#
# Create PowerShell Module File
#

$PSMFile = New-Item ([System.IO.Path]::Join($ModuleObj,'SelMVP.psm1')) -ItemType File  

'#CompiledByBuildScript' | Out-File $PSMFile.FullName -Append

#
# Interpolate Functions and Module into Script
#

# Interpolate the PowerShell Module
Get-Content -LiteralPath $ModuleFile | Out-File $PSMFile.FullName -Append

# Interpolate the Localized Data 
Get-Content -LiteralPath $ModuleFileLocalizedData | Out-File $PSMFile.FullName -Append

# Interpolate the Private Functions in:
Get-ChildItem -LiteralPath $ModuleFilePrivateFunctions -File |
    ForEach-Object {
        ('#BuildFileName: {0}' -f $_.Name) | Out-File $PSMFile.FullName -Append
        Get-Content $_.FullName | Out-File $PSMFile.FullName -Append
    }

# Interpolate the Public Functions in:
Get-ChildItem -LiteralPath $ModuleFilePublicFunctions -File -Recurse |
    ForEach-Object {
        ('#BuildFileName: {0}' -f $_.Name) | Out-File $PSMFile.FullName -Append
        Get-Content $_.FullName | Out-File $PSMFile.FullName -Append
    }

#
# Add Contributions as Seperate Directories
#

Copy-Item -Path $ModuleFileDLLibraries -Destination $BuildModuleDirectoryContributions -Recurse

#
# Add Library Resources
#

Copy-Item -Path $ModuleFileDLLibraries -Destination $BuildModuleDirectoryContributions -Recurse



# Interpolate the Contributions into a Seperate Directory

