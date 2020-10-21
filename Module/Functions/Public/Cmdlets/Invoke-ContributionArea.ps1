Function Invoke-ContributionArea {
    [CmdletBinding()]
    param()

    foreach ($ContributionArea in $Script:ContributionAreas) {

        # Test to make sure that the elementid and value have content
        if (-not($ContributionArea.elementId) -or (-not($ContributionArea.elementId)) {
            $PSCmdlet.ThrowTerminatingError("Bad Data")
        }

        #
        # You will need to inspect the elements on the HTML to add additional drop down settings.
        # Make sure you set the id as the value
    
        ttry {
            Select-DropDown -elementId $ContributionArea.elementId -selectedValue $ContributionArea.elementId
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