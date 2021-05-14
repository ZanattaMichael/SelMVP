[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [String]
    $RootPath
)

#
# A Script that used for local dev/testing (including local unit-testing) without having to build the module.
#

Write-Host "Loader Started:"

# Load the Agility Pack
Add-Type -LiteralPath "$RootPath\Module\Libraries\HTMLAgilityPack\HtmlAgilityPack.dll"

Write-Host "Dot-Sourcing Localized Data Resources:"

# Load the Localized Data
. "$RootPath\Module\Resources\02_HTMLFormStructureFormatting.ps1"
. "$RootPath\Module\Resources\03_LocalizedData.ps1"
. "$RootPath\Module\Resources\00_HTMLElements.ps1"
. "$RootPath\Module\Resources\01_HTMLFormStrucuture.ps1"
. "$RootPath\Module\Resources\04_HTMLContributionAreas.ps1"

# Dot Source the Private Directory
Get-ChildItem -LiteralPath "$RootPath\Module\Functions\Private" -File -Recurse | ForEach-Object {
    write-host ("Dot-Sourcing Private Functions: {0}" -f $($_.Fullname))
    . $_.FullName
}
# Load Public Stuff
Get-ChildItem -LiteralPath "$RootPath\Module\Functions\Public" -File -Recurse | ForEach-Object {
    write-host ("Dot-Sourcing Public Functions: {0}" -f $($_.Fullname))
    . $_.FullName
}

Write-Host "Loader Complete."