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
        $Global:Driver = $cmdlet.Invoke()
    } catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }

    # Load the HTML Agility Pack
    Add-Type -LiteralPath $HTMLAgilityPackPath

}

Export-ModuleMember ConnectTo-Selenium