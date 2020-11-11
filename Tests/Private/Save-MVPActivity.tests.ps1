Describe "Save-MVPActivity" {

    BeforeAll {
        # Clear the Global Variables
        $Script:MVPHTMLFormStructure = $null
        $Script:SaveActivitySleepCounter = $null

        $Global:MVPDriver = [PSCustomObject]@{
            Data = 'Test'
        }

    }

    AfterEach {
        # Clear and Remove the Global Variables
        $Script:MVPHTMLFormStructure = $null
        $Script:SaveActivitySleepCounter = $null

        try {Remove-Variable -Name MVPHTMLFormStructure -Force -Scope Script -ErrorAction Stop} catch {}
        try {Remove-Variable -Name SaveActivitySleepCounter -Force -Scope Script -ErrorAction Stop} catch {}
        try {Remove-Variable -Name MVPDriver -Force -Scope Global -ErrorAction Stop} catch {}
    }

    it "Standard Execution Saving the MVP Activity with no errors" {

        Mock -CommandName Test-SEDriver -MockWith {}
        Mock -CommandName Find-SeElement -MockWith {} -RemoveParameterType 'Target','Driver' -ParameterFilter { $Selection -eq $LocalizedData.ElementFieldValidationError}
        Mock -CommandName Find-SeElement -MockWith { 
            return ([PSCustomObject]@{ data = "TEST"})
        } -RemoveParameterType 'Target','Driver' -ParameterFilter { $Id -eq $LocalizedData.ElementButtonSubmitActivity }
        Mock -CommandName Invoke-SeClick -MockWith {} -RemoveParameterType 'Element'
        Mock -CommandName Start-Sleep -MockWith {}
        
        $Script:MVPHTMLFormStructure = @(
            [PSCustomObject]@{
                isSet = $true
            }       
        )

        $Result = Save-MVPActivity

        Should -Invoke "Find-SeElement" -Exactly 2
        Should -Invoke "Invoke-SeClick" -Exactly 1
        Should -Invoke "Start-Sleep" -Exactly 1

    }

    it "Standard Execution Saving the MVP Activity, however there was an issue saving the error" {

        Mock -CommandName Test-SEDriver -MockWith {}
        Mock -CommandName Find-SeElement -MockWith {} -RemoveParameterType 'Target','Driver' -ParameterFilter { $Selection -eq $LocalizedData.ElementFieldValidationError}
        Mock -CommandName Find-SeElement -MockWith { 
            return ([PSCustomObject]@{ data = "TEST"})
        } -RemoveParameterType 'Target','Driver' -ParameterFilter { $Id -eq $LocalizedData.ElementButtonSubmitActivity }
        Mock -CommandName Invoke-SeClick -MockWith { Throw "TEST ERROR" } -RemoveParameterType 'Element'
        Mock -CommandName Start-Sleep -MockWith {}
        
        $Script:MVPHTMLFormStructure = @(
            [PSCustomObject]@{
                isSet = $true
            }       
        )

        { Save-MVPActivity } | Should -Throw ($LocalizedData.ErrorSavingMVPActivity -f "*")
        Should -Invoke "Start-Sleep" -Exactly 0

    }

    it "Alternative Execution with non-set HTML values - will Throw an Error " {

        Mock -CommandName Test-SEDriver -MockWith {}

        $Script:MVPHTMLFormStructure = @(
            [PSCustomObject]@{
                isSet = $false
            }       
        )

        { Save-MVPActivity } | Should -Throw ($LocalizedData.ErrorMissingRequiredEntries -f "*")

    }

    it "Alternative Execution with HTML form validation errors - will Throw an Error " {

        Mock -CommandName Test-SEDriver -MockWith {}
        Mock -CommandName Find-SeElement -MockWith {
        return (
            @(
                [PSCustomObject]@{ Text = "TEST"}
            )            
        )} -RemoveParameterType 'Target','Driver' -ParameterFilter { $Selection -eq $LocalizedData.ElementFieldValidationError}
        
        { Save-MVPActivity } | Should -Throw ($LocalizedData.ErrorFieldValidationError -f "*")
        
    }

}