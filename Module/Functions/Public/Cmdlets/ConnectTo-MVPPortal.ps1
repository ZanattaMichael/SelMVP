function ConnectTo-MVPPortal {
<#
.Description
Connects to the MVP Portal and waits for the login to complete.

.PARAMETER URLPath
A custom URL provided in the MVP email. Otherwise, if excluded, it will prompt the user for a URL.

.PARAMETER DriverType
You can specify different browser types. The default is Firefox. Options are: Firefox, Chrome, Edge, OldEdge

.EXAMPLE
Connect to Portal:

ConnectTo-MVPPortal -URLPath "https://Your-URL-Path-Goes-Here.com"
.EXAMPLE
Connect to Portal:

ConnectTo-MVPPortal -URLPath "https://Your-URL-Path-Goes-Here.com" -DriverType ('Firefox','Chrome' or 'Edge')
.SYNOPSIS
Connects to the MVP Portal and waits for the login to complete.
#>    
    [CmdletBinding()]
    param (
        [Parameter()]
        [String]
        $URLPath=(Read-Host "Enter in URL Path"),
        [ValidateSet("Firefox","Chrome","Edge", "OldEdge")]
        [String]
        $DriverType = 'Firefox'
    )

    try {

        switch ($DriverType) {
            'Firefox' { $Global:MVPDriver = Start-SeFirefox -StartURL $URLPath }
            'Chrome'  { $Global:MVPDriver = Start-SeChrome  -StartURL $URLPath }
            'Edge'    { $Global:MVPDriver = Start-SeNewEdge -StartURL $URLPath }
            'OldEdge' { $Global:MVPDriver = Start-SeEdge -StartURL $URLPath    }
        }
                
    } catch {
        $Global:MVPDriver = $null
        Throw ($LocalizedData.ErrorConnectToMVPPortal -f $_)       
    }

    # Wait until the Login Screen Loads
    do {
        Test-SEDriver
        Write-Verbose "Waiting for the URL to redirect to the Microsoft Login"
        Start-Sleep -Seconds 1
    } Until (Test-MVPDriverisMicrosoftLogin -waitUntilLoaded)

    # Then Pause Execution until login process has completed
    while (Test-MVPDriverisMicrosoftLogin -isCompleted) {
        Test-SEDriver
        Write-Verbose "Waiting for Login to complete:"
        Start-Sleep -Seconds 1
    }

    Write-Verbose "Success! Logged in."
}
