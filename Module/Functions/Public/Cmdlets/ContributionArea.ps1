Function ContributionArea {
    #
    # Selects a Value in a DropDown box.
    [cmdletbinding()]
    param(
    )

    DynamicParam {

        # Check the call stack and ensure that MVPActivity is a parent.
        # This is executed within the DynamicParam block since it requires a new MVP window to be open.
        if (-not(Test-CallStack)) { Throw $LocalizedData.ErrorContributionAreaNotNested }

        $ParameterName = $LocalizedData.DynamicParameterAreaNameParameterName
        $ContributionArea = [String[]](Get-ContributionAreas).Name 

        $selectedValueAttribute = [System.Management.Automation.ParameterAttribute]::new()
        $selectedValueAttribute.Position = 2
        $selectedValueAttribute.Mandatory = $true
        $selectedValueAttribute.ValueFromPipeline = $true

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

        # TODO: Check the stack trace, the cmdlet is only accessable from MVPActivity        
        Test-SEDriver

    }

    process {

        $matchedActivityType = Get-ContributionAreas | Where-Object {
            $_.Name -eq
            $paramDictionary."$($LocalizedData.DynamicParameterAreaNameParameterName)".Value
        }
        
        # Generate the ElementId
        $elementId = $(
            if ($Script:ContributionAreas.Count -eq 0) { $LocalizedData.ElementIdContributionArea }
            else { "{0}{1}" -f $LocalizedData.ElementIdContributionArea, ($Script:ContributionAreas.Count + 1) }
        )

        # Add to the Contribution Areas
        $Script:ContributionAreas += [PSCustomObject]@{
            elementId = $matchedActivityType
            selectedValue = $matchedActivityType.Value
        }

        #
        # If the $Script:ContributionAreas count is gt then 3, then select the 'add more' link

        if ($Script:ContributionAreas.count -ge 3) {
            $AddMoreButton = Find-SeElement -Driver $Global:MVPDriver -By ClassName -Selection 'add' 
            Invoke-SeClick -Element $AddMoreButton 
        }

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
            Select-DropDown -elementId $ContributionArea.elementId -selectedValue $LocalizedData.ElementValueChefPuppetInDataCenter   
        } -RetryLimit 10     

    }

}