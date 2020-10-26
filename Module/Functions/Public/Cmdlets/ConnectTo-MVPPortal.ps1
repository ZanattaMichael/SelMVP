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
    } catch {
        $Global:MVPDriver = $null
        Throw $_        
    }

    # Pause Execution until login box is no longer present
    while ($Global:MVPDriver.Url -match '^https:\/\/login\.((microsoftonline)|(live))\.com') {
        Write-Verbose "Waiting for Login to complete:"
        Start-Sleep -Seconds 1
    }
}

Export-ModuleMember ConnectTo-MVPPortal