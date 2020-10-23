function MVPActivity {
    [CmdletBinding(DefaultParameterSetName="Default")]
    param (        
        # Scriptblock of the Name of the Contribution
        [Parameter(Mandatory,Position=1,ParameterSetName="Default")]
        [Parameter(Mandatory,Position=1,ParameterSetName="Arguments")]
        [String]
        $Name,
        # Scriptblock of the Activity
        [Parameter(Position=2,ParameterSetName="Arguments")]
        [HashTable]
        $ArgumentList,
        # Scriptblock of the Activity
        [Parameter(Mandatory,Position=3,ParameterSetName="Arguments")]
        [Parameter(Mandatory,Position=3,ParameterSetName="Default")]
        [ScriptBlock]
        $Fixture
    )
    
    begin {

        Write-Debug "[MVPActivity] BEGIN: Buildup of Activity"

        #
        # Activity Setup        

        $invokeTearDown = $false
        # Setup of Contributions and Areas
        $Script:ContributionAreas = @()
        $Script:MVPArea = $null

        try {
            #
            # Test the configuration is valid.
            Test-ActivityScriptBlock $Fixture
            # Test that the driver is active
            Test-SEDriver
            # Test that the MVPActivity elements is present.
            Wait-ForMVPElement
            # Create new MVPActivity
            New-MVPActivity     
        } catch {
            Write-Debug "[MVPActivity] Failed MVP Validation Error Below:"
            Write-Error $_
            $invokeTearDown = $true
        }

        Write-Debug "[MVPActivity] BEGIN: Buildup Complete"
   
    }
    
    process {
        
        if ($invokeTearDown) { return }

        Write-Debug "[MVPActivity] PROCESS:"

        # Invoke the Fixture

        try {
            # Invoke the variables
            #$ArgumentList | ForEach-Object { 
            #    New-Variable -Name $_.Key -Value $_.Value
            #}

            $null = $Fixture.Invoke()
        } catch {
            Write-Error $_
            Write-Debug "Error was triggered, initiate the teardown of the MVPActivity"
            $invokeTearDown = $true
        }
        
    }
    end {

        Write-Debug "[MVPActivity] END: Beginning Teardown"

        #
        # Activity Tear Down
        #

        try {

            if ($invokeTearDown) {
                # Close the MVP Activity
                Stop-MVPActivity
            } else {
                # Save the MVP Activity
                Save-MVPActivity
            }

        } finally {
            # TearDown of Contributions and Areas
            $Script:ContributionAreas = @()
            $Script:MVPArea = $null           
        }

        Write-Debug "[MVPActivity] END: Completed"

        return $null
    }
}