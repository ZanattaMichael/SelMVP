#Requires -Version 7.0

Write-Verbose "Building PowerShell Module:"

$ModuleManifestParams = @{
    Path =
    Guid =
    Author = 'Michael.Zanatta'
    ModuleVersion =
    Description =
    PowerShellVersion =
    RequiredModules =
}

$BuildDirectory = Split-Path -parent $PSCommandPath
$BuildModuleDirectory = [System.IO.Path]::Join($BuildDirectory, "Module")
$BuildModuleFile = [System.IO.Path]::Join($BuildModuleDirectory, "SelMVP.psm1")
$BuildModuleDirectoryLibraries = [System.IO.Path]::Join($BuildModuleDirectory, "Libraries")
$BuildModuleDirectoryContributions = [System.IO.Path]::Join($BuildModuleDirectory, "Contributions")

$ModuleDirectory = $BuildDirectory -replace "Build","Module"
$ModuleFile = [System.IO.Path]::Join($ModuleDirectory, "Module.ps1")
$ModuleDirectoryPrivateFunctions = [System.IO.Path]::Join($ModuleDirectory, "Functions","Private")
$ModuleDirectoryPublicFunctions = [System.IO.Path]::Join($ModuleDirectory, "Functions","Public","Cmdlets")
$ModuleDirectoryDLLibraries = [System.IO.Path]::Join($ModuleDirectory, "Libraries")
$ModuleDirectoryContributions = [System.IO.Path]::Join($ModuleDirectory, "Functions","Public","Contributions")

$ModuleLocalizedData = [System.IO.Path]::Join($ModuleDirectory, "Resources","LocalizedData.ps1")

Write-Debug "`$BuildDirectory: $BuildDirectory"
Write-Debug "`$BuildModuleDirectory: $BuildModuleDirectory"
Write-Debug "`$BuildModuleDirectoryLibraries: $BuildModuleDirectoryLibraries"
Write-Debug "`$BuildModuleDirectoryContributions: $BuildModuleDirectoryContributions"
Write-Debug "`$ModuleFile: $ModuleFile"
Write-Debug "`$ModuleDirectoryPrivateFunctions: $ModuleDirectoryPrivateFunctions"
Write-Debug "`$ModuleDirectoryPublicFunctions: $ModuleDirectoryPublicFunctions"
Write-Debug "`$ModuleDirectoryDLLibraries: $ModuleDirectoryDLLibraries"
Write-Debug "`$ModuleDirectoryContributions: $ModuleDirectoryContributions"
Write-Debug "`$ModuleDirectoryLocalizedData: $ModuleDirectoryLocalizedData"
#
# Create Module Directory
#

Write-Verbose "Creating Module Directory:"

if (Test-Path -LiteralPath $BuildModuleDirectory) { 
    Remove-Item $BuildModuleDirectory -Force -Recurse -Confirm:$false
}

$null = New-Item $BuildModuleDirectory -ItemType Directory -Force
# Create SubDirectories
$null = New-Item $BuildModuleDirectoryLibraries -ItemType Directory -Force
$null = New-Item $BuildModuleDirectoryContributions -ItemType Directory -Force

#
# Create PowerShell Module File
#

$PSMFile = New-Item $BuildModuleFile -ItemType File  

'#CompiledByBuildScript' | Out-File $PSMFile.FullName -Append

#
# Interpolate Functions and Module into Script
#

# Interpolate the PowerShell Module
Get-Content -LiteralPath $ModuleFile | Out-File $PSMFile.FullName -Append

# Interpolate the Localized Data 
Get-Content -LiteralPath $ModuleLocalizedData | Out-File $PSMFile.FullName -Append

# Interpolate the Private Functions in:
Get-ChildItem -LiteralPath $ModuleDirectoryPrivateFunctions -File |
    ForEach-Object {
        ('#BuildFileName: {0}' -f $_.Name) | Out-File $PSMFile.FullName -Append
        Get-Content $_.FullName | Out-File $PSMFile.FullName -Append
    }

# Interpolate the Public Functions in:
Get-ChildItem -LiteralPath $ModuleDirectoryPublicFunctions -File -Recurse |
    ForEach-Object {
        ('#BuildFileName: {0}' -f $_.Name) | Out-File $PSMFile.FullName -Append
        Get-Content $_.FullName | Out-File $PSMFile.FullName -Append
    }

#
# Add Contributions as Seperate Directories
#

Copy-Item -Path $ModuleDirectoryContributions -Destination $BuildModuleDirectoryContributions -Recurse

#
# Add Library Resources
#

Copy-Item -Path $ModuleDirectoryDLLibraries -Destination $BuildModuleDirectoryLibraries -Recurse

#
# Create Module Manifest
#



New-ModuleManifest -