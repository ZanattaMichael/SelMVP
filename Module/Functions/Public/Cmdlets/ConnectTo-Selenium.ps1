function ConnectTo-Selenium {
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
        #$Global:MVPDriver = [ScriptBlock]::Create($cmdlet).Invoke()
    } catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }

}

Export-ModuleMember ConnectTo-Selenium