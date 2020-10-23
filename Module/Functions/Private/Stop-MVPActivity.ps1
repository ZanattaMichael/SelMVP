function Stop-MVPActivity {
    
    # Test if the Driver is active. If not throw a terminating error.
    Test-SEDriver
    
    try {
        $CancelButton = Find-SeElement -Driver $Global:MVPDriver -Id $LocalizedData.ElementButtonCancelActivity
        Invoke-SeClick -Element $CancelButton 
    } catch {
    }
       
}
