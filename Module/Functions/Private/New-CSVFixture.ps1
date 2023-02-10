Function New-CSVFixture {
    param(
        [Parameter(Mandatory)]
        [String]
        $LiteralPath
    )

    # Import the CSV File
    [Array]$CSV = Import-Csv @PSBoundParameters

    # Single CSV Entry
    if ($CSV.Count -eq 1) {
        $Area = $CSV.Area
    } else {
        $Area = $CSV.Area[0]
    }

    # Get the CSV Column Names, excluding 'Area' & ContributionArea
    $CSVColumnNames = ($CSV | Get-Member -MemberType NoteProperty).Name

    # Get the HTMLForm Structure and Get the Column Names Match from the CSV File
    $FormStructure = Get-HTMLFormStructure $Area | Where-Object { $_.Name -in $CSVColumnNames }

    # If the Visability is present, manually interpolate.
    $VisabilityParameter = $(
        if ($CSVColumnNames -contains 'Visibility') { Write-Output ',$Visibility'}
        else { Write-Output '' }
    )

    # Param Block
    $ParamBlock = 'param($Area,$ContributionArea,{0}{1});' -f (($FormStructure.Name | ForEach-Object { "`${$_}" }) -join ','), $VisabilityParameter

    # Create the Scriptblock
    $ScriptBlock = $FormStructure | ForEach-Object -Begin {
        $ParamBlock
    } -Process {
        "Value '{0}' {1}" -f $_.Name, "`${$($_.Name)};"
    }

    # Return our Fixture Goodness
    return ([scriptblock]::Create($ScriptBlock))

}