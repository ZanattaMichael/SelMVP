function MVPActivity {
    [CmdletBinding(DefaultParameterSetName="Default")]
    param (        
        # Scriptblock of the Name of the Contribution
        [Parameter(Mandatory,Position=1,ParameterSetName="Default")]
        [Parameter(Mandatory,Position=1,ParameterSetName="Arguments")]
        [Parameter(Position=1,ParameterSetName="CSVFile")]
        [String]
        $Name,
        # Scriptblock of the Activity
        [Parameter(Mandatory,Position=2,ParameterSetName="Arguments")]
        [Parameter(Mandatory,Position=2,ParameterSetName="Default")]
        [ScriptBlock]
        $Fixture,
        # ArgumentList of the Activity
        [Parameter(Position=3,ParameterSetName="Arguments")]
        [HashTable[]]
        $ArgumentList,
        # CSV File
        [Parameter(Position=2,ParameterSetName="CSVFile")]
        [String]
        $CSVPath
    )

    # Construct the Parameters to Invoke
    $params = @{}

    switch ($PSCmdlet.ParameterSetName) {
        "Arguments" {

            $params.Fixture = $Fixture
            
        }
        "CSVFile" {

            # Test the CSV Schema to ensure that all the columns are present
            Test-CSVSchema $CSVPath
            # Create the Fixture
            $params.Fixture = New-CSVFixture $CSVPath
            # Create the Arguements for the Fixture
            $ArgumentList = New-CSVArguments $CSVPath
            
        }
        default {

            # If the Default Execution is run, execute the Fixture and then return.
            $params.Fixture = $Fixture

        }
    }

    # Write-Host
    if ($Name) { Write-Host ('Executing MVPActivity: "{0}"' -f $Name) -ForegroundColor Green }
    else { Write-Host ('Executing MVPActivity: (From CSV File) "{0}"' -f $CSVPath) -ForegroundColor Green }

    # If Arguments are Present, then iterate each Fixture
    if ($ArgumentList) {
        # Iterate Through Each of the Arguments and Create the MVPActivity
        foreach($Argument in $ArgumentList) {

            $params.ArgumentList = $Argument

            New-MVPActivity @params

        }

    } else {

        # Otherwise Execute the MVP Activity, since there is not additional fixtures.
        New-MVPActivity @params

    }


}