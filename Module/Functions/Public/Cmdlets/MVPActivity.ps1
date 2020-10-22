function MVPActivity {
    [CmdletBinding()]
    param (
        # Name of the MVP Activity
        [Parameter(Mandatory)]
        [String]
        $Name,
        # Name of the MVP Activity
        [Parameter(Mandatory)]
        [ScriptBlock]
        $Fixture    
    )
    
    begin {

        #
        # Test the configuration is valid.
        Test-ActivityScriptBlock $Fixture
        # Test that the driver is active
        Test-SEDriver

        #
        # Activity Setup        

        $isCancel = $false
        # Setup of Contributions and Areas
        $Script:MVPContributionArea = @()
        $Script:MVPArea = $null

        # Create new MVPActivity
        New-MVPActivity

    }
    
    process {
        
        # Invoke the Fixture

        try {                
            $Fixture.Invoke()
        } catch {
            # If there were errors that wern't handled, it will cancel the action
            Write-Error $_
            $isCancel = $true
        }
        
    }
    end {

        #
        # Activity Tear Down
        #

        try {

            if ($isCancel) {
                # Close the MVP Activity
                Stop-MVPActivity
            } else {
                # Save the MVP Activity
                Save-MVPActivity
            }

        } finally {
            # TearDown of Contributions and Areas
            $Script:MVPContributionArea = @()
            $Script:MVPArea = $null
        }

    }
}