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
            'Firefox' { $Global:MVPDriver = Start-SeFirefox -StartURL 'https://mvp.microsoft.com/en-us/Account/SignIn' }
            'Chrome'  { $Global:MVPDriver = Start-SeChrome  -StartURL 'https://mvp.microsoft.com/en-us/Account/SignIn' }
            'Edge'    { $Global:MVPDriver = Start-SeEdge  -StartURL 'https://mvp.microsoft.com/en-us/Account/SignIn' }
        }
                
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