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

    # Test if the Driver is active. If not throw a terminating error.
    Test-SEDriver
    
    # Fetches the Element and Updates the Field
    $Element = Find-SeElement -Driver (Get-SEDriver) -Id $ElementId
    if ($null -eq $Element) { return }
    Send-SeKeys -Element $Element -Keys $Value
}

Export-ModuleMember Update-Element
