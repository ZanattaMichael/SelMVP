function Select-AreaDropdown {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]
        $SelectedValue
    ) 

    # Test if the Driver is active. If not throw a terminating error.
    Test-SEDriver

    ttry {
        Select-DropDown -elementId activityTypeSelector -selectedValue $selectedValue
        # We are using Views of answers to dertmine if the Javascript has ran
        Wait-ForJavascript -Driver (Get-SEDriver) -ElementText 'Views of answers'
    } -Catch {       
        # If the Javascript Fails to Populate the Sub entries within the form       
        # it will retrigger by select the "Article"
        Start-Sleep -Seconds 1
        Select-DropDown -elementId activityTypeSelector -selectedValue Article   
    } -RetryLimit 10

}

Export-ModuleMember Select-AreaDropdown
