#
# A Script that used for local dev/testing (including local unit-testing) without having to build the module.
#

Write-Host "Loader Started:"

# Load the Agility Pack
Add-Type -LiteralPath 'D:\Git\MVP-1\Module\Libraries\HTMLAgilityPack\HtmlAgilityPack.dll'

Write-Host "Dot-Sourcing Localized Data Resources:"

# Load the Localized Data
. "D:\Git\MVP-1\Module\Resources\02_HTMLFormStructureFormatting.ps1"
. 'D:\Git\MVP-1\Module\Resources\03_LocalizedData.ps1'
. 'D:\Git\MVP-1\Module\Resources\00_HTMLElements.ps1'
. 'D:\Git\MVP-1\Module\Resources\01_HTMLFormStrucuture.ps1'

$ErrorActionPreference = 'SilentlyContinue'

# Dot Source the Private Directory
Get-ChildItem -LiteralPath 'D:\Git\MVP-1\Module\Functions\Private' -File -Recurse | ForEach-Object {
    write-host ("Dot-Sourcing Private Functions: {0}" -f $($_.Fullname))
    . $_.FullName
}
# Load Public Stuff
Get-ChildItem -LiteralPath 'D:\Git\MVP-1\Module\Functions\Public' -File -Recurse | ForEach-Object {
    write-host ("Dot-Sourcing Public Functions: {0}" -f $($_.Fullname))
    . $_.FullName
}

$ErrorActionPreference = 'Continue'

Write-Host "Loader Complete."