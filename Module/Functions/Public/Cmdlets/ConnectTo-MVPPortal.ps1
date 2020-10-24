function ConnectTo-MVPPortal {
    [CmdletBinding()]
    param (
        [Parameter()]
        [String]
        $URLPath=(Read-Host "Enter in URL Path"),
        [ValidateSet("Firefox","Chrome")]
        [String]
        $DriverType = 'Firefox'
    )

    switch ($DriverType) {
        'Firefox' { $cmdlet = "Start-SeFirefox -StartURL '$URLPath'" }
        'Chrome' { $cmdlet = "Start-SeChrome -StartURL '$URLPath'" }
    }

    try {
        $Global:MVPDriver = Start-SeFirefox -StartURL 'https://mvp.microsoft.com/en-us/Account/SignIn'
        # Pause Execution until login box is no longer present
        Start-Sleep -Seconds 15
    } catch {
        $Global:MVPDriver = $null
        Throw $_        
    }

}

Export-ModuleMember ConnectTo-MVPPortal