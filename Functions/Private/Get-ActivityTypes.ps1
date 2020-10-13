Function Get-ActivityTypes {

    #Test-SEDriver

    # Load and Parse the HTML
    $HTMLDoc = [HtmlAgilityPack.HtmlDocument]::new()
    #$HTMLDoc.LoadHtml((Get-SEDriver).PageSource)
    $HTMLDoc.LoadHtml($Data)

    try {

        # Retrive the Contribution Areas
        $ActivityTypes = $HTMLDoc.GetElementbyId("activityTypeSelector").ChildNodes.Where{$_.Name -eq 'option'}

        # Build Custom Object
        Write-Output ($ActivityTypes | Select-Object @{
                                            Name="Name"
                                            Expression={$_.InnerText}}, 
                                        @{
                                            Name="Value"
                                            Expression={($_.Attributes.Where{$_.Name -eq 'value'}).Value}
                                        })
    } catch {
        
        Write-Error $_

        Write-Output ([PSCustomObject]@{
            Name = "Missing"
            Value = "Missing"
        })

    }
    
}

