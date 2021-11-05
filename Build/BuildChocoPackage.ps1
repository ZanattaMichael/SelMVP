#Requires -Version 7.0

Write-Verbose "Building PowerShell Chocolatey Package:"

$BuildDirectory = Split-Path -parent $PSCommandPath
$BuildModuleDirectory = [System.IO.Path]::Join($BuildDirectory, "SelMVP")
$BuildModuleFile = [System.IO.Path]::Join($BuildModuleDirectory, "Module.psm1")
$BuildModulePSDFile = [System.IO.Path]::Join($BuildModuleDirectory, "SelMVP.psd1")
$BuildModuleDirectoryLibraries = [System.IO.Path]::Join($BuildModuleDirectory)

$ErrorActionPreference = 'Stop'

#
# Test that the Build is Present

$PreReqPaths = @(
    $BuildModuleDirectory
    $BuildModuleFile
    $BuildModulePSDFile
    $BuildModuleDirectoryLibraries
)

Write-Verbose "Testing: $($PreReqPaths -join ', ')"

if ((Test-Path $PreReqPaths) -contains $false) { Throw "Build was not not started or was incomplete!" }

#
# Start Building the Choco Package

# Parse the Manifest in here!
$manifest = . $BuildModulePSDFile

# Format our Parameters
$parameters = @{
    maintainername = "Michael Zanatta"
    maintainerrepo = "https://github.com/ZanattaMichael/SelMVP"
    packageversion = $manifest.ModuleVersion
    installertype = 'zip'
    url = ''
    url64 = ''
}

choco new SelMVP maintainername="Michael Zanatta" 

packageversion
maintainername
maintainerrepo
installertype
url
url64
silentargs
