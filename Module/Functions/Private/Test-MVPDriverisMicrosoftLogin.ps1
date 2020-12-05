function Test-MVPDriverisMicrosoftLogin {
    [CmdletBinding()]
    param (
        [Parameter()]
        [Switch]
        $waitUntilLoaded,
        [Parameter()]
        [Switch]
        $isCompleted
    )
    # The parameters provide pester guidance on how to mock this function
    Write-Output ($Global:MVPDriver.Url -match $LocalizedData.ConnectToMVPPortalRegexURLMatch)
}