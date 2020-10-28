function Area {
    [CmdletBinding()]
    param(
        # Selected Value
        [Parameter(Mandatory=$true)]
        [String]
        $SelectedValue
    )
   
    begin {

        # Test if the Driver is active. If not throw a terminating error.
        Test-SEDriver
        # Test the Callstack.
        Test-CallStack $PSCmdlet.MyInvocation.MyCommand.Name
        
    }

    Process {


        # Validate the $SelectedValue Attributes
        [Array]$matchedActivityType = Get-ActivityTypes | Where-Object { $_.Name -eq $SelectedValue }
        if ($matchedActivityType.Count -eq 0) { Throw ($LocalizedData.ErrorMissingSelectedValue -f $SelectedValue) }
        if ($matchedActivityType.Count -ne 1) { Throw ($LocalizedData.ErrorTooManySelectedValue -f $SelectedValue, $matchedActivityType.count) }
        
        #
        # Select the Element
                
        ttry {
            Select-DropDown -elementId $LocalizedData.ElementIdActivityType -selectedValue $matchedActivityType.Value
            # We are using Views of answers to dertmine if the Javascript has ran
            Wait-ForJavascript -ElementText 'Views of answers'
            # Update the Area
            $Script:MVPArea = $SelectedValue
            $Script:MVPHTMLFormStructure = Get-HTMLFormStructure $SelectedValue
        } -Catch {       
            # If the Javascript Fails to Populate the Sub entries within the form       
            # it will retrigger by select the "Article"
            Start-Sleep -Seconds 1
            Select-DropDown -elementId $LocalizedData.ElementIdActivityType -selectedValue $LocalizedData.ElementValueArticle   
        } -RetryLimit 10
        
    }

}
