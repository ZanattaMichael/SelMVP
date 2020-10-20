Function Get-ActivityTypes {
    [CmdletBinding()]
    param()
    
    Test-SEDriver

    # Load and Parse the HTML
    $HTMLDoc = [HtmlAgilityPack.HtmlDocument]::new()
    $HTMLDoc.LoadHtml($Global:MVPDriver.PageSource)


    # Retrive the Contribution Areas
    $ActivityTypes = $HTMLDoc.GetElementbyId("activityTypeSelector").ChildNodes.Where{$_.Name -eq 'option'}

    if ($ActivityTypes.count -eq 0) { $PSCmdlet.ThrowTerminatingError($LocalizedData.ErrorMissingActivityType)}

    # Build Custom Object
    Write-Output ($ActivityTypes | Select-Object @{
                                        Name="Name"
                                        Expression={$_.InnerText}}, 
                                    @{
                                        Name="Value"
                                        Expression={($_.Attributes.Where{$_.Name -eq 'value'}).Value}
                                    })

}

