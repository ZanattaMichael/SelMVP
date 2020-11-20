function New-MVPActivity {
    function New-MVPActivity {
    param (
        # Scriptblock of the Activity
        [Parameter(Mandatory,Position=2,ParameterSetName="Arguments")]
        [Parameter(Mandatory,Position=2,ParameterSetName="Default")]
        [ScriptBlock]
        $Fixture,
        # ArgumentList of the Activity
        [Parameter(Position=3,ParameterSetName="Arguments")]
        [HashTable]
        $ArgumentList      
    )
    
    
    begin {

        Write-Debug "[New-MVPActivity] BEGIN: Buildup of Activity"

        #
        # Activity Setup        

        $invokeTearDown = $false
        # Setup of Contributions and Areas
        $Script:MVPArea = $null
        $Script:ContributionAreas = [System.Collections.Generic.List[PSCustomObject]]::New()
        $Script:MVPHTMLFormStructure = $null

        try {

            #
            # Test the configuration is valid.
            $parameterCmdlets = Test-ActivityScriptBlock $Fixture
            # Test that the driver is active
            Test-SEDriver
            # Test that the MVPActivity elements is present.
            Wait-ForMVPElement
            # Create new MVPActivity. Click the Button.
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

        Write-Debug "[New-MVPActivity] PROCESS:"

        # Invoke the Fixture

        try {

            # If the Parameter is used instead of the cmdlet itself, invoke the cmdlet parsing in the parametervalue
            if ($parameterCmdlets.ParametrizedArea) {
                Area $ArgumentList.Area
            }
            
            if ($parameterCmdlets.ParametrizedContributionArea) {
                ContributionArea $ArgumentList.ContributionArea
            }

            if ($ArgumentList) {
                # Invoke the Fixture Splatting the Args in as parameters.
                & $Fixture @ArgumentList
            } else {
                $null = $Fixture.Invoke()
            }
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

        Write-Debug "[New-MVPActivity] END: Beginning Teardown"

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
            $Script:MVPArea = $null
            $Script:ContributionAreas = [System.Collections.Generic.List[PSCustomObject]]::New()
            $Script:MVPHTMLFormStructure = $null               
        }

        Write-Debug "[New-MVPActivity] END: Completed"

        return $null
    }

}