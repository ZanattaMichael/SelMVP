#Requires -Version 7.0

Write-Verbose "Building PowerShell Module:"

$ModuleManifestParams = @{
    Path = ''
    Guid = ''
    Author = 'Michael.Zanatta'
    ModuleVersion = ''
    Description = ''
    PowerShellVersion = ''
    RequiredModules = ''
}

$BuildDirectory = Split-Path -parent $PSCommandPath
$BuildModuleDirectory = [System.IO.Path]::Join($BuildDirectory, "Module")
$BuildModuleFile = [System.IO.Path]::Join($BuildModuleDirectory, "Module.ps1")
$BuildModuleDirectoryLibraries = [System.IO.Path]::Join($BuildModuleDirectory, "Libraries")
$BuildModuleDirectoryContributions = [System.IO.Path]::Join($BuildModuleDirectory, "Contributions")

$ModuleDirectory = $BuildDirectory -replace "Build","Module"
$ModuleFile = [System.IO.Path]::Join($ModuleDirectory, "Module.ps1")
$ModuleDirectoryPrivateFunctions = [System.IO.Path]::Join($ModuleDirectory, "Functions","Private")
$ModuleDirectoryPublicFunctions = [System.IO.Path]::Join($ModuleDirectory, "Functions","Public","Cmdlets")
$ModuleDirectoryDLLibraries = [System.IO.Path]::Join($ModuleDirectory, "Libraries")
$ModuleDirectoryContributions = [System.IO.Path]::Join($ModuleDirectory, "Functions","Public","Contributions")

$ModuleResourceData = [System.IO.Path]::Join($ModuleDirectory, "Resources")

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

$null = Copy-Item -LiteralPath $ModuleFile -Destination $BuildModuleFile
$PSMFile = Get-Item $BuildModuleFile

#
# Add Header
'#CompiledByBuildScript' | Out-File $PSMFile.FullName -Append

#
# Interpolate Functions and Module into Script
#

#
# Interpolate Resources

# Add Library Resources. Sort
Get-ChildItem -LiteralPath $ModuleResourceData | Sort-Object | ForEach-Object { 
    ('#Resource: {0}' -f $_.Name) | Out-File $PSMFile.FullName -Append
    Get-Content $_.FullName | Out-File $PSMFile.FullName -Append    
}

#
# Interpolate the Functions

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
# Create Module Manifest
#



#New-ModuleManifest -