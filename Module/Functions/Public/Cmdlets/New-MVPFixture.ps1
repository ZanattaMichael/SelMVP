function New-MVPFixture {
<#
.Description
New-MVPFixture is a utility that generates MVPActivity ScriptBlocks.

.PARAMETER AreaName
The MVP Contribution Area name to lookup.

.PARAMETER MVPActivityName
The MVP Activity Name.

.EXAMPLE
Standard Execution:

New-MVPFixture -AreaName 'Article' -MVPActivityName 'Test'

.SYNOPSIS
New-MVPFixture is a utility that generates MVPActivity ScriptBlocks.
#>
    [CmdletBinding()]
    param (
        [String]
        $AreaName=(Read-Host "Enter in an AreaName"),
        [String]
        $MVPActivityName=(Read-Host "Enter in an MVPActivity Name")
    )

    $FormStructure = Get-AreaNamedValues -AreaName $AreaName

    return ("
+==================== START COPY ====================+
MVPActivity '$MVPActivityName' {
    # Param Block for arguments to be parsed in.
    param()

    # Define the Area
    Area '$AreaName'
    # Define the Contribution Area
    ContributionArea 'Contribution Area 1', 'Contribution Area 2', 'Contribution Area 3'

    # Define the Input Values:

    $(
        $FormStructure | ForEach-Object {
            "`n",
            "   #Mandatory: $($_.Mandatory) `n",
            "   Value '$($_.Name)' '' `n"
        }
    )
}
+==================== STOP COPY ====================+
    ")
    
}