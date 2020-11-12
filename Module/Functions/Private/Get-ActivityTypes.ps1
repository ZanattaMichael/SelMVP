Function Get-ActivityTypes {
    [CmdletBinding()]
    param()

    Write-Verbose "Get-ActivityType Called:"

    Test-SEDriver

    # If the Activity Types have already been cached, then return the cache
    if (Test-SEActivityTypes) {
        Write-Verbose "[Get-ActivityType] Returning Cache:"
        return $Global:SEActivityTypes
    }

    # Load and Parse the HTML
    $HTMLDoc = [HtmlAgilityPack.HtmlDocument]::new()
    $HTMLDoc.LoadHtml($Global:MVPDriver.PageSource)

    # Retrive the Contribution Areas
    $ActivityTypes = $HTMLDoc.GetElementbyId("activityTypeSelector").ChildNodes.Where{$_.Name -eq 'option'}

    if ($ActivityTypes.count -eq 0) { $PSCmdlet.ThrowTerminatingError($LocalizedData.ErrorMissingActivityType)}

    # Build Custom Object
    $Global:SEActivityTypes = ($ActivityTypes | Select-Object @{
                                        Name="Name"
                                        Expression={$_.InnerText}}, 
                                    @{
                                        Name="Value"
                                        Expression={($_.Attributes.Where{$_.Name -eq 'value'}).Value}
                                    })

    Write-Debug ("[Get-ActivityType] Global:SEActivityTypes: {0}" -f ($Global:SEActivityTypes | ConvertTo-Json))

    Write-Output $Global:SEActivityTypes

}

