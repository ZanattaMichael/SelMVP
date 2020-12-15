function MVPActivity {
<#
.Description
MVPActivity is the top-level definition command, which groups the MVP contribution types into their respective areas. 
In the example below, I have a personal blog which I would like to group all my content:

MVPActivity "Personal Blogs" {
    Area 'Article'
    # Do Something
}

MVPActivity requires 'Area', 'ContributionArea' and 'Value' to be present for execution to occur.
MVPActivity supports CSV Import with use of the -CSVPath parameter, however is only limited to a single area.



.PARAMETER Name
Name is the name of the MVPActivity

.PARAMETER CSVPath
Import the CSV File and Parse it. Note that the headers for the Activity Need to be Present:

MVPActivity -CSVPath 'Path to CSV File'

Example CSV File:

Date,Title,URL,Description,Number of Articles,Number of Views,Area,ContributionArea,SecondContributionArea,ThirdContributionArea
28/11/2020,TEST,https://www.google.com,TEST,1,1,Article,PowerShell,Networking,Storage
28/11/2020,TEST,https://www.google.com,TEST,1,1,Article,PowerShell,Networking,Storage

.PARAMETER ArgumentList
MVPActivity supports arguments being parsed into it using the -ArgumentList parameter, similarly to the -TestCases parameter within Pester. Input is defined as a [HashTable] or a [HashTable[]].

.PARAMETER Fixture
The ScriptBlock containing the Area, ContributionArea and Value. Powershell statements are supported.

.EXAMPLE
Import the CSV File and Parse it:

MVPActivity -CSVPath 'Path to CSV File'

.EXAMPLE
Standard Usage:

    MVPActivity "Reddit Contribution" {

        Area 'Article'
        # ContributionArea can accept an Array
        ContributionArea 'PowerShell','Yammer','Word'

        Value 'Date' $date
        Value 'Title' 'TEST'
        Value 'URL' 'https:\\test.com'
        Value 'Description' 'THIS IS A TEST'
        Value 'Number of Posts' '1'
        # Or you can use the HTML DivId
        Value 'Number of Subscribers' '1'
        Value 'Annual Unique Visitors' '1'

    }

.EXAMPLE
In this example below, we will parse a hashtable of arguments into the fixture:

    $params = @{
        Area = "Blog/Website Post"
        ContributionArea = "PowerShell","Yammer","Word"
        date = '26/10/2020'
    }

    # Define Activity
    MVPActivity "Name of Activity" -ArgumentList $params {
        # If the Parameters -Area or -ContributionArea are defined 
        # in the param block, the cmdlet is not required (Area or ContributionArea).
        param($Area, $ContributionArea, $date)

        # You can use the String Name
        Value 'Date' $date
        Value 'Title' 'TEST'
        Value 'URL' 'https:\\test.com'
        Value 'Description' 'THIS IS A TEST'
        Value 'Number of Posts' '1'
        # Or you can use the HTML Div Id
        Value 'Number of Subscribers' '1'
        Value 'Annual Unique Visitors' '1'
        # Still can execute PowerShell within the script block
        Start-Sleep -Seconds 3

   }
.EXAMPLE
For those who love complexity, the fixture supports an array of HashTables to be parsed into the fixture.

    $params = @(
        @{
            Area = "Blog/Website Post"
            ContributionArea = "PowerShell","Yammer","Word"
            date = '26/10/2020'
        }
        @{
            Area = "Blog/Website Post"
            ContributionArea = "PowerShell","Yammer","Word"
            date = '15/10/2020'
        }
    )

    # Define Activity
    MVPActivity "Name of Activity" -ArgumentList $params {
        # If the Parameters -Area or -ContributionArea are defined in the param block, 
        # the cmdlet is not required (Area or ContributionArea).
        param($Area, $ContributionArea, $date)

        # You can use the String Name
        Value 'Date' $date
        Value 'Title' 'TEST'
        Value 'URL' 'https:\\test.com'
        Value 'Description' 'THIS IS A TEST'
        Value 'Number of Posts' '1'
        # Or you can use the HTML Div Id
        Value 'Number of Subscribers' '1'
        Value 'Annual Unique Visitors' '1'
        # Still can execute PowerShell within the script block
        Start-Sleep -Seconds 3

   }


.SYNOPSIS
MVPActivity is the top-level definition command, which groups the MVP contribution types into their respective areas.
#>    
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