function Stop-MVPActivity {
    
    # Test if the Driver is active. If not throw a terminating error.
    Test-SEDriver
    
    #
    # Save the Activity

    $GetDriverParams = @{
        Driver = $Global:MVPDriver
        Id = $LocalizedData.ElementButtonCancelActivity
    }

    $SaveButton = Find-SeElement @GetDriverParams
    Invoke-SeClick -Element $SaveButton
       
}
