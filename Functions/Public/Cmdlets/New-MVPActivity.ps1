function New-MVPActivity {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateScript({
            ($_ -is [OpenQA.Selenium.Firefox.FirefoxDriver]) -or
            ($_ -is [OpenQA.Selenium.Chrome.ChromeDriver])
        })]
        [Object]
        $Driver
    )
    
    # Test if the Driver is active. If not throw a terminating error.
    Test-SEDriver

    $params = @{
        Try = {
            # Try and click "Add New Activity"
            $ActivityButton = Find-SeElement -Driver $Driver -Id "addNewActivityBtn" -Wait -Timeout 120
            Invoke-SeClick -Element $ActivityButton
        }
        Catch = {
            Start-Sleep -Seconds 1
        }
        RetryLimit = 4
    }

    $result = Try-TentitiveCommand @params

    if ($null -eq $result) {
        $PSCmdlet.ThrowTerminatingError("Cannot Click Add New Activity Button")
    }

    Start-Sleep -Seconds 1

}

Export-ModuleMember New-MVPActivity