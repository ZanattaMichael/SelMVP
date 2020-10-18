function New-MVPActivity {
    
    # Test if the Driver is active. If not throw a terminating error.
    Test-SEDriver

    $params = @{
        Try = {
            # Try and click "Add New Activity"
            $ActivityButton = Find-SeElement -Driver (Get-SEDriver) -Id "addNewActivityBtn" -Wait -Timeout 120
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