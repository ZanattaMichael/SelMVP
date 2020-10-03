#Requires -Version 7.0

Write-Verbose "Building PowerShell Module"

$BuildDirectory = Split-Path -parent $PSCommandPath
$ModuleDirectory = ([System.IO.Path]::Join($BuildDirectory, "Module"))

$ModuleFunctions = $BuildDirectory.Replace('Build','Functions')

# Create Module Directory
Test-Path -LiteralPath $ModuleDirectory && 
    Remove-Item $ModuleDirectory -Force -Recurse -Confirm:$false

$ModuleObj = New-Item $ModuleDirectory -ItemType Directory -Force

# Create PowerShell Module File
$PSMFile = New-Item ([System.IO.Path]::Join($ModuleObj,'SubmitMVP.psm1')) -ItemType File  

'#CompiledByBuildScript' | Out-File $PSMFile.FullName -Append

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


<#
[-Path] <String>
[-NestedModules <Object[]>]
[-Guid <Guid>]
[-Author <String>]
[-CompanyName <String>]
[-Copyright <String>]
[-RootModule <String>]
[-ModuleVersion <Version>]
[-Description <String>]
[-ProcessorArchitecture <ProcessorArchitecture>]
[-PowerShellVersion <Version>]
[-CLRVersion <Version>]
[-DotNetFrameworkVersion <Version>]
[-PowerShellHostName <String>]
[-PowerShellHostVersion <Version>]
[-RequiredModules <Object[]>]
[-TypesToProcess <String[]>]
[-FormatsToProcess <String[]>]
[-ScriptsToProcess <String[]>]
[-RequiredAssemblies <String[]>]
[-FileList <String[]>]
[-ModuleList <Object[]>]
[-FunctionsToExport <String[]>]
[-AliasesToExport <String[]>]
[-VariablesToExport <String[]>]
[-CmdletsToExport <String[]>]
[-DscResourcesToExport <String[]>]
[-CompatiblePSEditions <String[]>]
[-PrivateData <Object>]
[-Tags <String[]>]
[-ProjectUri <Uri>]
[-LicenseUri <Uri>]
[-IconUri <Uri>]
[-ReleaseNotes <String>]
[-Prerelease <String>]
[-RequireLicenseAcceptance]
[-ExternalModuleDependencies <String[]>]
[-HelpInfoUri <String>]
[-PassThru]
[-DefaultCommandPrefix <String>]
[-WhatIf]
[-Confirm] 
[<CommonParameters>]

# Create 
New-ModuleManifest
#>
