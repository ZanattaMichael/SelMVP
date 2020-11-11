# Invoke the Loader
. ..\Build\LocalLoader.ps1
# Invoke the Pester Tests
Invoke-Pester -Path 'Private'
Invoke-Pester -Path 'Public'