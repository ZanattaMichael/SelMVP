function New-CSVArguments {
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

    $ArgumentList = $CSV | ForEach-Object {

        $row = $_

        $params = @{
            Area = $row.Area
            ContributionArea = $row.ContributionArea, $row.SecondContributionArea, $row.ThirdContributionArea
        }

        # Iterate Through the Matched Items and Add them
        $FormStructure | ForEach-Object {
            $params.('{0}' -f $_.Name) = $row."$($_.Name)"
        }

        Write-Output $params

    }

    Write-Output $ArgumentList
    
}