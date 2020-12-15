#Requires -Version 7.0

Write-Verbose "Building PowerShell Module:"

$BuildDirectory = Split-Path -parent $PSCommandPath
$BuildModuleDirectory = [System.IO.Path]::Join($BuildDirectory, "Module")
$BuildModuleFile = [System.IO.Path]::Join($BuildModuleDirectory, "Module.psm1")
$BuildModulePSDFile = [System.IO.Path]::Join($BuildModuleDirectory, "SelMVP.psd1")
$BuildModuleDirectoryLibraries = [System.IO.Path]::Join($BuildModuleDirectory)
$BuildModuleDirectoryContributions = [System.IO.Path]::Join($BuildModuleDirectory, "Contributions")

$ModuleDirectory = $BuildDirectory -replace "Build","Module"
$ModuleFile = [System.IO.Path]::Join($ModuleDirectory, "Module.psm1")
$ModuleDirectoryPrivateFunctions = [System.IO.Path]::Join($ModuleDirectory, "Functions","Private")
$ModuleDirectoryPublicFunctions = [System.IO.Path]::Join($ModuleDirectory, "Functions","Public","Cmdlets")
$ModuleDirectoryDLLibraries = [System.IO.Path]::Join($ModuleDirectory, "Libraries")
$ModuleDirectoryContributions = [System.IO.Path]::Join($ModuleDirectory, "Functions","Public","Contributions")

$ModuleResourceData = [System.IO.Path]::Join($ModuleDirectory, "Resources")

$ModuleManifestParams = @{
    RootModule = 'Module.psm1'
    Path = $BuildModulePSDFile
    Guid = [GUID]::NewGuid().Guid
    Author = 'Michael.Zanatta'
    ModuleVersion = Get-Content -Path '.\BuildVersion.txt' | Select-Object -Last 1
    Description = 'Selenium MVP is a PowerShell module that uses PowerShell Selenium combined with a Domain Specific Language (DSL) to automate MVP Submissions'
    PowerShellVersion = '5.1'
    RequiredModules = 'Selenium'
    NestedModules = 'Selenium'
    FunctionsToExport = @()
    CmdletsToExport = @()
    RequiredAssemblies = "Libraries\HTMLAgilityPack\HtmlAgilityPack.dll"
}

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
#Get-Content -LiteralPath $ModuleLocalizedData | Out-File $PSMFile.FullName -Append

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
        $ModuleManifestParams.FunctionsToExport += $_.BaseName
        $ModuleManifestParams.CmdletsToExport += $_.BaseName
    }

#
# Add the Resources
#

Copy-Item -Path $ModuleDirectoryDLLibraries -Destination $BuildModuleDirectoryLibraries -Recurse -Force

#
# Create Module Manifest
#

New-ModuleManifest @ModuleManifestParams