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
        $SelectElement = New-Object -TypeName OpenQA.Selenium.Support.UI.SelectElement $ActivityType
        $SelectElement.SelectByValue($selectedValue)
    } catch {
        $PSCmdlet.ThrowTerminatingError($LocalizedData.ErrorSelectingDropDown -f $elementId, $selectedValue, $_)
    }

}