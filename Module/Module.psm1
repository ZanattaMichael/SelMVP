#Requires -Version 5.1

$ErrorActionPreference = "Stop"

# Only suported on Windows PowerShell. For the time being.
if ($IsCoreCLR) { Throw "Due to limitations with the Selenium PowerShell Module. This module is not supported on PowerShell Core yet." }

Write-Host "Selenium MVP Module Loaded. Use 'ConnectTo-MVPPortal' to get started." -ForegroundColor Green

