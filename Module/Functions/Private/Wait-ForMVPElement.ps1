function Wait-ForMVPElement {
    [CmdletBinding()]
    param (    
    )

    ttry {
        $ActivityButton = Find-SeElement -Driver $Global:MVPDriver -Id $LocalizedData.ElementButtonNewActivity
        if ($null -eq $ActivityButton) {
            Enter-SeUrl 'https://mvp.microsoft.com/en-us/MyProfile/EditActivity' -Driver $Global:MVPDriver             
            Throw "Missing"
        }
    } -catch {
        Write-Debug ("Waiting for New Activity Button. {0}" -f $LocalizedData.ElementButtonNewActivity)
        Write-Warning "Waiting for New Activity Button."
    } -RetryLimit 10
    
}