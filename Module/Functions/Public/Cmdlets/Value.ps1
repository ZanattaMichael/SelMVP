Function Value {
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
    $htmlElementData = Get-HTMLFormStructure -Name $Script:MVPArea

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

