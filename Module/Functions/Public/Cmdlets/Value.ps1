Function Value {
<#
The 'Value' command is used as input entries for the HTML form, using 'Name' (Being the HTML Div Element ID or Text Name) and 'Value' (Corresponding Value) syntax.
Since different 'Area''s have various fields, you can use Get-AreaNamedValues 'AreaName' to locate those fields.

    Value is mandatory within MVPActivity and won't be automatically invoked when specified within the Param() bock.

Value supports auto-formatting of inputted data to meet the requirements of the MVP Portal. Currently, the following Portal dependencies are auto-formatted:

    Date (Required to be US Date Format) (MM-DD-YYYY)
    URL (Required to meet URL format) (https://site.com)

To view the list of Values for an MVP Contribution Area, use: Get-AreaNamedValues 'Name' (Get-AreaNamedValues 'Article')

.PARAMETER Name
The HTML Div Element ID or Text Name

.PARAMETER Value
The input value.

.EXAMPLE
In the example, 'Value' is being used to set the HTML values for the 'Article' MVP Contribution Area.

MVPActivity "Test" {
    
    # Let's set the Area and the Contribution Area
    Area 'Article'

    # We can set the mandatory parameters
    Value "Number of Articles" 1
    Value Title "Test Entry"
    Value Date "30/11/2020"

}

.SYNOPSIS
The Value command is used to input the data into the HTML form, using the 'Name' (Being the HTML Div Element ID or Text Name) and 'Value' (Corresponding Value) syntax.
#>       
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]
        $Name,
        [Parameter(Mandatory)]
        [String]
        $Value
    )
      
    # Test if the Driver is active. If not throw a terminating error.
    Test-SEDriver
    # Test the Callstack.
    Test-CallStack $PSCmdlet.MyInvocation.MyCommand.Name   

    # Get the HTML Element Data
    $htmlElementData = $Script:MVPHTMLFormStructure

    # Attempt to Locate the HTML Element that is needed to update.
    # If there is no value, then there is no data 
    [array]$matched = $htmlElementData.Where{($_.Name -eq $Name) -or ($_.Element -eq $Name)}
    # If the Either The Element of the String name can't be found, 
    # then Throw a terminating error.
    if ($matched.count -eq 0) {
        Throw ($LocalizedData.ErrorCannotFindHTMLElement -f $Name)
    }
    # If there is more then 1 result, data duplicate. Throw temrinating error.
    if ($matched.count -ne 1) {
        Throw ($LocalizedData.ErrorTooManyHTMLElements -f $Name, $matched.count)
    }    
    
    $params = @{
        Keys = $Value
    }

    # If there is a formatting property, then we invoke the scriptblock and format the data
    if ($matched.Format) {

        try {
            # Invoke the Scriptblock
            $params.Keys = $matched.Format.Invoke($Value)
        } catch {
            # Throw an Error if there was a problem.
            Throw ($LocalizedData.ErrorFormattingValue -f $Name, $Value, $_.ToString())
        }
        
    }

    # Fetches the Element and Updates the Field
    $Element = Find-SeElement -Driver ($Global:MVPDriver) -Id $matched[0].Element
    if ($null -eq $Element) { return }
    Send-SeKeys $Element @params

    # Locate and Update the HTMLElement
    $matched[0].isSet = $true

}