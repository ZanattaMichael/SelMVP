function Add-ContributionAreaDropDown {
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

    Process {

        # Test if the Driver is active. If not throw a terminating error.
        Test-SEDriver

        $matchedActivityType = Get-ContributionAreas | Where-Object {
            $_.Name -eq
            $paramDictionary."$($LocalizedData.DynamicParameterAreaNameParameterName)".Value
        }

        # Get the ID of the Contribution DropDown Element
        if ($Type -eq 'Primary') { $elementId = $LocalizedData.ElementIdContributionArea } 
        else { $elementId = $LocalizedData.ElementIdContributionArea2 }

        #
        # You will need to inspect the elements on the HTML to add additional drop down settings.
        # Make sure you set the id as the value
    
        ttry {
            Select-DropDown -elementId $elementId -selectedValue $matchedActivityType.Value
            # We are using Views of answers to dertmine if the Javascript has ran
            Wait-ForJavascript -ElementText 'Views of answers'
        } -Catch {       
            # If the Javascript Fails to Populate the Sub entries within the form       
            # it will retrigger by select the "Chef/Puppet in Datacenter"
            Start-Sleep -Seconds 1
            Select-DropDown -elementId $elementId -selectedValue $LocalizedData.ElementValueChefPuppetInDataCenter   
        } -RetryLimit 10

    }

}

Export-ModuleMember Select-ContributionArea