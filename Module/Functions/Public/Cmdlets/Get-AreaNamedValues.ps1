function Get-AreaNamedValues {
<#
.Description
This command is used to retrieve the list of fields that are required for an MVP submission.
Since different MVP Area's have other fields, you can use Get-AreaNamedValues 'AreaName' to identify the fields.

In the example below, we will use Get-AreaNamedValues 'Article' to get the Value names:

Get-AreaNamedValues Article

Name               Mandatory
----               ---------
Number of Articles      True
Title                   True
Date                    True
Number of Views        False
URL                    False
Description            False

Once the list is returned, we can construct the data structure using the output:

MVPActivity "Test" {
    
    # Let's set the Area and the Contribution Area
    Area 'Article'
    ContributionArea 'PowerShell'

    # We can set the mandatory parameters
    Value "Number of Articles" 1
    Value Title "Test Entry"
    Value Date "30/11/2020"

}

.PARAMETER AreaName
The MVP Contribution Area name to lookup.

.EXAMPLE
In the example below, we will use Get-AreaNamedValues 'Article' to get the Value names:

Get-AreaNamedValues Article

Name               Mandatory
----               ---------
Number of Articles      True
Title                   True
Date                    True
Number of Views        False
URL                    False
Description            False

.SYNOPSIS
This command is used to retrive the list of fields that are required for a MVP submission.
#>
    [CmdletBinding()]
    param (
        [Parameter()]
        [String]
        $AreaName
    )

    # Call the HTML FormStrucutre and Parse in the Article Name
    Get-HTMLFormStructure $AreaName | Select-Object Name, @{Name='Mandatory';Exp={$_.isRequired}} | Sort-Object -Property Mandatory -Descending

}