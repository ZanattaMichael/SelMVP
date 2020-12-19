Function ContributionArea {
<#
.Description
The ContributionArea is a command that defines the Contribution Areas within the MVP Portal.
ContributionArea can be used as a String Array (ContributionArea 'Area1','Area2','Area3'), or by specifying multiple ContributionArea statements.

Similarly to Area, if ContributionArea is included within the Param() block, it's not required to be defined and will be automatically invoked.

The current list of 'Contribution Areas' are:



.PARAMETER SelectedValue
The Contribution Areas that you wish to add.

.EXAMPLE
Single Use:

ContributionArea 'Area1'
.EXAMPLE
ContributionArea can be stacked like so:

ContributionArea 'Area1'
ContributionArea 'Area2'
ContributionArea 'Area3'

.EXAMPLE
ContributionArea can placed in an array:

ContributionArea 'Area1','Area2','Area3'

.SYNOPSIS
The ContributionArea is a command that defines the Contribution Areas within the MVP Portal.

#>
    [cmdletbinding()]
    param(
        # Parameter help description
        [Parameter(Mandatory)]
        [String[]]
        $SelectedValue
    )

    begin {

        # Test if the Driver is active. If not throw a terminating error.
        Test-SEDriver
        # Test the Callstack.
        Test-CallStack $PSCmdlet.MyInvocation.MyCommand.Name
        
    }

    process {

        # Multiple Contribution Areas can be parsed in.
        ForEach ($Param in $SelectedValue) {

            # Validate the $SelectedValue Parameters
            [Array]$matchedActivityType = Get-ContributionAreas | Where-Object { $_.Name -eq $Param }
            if ($matchedActivityType.Count -eq 0) { Throw ($LocalizedData.ErrorMissingSelectedValue -f $Param) }
            if ($matchedActivityType.Count -ne 1) { Throw ($LocalizedData.ErrorTooManySelectedValue -f $Param, $matchedActivityType.count) }
            
            # Generate the ElementId
            $elementId = $(
                if ($Script:ContributionAreas.Count -eq 0) { $LocalizedData.ElementIdContributionArea }
                else { "{0}{1}" -f $LocalizedData.ElementIdContributionArea, ($Script:ContributionAreas.Count + 1) }
            )

            # Add to the Contribution Areas
            $Script:ContributionAreas.Add(
                [PSCustomObject]@{
                    elementId = $matchedActivityType.Name
                    selectedValue = $matchedActivityType.Value
                }
            )

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
                Select-DropDown -elementId $Script:ContributionAreas[-1].elementId -selectedValue $LocalizedData.ElementValueChefPuppetInDataCenter   
            } -RetryLimit 10     
        }   
    }
}