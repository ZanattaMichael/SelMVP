# Install PowerShell Selenium
Install-Module -Name Selenium -Scope CurrentUser

# Install to the Current User Scope
$installDir = Join-Path -Path "$HOME\Documents\PowerShell\Modules"
Install-ChocolateyZipPackage "$packageName" "$url" "$installDir" "$url64"
