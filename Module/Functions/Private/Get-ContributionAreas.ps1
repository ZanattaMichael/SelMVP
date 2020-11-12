Function Get-ContributionAreas {
    [CmdletBinding()]
    param()

    Write-Verbose "Get-ContributionAreas Called:"

    Test-SEDriver

    # If the Activity Types have already been cached, then return the cache
    if (Test-SEContributionAreas) {
        Write-Verbose "[Get-ContributionAreas] Returning Cache:"
        return $Global:SEContributionAreas
    }

    # Load and Parse the HTML
    $HTMLDoc = [HtmlAgilityPack.HtmlDocument]::new()
    $HTMLDoc.LoadHtml($Global:MVPDriver.PageSource)

    # Retrive the Contribution Areas
    $ContributionAreas = $HTMLDoc.GetElementbyId("select_contributionAreasDDL").ChildNodes.Where{$_.Name -eq "optgroup"}

    # Filter by Non-Disabled Attributes. Disabled Attributes are headers
    $OptionElements = $ContributionAreas.ChildNodes.Where{$_.Attributes.Name -notcontains 'disabled'}

    if ($OptionElements.count -eq 0) { $PSCmdlet.ThrowTerminatingError($LocalizedData.ErrorMissingContributionType)}

    # Build Custom Object
    $Global:SEContributionAreas = ($OptionElements | Select-Object @{
                                        Name="Name"
                                        Expression={$_.InnerText}}, 
                                    @{
                                        Name="Value"
                                        Expression={($_.Attributes.Where{$_.Name -eq 'data-contributionid'}).Value}
                                    })
    
    Write-Debug ("[Get-ContributionAreas] Global:SEContributionAreas: {0}" -f ($Global:SEActivityTypes | ConvertTo-Json))
    Write-Output $Global:SEContributionAreas

}

