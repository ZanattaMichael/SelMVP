function Get-ASTInstanceValues {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [System.Management.Automation.Language.CommandAst[]]
        $InstanceValues,
        [Parameter()]
        [string]
        $ParameterName
    )
 
    $values = [System.Collections.Generic.List[String]]::New()

    # Split Instances with ParameterNames and Without ParameterNames
    $InstanceValuesWithParameterNames,$InstanceValuesWithoutParameterNames = $InstanceValues.Where({
        $_.CommandElements.Where{$_.ParameterName}
    }, 'Split')

    # Return a list of cmdlet's that have parsed parameters into the input and capture their values
    forEach ($valueInstance in $InstanceValuesWithParameterNames) {

        $Result = 0..$valueInstance.CommandElements.count | Where-Object { 
            ($valueInstance.CommandElements[$_].ParameterName -eq $ParameterName) 
        }

        # Get the following item in the array, which will be the value of the parameter name
        $values.Add($valueInstance.CommandElements[$Result+1].Value)

    }

    $InstanceValuesWithoutParameterNames | ForEach-Object { $values.Add( $_.CommandElements[1].Value )  }

    return $values

}