Function Test-CSVSchema {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory)]
        [String]
        $LiteralPath
    )

    $RequiredTopLevelColumns = @('Area','ContributionArea')

    # Test-Path
    if (-not(Test-Path @PSBoundParameters -ErrorAction SilentlyContinue)) {
        Throw ($LocalizedData.ErrorTestCSVSchemaMissingCSVFile -f $LiteralPath)
    }

    try {
        # Import the CSV File
        $CSV = Import-Csv @PSBoundParameters
    } catch {
        Throw ($LocalizedData.ErrorTestCSVSchemaImportCSVFile -f $_)
    }

    # Get the CSV Column Names
    $CSVColumnNames = ($CSV | Get-Member).Name

    # Validate if the Area/ ContributionArea Columns are present.
    $MissingTopLevelColumns = $RequiredTopLevelColumns | Where-Object {
        $CSVColumnNames -notcontains $_
    }
    # If items were matched then throw a terminating error.
    if ($MissingTopLevelColumns.Count -ne 0) {
        Throw ($LocalizedData.ErrorTestCSVSchemaMissingColumns -f ($MissingTopLevelColumns -join ' , '))
    }

    # Ensure that the Areas are all the same. Group by the Property Area
    $GroupedItems = $CSV | Group-Object -Property Area

    # Retrive the Area and Contribution Areas
    if ($GroupedItems.Length -ne 1) {
        Throw ($LocalizedData.ErrorTestCSVSchemaDifferentAreaColumn -f $GroupedItems.Name -join ' , ')
    }

    $Area = $GroupedItems[0].Name

    # Perform a Lookup to workout what columns we need
    $FormStructure = Get-HTMLFormStructure $Area | Where-Object {$_.isRequired}

    # Validate that the required Name or Element is Present within the CSV File
    $MissingCSVColumns = $FormStructure | Where-Object { $_.Name -notin $CSVColumnNames }
    if ($MissingCSVColumns.Count -ne 0) {
        Throw ($LocalizedData.ErrorTestCSVSchemaMissingColumns -f $MissingCSVColumns.Name -join ' , ')
    }    

    # Validate no duplicate Contribution Area's are present

    ForEach($Row in $CSV) {

        if ((-not([String]::IsNullOrEmpty($Row.SecondContributionArea))) -or (-not($Row.ThirdContributionArea))) {
            $arr = $Row.ContributionArea, $Row.SecondContributionArea, $Row.ThirdContributionArea | Group-Object | Where-Object {$_.Count -ne 1}
            
            if ($arr.Count -ne 0) {
                Throw ($LocalizedData.ErrorTestCSVSchemaDuplicateContributionArea)
            }
            
        }

    }

}
