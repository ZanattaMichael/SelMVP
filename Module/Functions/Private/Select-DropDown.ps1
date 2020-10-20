function Select-DropDown {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $elementId,
        [Parameter(Mandatory)]
        [string]
        $selectedValue
    )

    try {
        $ActivityType = Find-SeElement -Driver $Global:MVPDriver -Id $elementId
        $SelectElement = [OpenQA.Selenium.Support.UI.SelectElement]::new($ActivityType)
        $SelectElement.SelectByValue($value)
    } catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }

}