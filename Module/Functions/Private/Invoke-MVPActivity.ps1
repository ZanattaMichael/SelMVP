function Invoke-MVPActivity {
    [CmdletBinding()]
    param()

    # Update Streams
    Write-Verbose "Invoke-MVPActivity:"

    # Update Debug Stream
    Write-Debug "[Invoke-MVPActivity] Calling Test-SEDriver:"

    # Test if the Driver is active. If not throw a terminating error.
    Test-SEDriver

    # Update Debug Stream
    Write-Debug "[Invoke-MVPActivity] Calling Try-TentativeCommand:"
    Write-Debug ("[Invoke-MVPActivity] Try-TentativeCommand Params: {0}" -f ($params | ConvertTo-Json))

    $result = ttry {

        # Try and click "Add New Activity"

        $ActivityButton = Find-SeElement -Driver $Global:MVPDriver -Id $LocalizedData.ElementButtonNewActivity
        Invoke-SeClick -Element $ActivityButton

        # Update Debug
        Write-Debug "[Invoke-MVPActivity:] Tentative-Try: Success"

        Write-Output $true

    } -catch {

        # Update Debug
        Write-Debug ("[Invoke-MVPActivity] Tentative-Try: Error Raised {0}" -f $_.Exception)
        # Try and close the activity if the window is already open.
        Stop-MVPActivity
        # Sleep for a second
        Start-Sleep -Seconds 1

    } -RetryLimit 4

    if ($null -eq $result) {
        # Update Verbose Stream
        Write-Verbose "Invoke-MVPActivity: Failure"

        Throw $LocalizedData.ErrorNoActivityButton
    }

    # Update Verbose Stream
    Write-Verbose "Invoke-MVPActivity: Success"

    Start-Sleep -Seconds 1

}
