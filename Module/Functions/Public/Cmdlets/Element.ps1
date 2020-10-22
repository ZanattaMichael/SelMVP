Function Update-Element {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]
        $ElementId,
        [Parameter(Mandatory)]
        [String]
        $Value
    )

    # TODO: Check the stack trace, the cmdlet is only accessable from MVPActivity

    # Test if the Driver is active. If not throw a terminating error.
    Test-SEDriver
    
    # Fetches the Element and Updates the Field
    $Element = Find-SeElement -Driver ($Global:MVPDriver) -Id $ElementId
    if ($null -eq $Element) { return }
    Send-SeKeys -Element $Element -Keys $Value
}

