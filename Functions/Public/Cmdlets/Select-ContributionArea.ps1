function Select-ContributionArea {
    #
    # Selects a Value in a DropDown box.
    [cmdletbinding(
        DefaultParameterSetName = 'Standard'
    )]
    param (
        [parameter(Mandatory)]
        [ValidateSet("PowerShell","Other")]
        [String]
        $SelectedValue
    )
     
    # Test if the Driver is active. If not throw a terminating error.
    Test-SEDriver       

    #
    # You will need to inspect the elements on the HTML to add additional drop down settings.
    # Make sure you set the id as the value
    
    switch ($selectedValue) {
        'PowerShell' { $value = '7cc301bb-189a-e411-93f2-9cb65495d3c4' }
        'Other' { $value = 'ff6464de-179a-e411-bbc8-6c3be5a82b68' }
    }
    
    $ActivityType = Find-SeElement -Driver (Get-SEDriver) -Id 'select_contributionAreasDDL'
    $SelectElement = [OpenQA.Selenium.Support.UI.SelectElement]::new($ActivityType)
    $SelectElement.SelectByValue($value)
    
}

Export-ModuleMember Select-ContributionArea