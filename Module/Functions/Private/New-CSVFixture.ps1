Function New-CSVFixture {
    param(
        [Parameter(Mandatory)]
        [String]
        $LiteralPath
    )

    # Import the CSV File
    $CSV = Import-Csv @PSBoundParameters

    # Get the CSV Column Names, excluding 'Area' & ContributionArea
    $CSVColumnNames = ($CSV | Get-Member).Name

    # Get the HTMLForm Structure and Get the Column Names Match from the CSV File
    $FormStructure = Get-HTMLFormStructure $CSV.Area[0] | Where-Object { $_.Name -in $CSVColumnNames }

    # Param Block
    $ParamBlock = 'param($Area,$ContributionArea,{0});' -f (($FormStructure.Name | ForEach-Object { "`${$_}" }) -join ',')

    # Create the Scriptblock
    $ScriptBlock = $FormStructure | ForEach-Object -Begin {
        $ParamBlock
    } -Process {
        "Value '{0}' {1}" -f $_.Name, "`${$($_.Name)};"
    }

    # Return our Fixture Goodness
    return ([scriptblock]::Create($ScriptBlock))

}