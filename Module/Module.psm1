#Requires -Version 5.1

$ErrorActionPreference = "Stop"

# Only suported on Windows PowerShell. For the time being.
if ($IsCoreCLR) { Throw "Due to limitations with the Selenium PowerShell Module. This module is not supported on PowerShell Core yet." }

#
# Parameters

Write-Verbose "Loading Parameters:"

$ModulePath = Split-Path -Path $PSCommandPath -Parent
#$HTMLAgilityPackPath = Join-Path -Path $ModulePath -ChildPath "\Libraries\HTMLAgilityPack\HtmlAgilityPack.dll"

<#
Write-Verbose "Loaded Parameters:"

Write-Debug "Parameters:"
Write-Debug ("{0} {1]" -f '$ModulePath:', $ModulePath)
Write-Debug ("{0} {1}" -f '$HTMLAgilityPackPath:', $HTMLAgilityPackPath)
#>

#
# Add the HTML Agility Pack

#Write-Verbose "Loading HTML Agility Pack:"

#Add-Type -LiteralPath $HTMLAgilityPackPath

Write-Host "Selenium MVP Module Loaded. Use 'ConnectTo-MVPPortal' to get started." -ForegroundColor Green

