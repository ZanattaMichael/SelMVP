Function Get-ContributionAreas {
    [CmdletBinding()]
    param()

    Test-SEDriver

    # Load and Parse the HTML
    $HTMLDoc = [HtmlAgilityPack.HtmlDocument]::new()
    $HTMLDoc.LoadHtml(($Global:MVPDriver).PageSource)

    # Retrive the Contribution Areas
    $ContributionAreas = $HTMLDoc.GetElementbyId("select_contributionAreasDDL").ChildNodes.Where{$_.Name -eq "optgroup"}

    # Filter by Non-Disabled Attributes. Disabled Attributes are headers
    $OptionElements = $ContributionAreas.ChildNodes.Where{$_.Attributes.Name -notcontains 'disabled'}

    if ($OptionElements.count -eq 0) { $PSCmdlet.ThrowTerminatingError($LocalizedData.ErrorMissingContributionType)}

    # Build Custom Object
    Write-Output ($OptionElements | Select-Object @{
                                        Name="Name"
                                        Expression={$_.InnerText}}, 
                                    @{
                                        Name="Value"
                                        Expression={($_.Attributes.Where{$_.Name -eq 'data-contributionid'}).Value}
                                    })
    
}

