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
        $SaveButton = Find-SeElement -Driver $Global:MVPDriver -Id $LocalizedData.ElementButtonSubmitActivity
        Invoke-SeClick -Element $SaveButton
    } catch {
        Throw ($LocalizedData.ErrorSavingMVPActivity -f $_)
    }
    
}
