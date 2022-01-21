function Wait-ForMVPElement {
    [CmdletBinding()]
    param (    
    )

    Write-Verbose "[Wait-ForMVPElement] Started:"

    ttry {
        $ActivityButton = Find-SeElement -Driver $Global:MVPDriver -Id $LocalizedData.ElementButtonNewActivity
        if ($null -eq $ActivityButton) {
            Enter-SeUrl 'https://mvp.microsoft.com/en-us/MyProfile/EditActivity' -Driver $Global:MVPDriver             
            Throw "Missing"
        }
    } -catch {
        # Look for error 500's. The URL will approx redirect to:
        # https://mvp.microsoft.com/Error/500?aspxerrorpath=/
        # There are MSFT Issues. Stop
        if ($Global:MVPDriver.Url -match $LocalizedData.MVPPortal500Error) { Throw $LocalizedData.Error500 }

        Write-Debug ("Waiting for New Activity Button. {0}" -f $LocalizedData.ElementButtonNewActivity)
        Write-Warning "Waiting for New Activity Button."        
    } -RetryLimit 10

    Write-Verbose "[Wait-ForMVPElement] Completed:"
    
}