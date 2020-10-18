#Requires -Modules Selenium
#Requires -Version 5.1

$ErrorActionPreference = "Stop"

#
# Parameters

Write-Verbose "Loading Parameters:"

$ModulePath = Split-Path -Path $PSCommandPath -Parent
$HTMLAgilityPackPath = Join-Path -Path $ModulePath -ChildPath "\Libraries\HTMLAgilityPack\HtmlAgilityPack.dll"

Write-Verbose "Loaded Parameters:"

Write-Debug "Parameters:"
Write-Debug "{0}{1}" '$ModulePath', $ModulePath
Write-Debug "{0}{1}" '$HTMLAgilityPackPath', $HTMLAgilityPackPath

#
# Add the HTML Agility Pack

Write-Verbose "Loading HTML Agility Pack:"

Add-Type -LiteralPath $HTMLAgilityPackPath


#
# Interpolated Code
#

