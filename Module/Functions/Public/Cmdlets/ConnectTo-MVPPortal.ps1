function ConnectTo-MVPPortal {
    [CmdletBinding()]
    param (
        [Parameter()]
        [String]
        $URLPath=(Read-Host "Enter in URL Path"),
        [ValidateSet("Firefox","Chrome","Edge")]
        [String]
        $DriverType = 'Firefox'
    )

    try {

        switch ($DriverType) {
            'Firefox' { $Global:MVPDriver = Start-SeFirefox -StartURL $URLPath }
            'Chrome'  { $Global:MVPDriver = Start-SeChrome  -StartURL $URLPath }
            'Edge'    { $Global:MVPDriver = Start-SeEdge  -StartURL $URLPath }
        }
                
    } catch {
        $Global:MVPDriver = $null
        Throw ($LocalizedData.ErrorConnectToMVPPortal -f $_)       
    }

    # Pause Execution until login box is no longer present
    while ($Global:MVPDriver.Url -match $LocalizedData.ConnectToMVPPortalRegexURLMatch) {
        Write-Verbose "Waiting for Login to complete:"
        Start-Sleep -Seconds 1
    }
}
