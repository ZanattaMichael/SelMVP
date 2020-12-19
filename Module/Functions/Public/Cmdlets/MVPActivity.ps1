function MVPActivity {
<#
.Description
MVPActivity is the top-level definition command, which groups the MVP contribution types into their respective areas.

This command is responsible for buildup (creation) and (tear-down) of the contribution. There are two types of input with this command:

1. CSV Import and,
2. The Domain Specific Language.

The CSV Import is a 'simplified' input parameter, however *each* CSV import is limited to a seperate 'Area'.
If you choose to use the Domain Specific Language type, commands: 'Area', 'ContributionArea' and 'Value' are mandatory. 
MVPActivity also performs input validation ensuring that input meets the requirements of the HTML form.

.PARAMETER Name
Name is the name of the MVPActivity. This provides a visual grouping of data that is being added to the MVP Portal.

.PARAMETER CSVPath
Import the CSV File and Parse it.
Please Note: *The headers 'Area' & 'ContributionArea' are mandatory.*
Adding Secondary and Tertiary 'ContributionAreas' is done by using: 'SecondContributionArea' and 'ThirdContributionArea' (See Example Below)

    MVPActivity -CSVPath 'Path to CSV File'

Example CSV File:

Date,Title,URL,Description,Number of Articles,Number of Views,Area,ContributionArea,SecondContributionArea,ThirdContributionArea
28/11/2020,TEST,https://www.google.com,TEST,1,1,Article,PowerShell,Networking,Storage
28/11/2020,TEST,https://www.google.com,TEST,1,1,Article,PowerShell,Networking,Storage

.PARAMETER ArgumentList
MVPActivity supports arguments being parsed into it using the -ArgumentList parameter, similarly to the -TestCases parameter within Pester.
Inputs are defined as a [HashTable] or a [HashTable[]] with the name of the parameter being the [HashTable] key and it's value being the item.
To use the parameters that have been parsed into the fixture, use the param() block at the beginning of the fixture with the ParameterName.

In the example below we declare the parameters and parse them into MVPActivity:

# Declare the parameters:
$param = @{
    Parameter1 = 'Test'
}

# Parse the Arguments by using the -ArgumentList parameter:
MVPActivity "Test Entry" -ArgumentList $param  {
    # To get the value from $Parameter1, add a param() within the fixture/scriptblock.
    param($Parameter1)

    # We can reference the value by referencing the variable name '$Parameter1'
    Area $Parameter1 'Value'

}

The -ArgumentList parameter also supports an array of hashtables ([HashTable[]]) with common values, providing a way to parse multiple parameters into the same fixture.
For Example:

# Declare the parameters as an array:
$param = @(
    @{
        Parameter1 = 'One Value'
    }    
    @{
        Parameter1 = 'Another Value'
    }
)

MVPActivity "Test Entry" -ArgumentList $param  {
    param($Parameter1)

    Area $Parameter1 'Value'

}

This will process 'Parameter1' as a seperate MVP Contribution.

.PARAMETER Fixture
The Fixture/Scriptblock contains the DSL PowerShell code that adds the MVP entry to the portal.
The Fixture is a regular Powershell scriptblock, however Area, ContributionArea and Value are mandatory commands.

*Please ensure that 'Area', 'ContributionArea' are prefixed before 'Value'*.

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