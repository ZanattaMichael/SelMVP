function Select-AreaDropdown {
    [CmdletBinding()]
    param()
    DynamicParam {

        $ParameterName = $LocalizedData.DynamicParameterAreaNameParameterName
        $ContributionArea = [String[]](Get-ActivityTypes).Name 

        $selectedValueAttribute = [System.Management.Automation.ParameterAttribute]::new()
        $selectedValueAttribute.Position = 1
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

    begin {

        # Test if the Driver is active. If not throw a terminating error.
        Test-SEDriver

        ttry {
            Select-DropDown -elementId $LocalizedData.ElementIdActivityType -selectedValue $selectedValue
            # We are using Views of answers to dertmine if the Javascript has ran
            Wait-ForJavascript -Driver $Global:MVPDriver -ElementText 'Views of answers'
        } -Catch {       
            # If the Javascript Fails to Populate the Sub entries within the form       
            # it will retrigger by select the "Article"
            Start-Sleep -Seconds 1
            Select-DropDown -elementId $LocalizedData.ElementIdActivityType -selectedValue $LocalizedData.ElementValueArticle   
        } -RetryLimit 10
        
    }

}

Export-ModuleMember Select-AreaDropdown
