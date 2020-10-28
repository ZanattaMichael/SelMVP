function MVPActivity {
    [CmdletBinding(DefaultParameterSetName="Default")]
    param (        
        # Scriptblock of the Name of the Contribution
        [Parameter(Mandatory,Position=1,ParameterSetName="Default")]
        [Parameter(Mandatory,Position=1,ParameterSetName="Arguments")]
        [String]
        $Name,
        # Scriptblock of the Activity
        [Parameter(Mandatory,Position=2,ParameterSetName="Arguments")]
        [Parameter(Mandatory,Position=2,ParameterSetName="Default")]
        [ScriptBlock]
        $Fixture,
        # ArgumentList of the Activity
        [Parameter(Position=3,ParameterSetName="Arguments")]
        [String[]]
        $ArgumentList       
    )
    
    begin {

        Write-Debug "[MVPActivity] BEGIN: Buildup of Activity"

        #
        # Activity Setup        

        $invokeTearDown = $false
        # Setup of Contributions and Areas
        $Script:ContributionAreas = @()
        $Script:MVPArea = $null
        $Script:MVPHTMLFormStructure = $null

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
            $null = $Fixture.Invoke($ArgumentList)
            # Save the MVP Activity
            Save-MVPActivity            
        } catch {
            Write-Error $_
            Write-Warning $LocalizedData.WarningEntryWasNotSaved
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
            }

        } finally {
            # TearDown of Contributions and Areas
            $Script:ContributionAreas = @()
            $Script:MVPArea = $null    
            $Script:MVPHTMLFormStructure = $null       
        }

        Write-Debug "[MVPActivity] END: Completed"

        return $null
    }
}