function New-MVPActivity {
    
    # Test if the Driver is active. If not throw a terminating error.
    Test-SEDriver

    $params = @{
        Try = {
            # Try and click "Add New Activity"
            $params = @{
                Driver = Get-SEDriver
                Id = $LocalizedData.ElementButtonNewActivity
                Wait = $true
                Timeout = 120        
            }
            $ActivityButton = Find-SeElement @params
            Invoke-SeClick -Element $ActivityButton
        }
        Catch = {
            Start-Sleep -Seconds 1
        }
        RetryLimit = 4
    }

    $result = Try-TentitiveCommand @params

    if ($null -eq $result) {
        $PSCmdlet.ThrowTerminatingError($LocalizedData.ErrorNoActivityButton)
    }

    Start-Sleep -Seconds 1

}

Export-ModuleMember New-MVPActivity