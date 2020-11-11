function Save-MVPActivity {
    [cmdletbinding()]
    param()

    # Test if the Driver is active. If not throw a terminating error.
    Test-SEDriver
    
    # Validate that HTML Form Strucuture Prior to Submission

    $missingRequiredEntries = $Script:MVPHTMLFormStructure.Where{$_.isSet -contains $false}
    if ($missingRequiredEntries) {
        Throw ($LocalizedData.ErrorMissingRequiredEntries -f (-join $missingRequiredEntries.Name))
        # Fail the Submission and Tidy Up
    }
    
    #
    # Search for Field Validation Errors

    $fieldValidationErrors = Find-SeElement -Target $Global:MVPDriver -By ClassName -Selection $LocalizedData.ElementFieldValidationError
    if ($fieldValidationErrors) {
        Throw ($LocalizedData.ErrorFieldValidationError -f $fieldValidationErrors.Text)
    }

    #
    # Save the Activity

    $GetDriverParams = @{
        Driver = $Global:MVPDriver
        Id = $LocalizedData.ElementButtonSubmitActivity
    }

    try {
        $SaveButton = Find-SeElement @GetDriverParams
        Invoke-SeClick -Element $SaveButton
    } catch {
        Throw ($LocalizedData.ErrorSavingMVPActivity -f $_)
    }
   
    # Snooze. The more entries you add, it's better to sleep for a little longer.

    $GetVariableParams = @{
        Name = $LocalizedData.VariableSaveActivitySleepCounter
        ErrorAction = 'SilentlyContinue'
    }
    
    if ($null -eq (Get-Variable @GetVariableParams)) {
        $Script:SaveActivitySleepCounter = 1
    }

    $SleepDuration = $Script:SaveActivitySleepCounter * 100
    Start-Sleep -Milliseconds $SleepDuration

    # 5 Seconds is the max wait Time
    if ($Script:SaveActivitySleepCounter -le 50) { $Script:SaveActivitySleepCounter++ }
    
}
