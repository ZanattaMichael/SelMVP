Function Visibility {
<#
The 'Visibility' Parameter sets the visibility of the Activity.
This statement can be included within the fixture or executed within the Param Block, similar to 'Area' and 'Contribution Area'.
Multiple statements aren't allowed within the Fixture.

.PARAMETER Name
The Visibility Name: Values can be: 'Everyone','MVP Community' & 'Microsoft'.

.EXAMPLE
In the example, 'Visibility' is set within the Fixture:

MVPActivity "Test" {
    
    # Let's set the Area and the Contribution Area
    Area 'Article'
    Visibility 'Microsoft'

    # We can set the mandatory parameters
    Value "Number of Articles" 1
    Value Title "Test Entry"
    Value Date "30/11/2020"

}

.EXAMPLE
In the example, 'Visibility' is set within the param block:

MVPActivity "Test" {
    param($Visibility)
    
    # Let's set the Area and the Contribution Area
    Area 'Article'

    # We can set the mandatory parameters
    Value "Number of Articles" 1
    Value Title "Test Entry"
    Value Date "30/11/2020"

}

.SYNOPSIS
Set's the Visibility of the entry.

#>     
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]
        [ValidateSet('Everyone','MVP Community','Microsoft')]
        $Name
    )

    # Test if the Driver is active. If not throw a terminating error.
    Test-SEDriver
    # Test the Callstack.
    Test-CallStack $PSCmdlet.MyInvocation.MyCommand.Name   

    # Locate the Visability Element.
    $VisibilityElement = Find-SeElement -Driver ($Global:MVPDriver) -By XPath -Selection $LocalizedData.ElementVisibilityBoxXPath
    if ($null -eq $VisibilityElement) { return }

    # Match the Name of the Element. If the name is the same, skip!
    if ($Name -eq $VisibilityElement.Text) { return }

    # Select the Element and Select the Correct Item
    Invoke-SeClick -Element $VisibilityElement
    # Locate the ListItem Permission
    $PermissionsParams = @{
        Driver = $Global:MVPDriver
        By = 'XPath'
        Selection = $LocalizedData.VisibilityListItem -f $Name
    }
    $PermissionElement = Find-SeElement @PermissionsParams

    # Select the DropDown Item
    Invoke-SeClick -Element $PermissionElement
    
}