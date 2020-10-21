function Add-ContributionArea {

    #
    # Selects a Value in a DropDown box.
    [cmdletbinding(
        DefaultParameterSetName = 'Standard'
    )]
    param(
    )
    DynamicParam {

        $ParameterName = $LocalizedData.DynamicParameterAreaNameParameterName
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

    # If null, setup the variable
    if ($null -eq $Script:ContributionAreas) {
        $Script:ContributionAreas = @()
    }

    # Test if the Driver is active. If not throw a terminating error.
    Test-SEDriver

    $matchedActivityType = Get-ContributionAreas | Where-Object {
        $_.Name -eq
        $paramDictionary."$($LocalizedData.DynamicParameterAreaNameParameterName)".Value
    }    
    
    # Add to the Contribution Areas
    $Script:ContributionAreas += [PSCustomObject]@{
        elementId = $(
            if ($Script:ContributionAreas.Count -eq 0) { $LocalizedData.ElementIdContributionArea }
            else { "{0}{1}" -f $LocalizedData.ElementIdContributionArea, ($Script:ContributionAreas.Count + 1) }
        )
        selectedValue = $matchedActivityType.Value
    }
   
}