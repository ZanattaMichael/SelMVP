function Stop-MVPActivity {
    [CmdletBinding()]
    param (
    )

    # Test if the Driver is active. If not throw a terminating error.
    Test-SEDriver
    
    try {
        $CancelButton = Find-SeElement -Driver $Global:MVPDriver -Id $LocalizedData.ElementButtonCancelActivity
        Invoke-SeClick -Element $CancelButton 
    } catch {
        Throw ($LocalizedData.ErrorStopMVPActivity -f $_)
    }
       
}
