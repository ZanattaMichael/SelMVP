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

    Write-Verbose "[Visibility()] Invoked. Parameter `$Name: $Name"

    # Locate the ListItem Permission
    $PermissionsParams = @{
        Driver = $Global:MVPDriver
        By = 'XPath'
        Selection = $LocalizedData.VisibilityListItem -f $Name
    }

    $sleepTimer = 250

    ttry {

        # Locate the Visibility Element.
        $VisibilityElement = Find-SeElement -Driver ($Global:MVPDriver) -By XPath -Selection $LocalizedData.ElementVisibilityBoxXPath

        Write-Verbose "[Visibility()] `$VisibilityElement isNull: $($null -eq $VisibilityElement)"
        Write-Verbose "[Visibility()] `$VisibilityElement.Text : $($VisibilityElement.Text)"

        if ($null -eq $VisibilityElement) { return }
        if ($Name -eq $VisibilityElement.Text) { return }

        Write-Verbose "[Visibility()] Selecting VisibilityElement"

        # Select the Element and Select the Correct Item
        Invoke-SeClick -Element $VisibilityElement

        Start-Sleep -Milliseconds $sleepTimer

        Write-Verbose "[Visibility()] Finding VisibilityListItem:"
        $PermissionElement = Find-SeElement @PermissionsParams

        Write-Verbose "[Visibility()] `$VisibilityListItem isNull: $($null -eq $PermissionElement)"

        Start-Sleep -Milliseconds $sleepTimer
        # Select the DropDown Item

        Write-Verbose "[Visibility()] Selecting Visibility From Dropdown : $Name"
        Invoke-SeClick -Element $PermissionElement

    } -catch {

        Write-Warning "[ERROR]. Failed to set Visibility. Retrying:"
        $SleepTimer += 100

    } -RetryLimit 5
        
}