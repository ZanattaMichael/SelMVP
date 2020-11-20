Function Test-CSVSchema {
    param(
        [Parameter(Mandatory)]
        [String]
        $LiteralPath
    )

    $RequiredTopLevelColumns = @('Area','ContributionArea')

    # Test-Path
    if (-not(Test-Path @PSBoundParameters -ErrorAction SilentlyContinue)) {
        Throw "Missing CSV File: '$LiteralPath'"
    }

    try {
        # Import the CSV File
        $CSV = Import-Csv @PSBoundParameters
    } catch {
        Throw ("An error occured when importing the CSV File: Error '{0}'" -f $_)
    }

    # Get the CSV Column Names
    $CSVColumnNames = ($CSV | Get-Member).Name

    # Validate if the Area/ ContributionArea Columns are present.
    $MissingTopLevelColumns = $RequiredTopLevelColumns | Where-Object {
        $CSVColumnNames -notcontains $_
    }
    # If items were matched then throw a terminating error.
    if ($MissingTopLevelColumns.Count -ne 0) {
        Throw ("Error. Validation Failed: Missing Columns '{0}'" -f ($MissingTopLevelColumns -join ' , '))
    }

    # Ensure that the Areas are all the same. Group by the Property Area
    $GroupedItems = $CSV | Group-Object -Property Area

    # Retrive the Area and Contribution Areas
    if ($GroupedItems.Length -ne 1) {
        Throw ("Formatting Error. Validation Failed: Cannot have different Areas ('{0}') within the same CSV File." -f $GroupedItems.Name -join ' , ')
    }

    $Area = $GroupedItems[0].Name

    # Perform a Lookup to workout what columns we need
    $FormStructure = Get-HTMLFormStructure $Area | Where-Object {$_.isRequired}

    # Validate that the required Name or Element is Present within the CSV File
    $MissingCSVColumns = $FormStructure | Where-Object { $_.Name -notin $CSVColumnNames }
    if ($MissingCSVColumns.Count -ne 1) {
        Throw ("Formatting Error. Validation Failed: Missing Column Names from CSV File. '{0}'" -f $MissingCSVColumns.Name -join ' , ')
    }    

    # Validate Duplicates


}
