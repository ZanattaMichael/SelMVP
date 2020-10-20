function Select-ContributionArea {
    #
    # Selects a Value in a DropDown box.
    [cmdletbinding(
        DefaultParameterSetName = 'Standard'
    )]
    param(
        [parameter()]
        [ValidateSet("Primary","Additional")]
        [String]
        $Type="Primary"    
    )
    DynamicParam {

        $ParameterName = "SelectedValue"
        $ContributionArea = [String[]](Get-ContributionAreas).Name 

        $selectedValueAttribute = [System.Management.Automation.ParameterAttribute]::new()
        $selectedValueAttribute.Position = 2
        $selectedValueAttribute.Mandatory = $true

        $attributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::New()
        $attributeCollection.Add($selectedValueAttribute)

        $selectedValueValidateSet = [System.Management.Automation.ValidateSetAttribute]::new($ContributionArea)
        $attributeCollection.add($selectedValueValidateSet)

        $selectedValueParam = [System.Management.Automation.RuntimeDefinedParameter]::New($ParameterName, [String], $attributeCollection)
        $paramDictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::New()
        $paramDictionary.Add($ParameterName, $selectedValueParam)

        return $paramDictionary

    }

    Process {

        #TODO: WORK ON THIS!

        # Test if the Driver is active. If not throw a terminating error.
        Test-SEDriver       

        # Get the Contribution Area
        $ContributionArea = Get-ContributionAreas | Where-Object Name -eq $SelectedValue.Name

        #
        # You will need to inspect the elements on the HTML to add additional drop down settings.
        # Make sure you set the id as the value
    
        Select-DropDown -elementId  $ContributionArea.value  -selectedValue

        $ActivityType = Find-SeElement -Driver ($Global:MVPDriver) -Id $ContributionArea.value 
        $SelectElement = [OpenQA.Selenium.Support.UI.SelectElement]::new($ActivityType)
        $SelectElement.SelectByValue($value)
    }

}

Export-ModuleMember Select-ContributionArea