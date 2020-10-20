function New-MVPActivity {
    [CmdletBinding()]
    param()

    # Update Streams
    Write-Verbose "New-MVPActivity:"

    # Update Debug Stream
    Write-Debug "[New-MVPActivity] Calling Test-SEDriver:"

    # Test if the Driver is active. If not throw a terminating error.
    Test-SEDriver

    $params = @{
        Try = {
            # Try and click "Add New Activity"
            $params = @{
                Driver = $Global:MVPDriver
                Id = $LocalizedData.ElementButtonNewActivity
                #Wait = $true
                #Timeout = 120        
            }
            $ActivityButton = Find-SeElement -Driver $Global:MVPDriver -Id $LocalizedData.ElementButtonNewActivity
            Invoke-SeClick -Element $ActivityButton

            # Update Debug
            Write-Debug "[New-MVPActivity:] Tentative-Try: Success"

            Write-Output $true
        }
        Catch = {
            # Update Debug
            Write-Debug ("[New-MVPActivity] Tentative-Try: Error Raised {0}" -f $_.Exception)

            Start-Sleep -Seconds 1
        }
        RetryLimit = 4
    }

    # Update Debug Stream
    Write-Debug "[New-MVPActivity] Calling Try-TentativeCommand:"
    Write-Debug ("[New-MVPActivity] Try-TentativeCommand Params: {0}" -f ($params | ConvertTo-Json))

    $result = Try-TentitiveCommand @params

    if ($null -eq $result) {
        # Update Verbose Stream
        Write-Verbose "New-MVPActivity: Failure"

        $PSCmdlet.ThrowTerminatingError($LocalizedData.ErrorNoActivityButton)
    }

    # Update Verbose Stream
    Write-Verbose "New-MVPActivity: Success"

    Start-Sleep -Seconds 1

}

Export-ModuleMember New-MVPActivity