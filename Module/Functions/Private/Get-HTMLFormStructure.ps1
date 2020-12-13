function Get-HTMLFormStructure {
    [CmdletBinding()]
    param (
       # Parameter help description
       [Parameter(Mandatory)]
       [String]
       $Name
    )

    Write-Verbose "Get-HTMLFormStructure Started:"

    # Trim the input so that we can be more forgiving.
    $Name = $Name.Trim()

    $output = [System.Collections.Generic.List[PSCustomObject]]::New()

    # The Default Parameter Value is Prohibited
    if ($Name -eq "Default") { Throw $LocalizedData.ErrorHTMLFormStructureDefaultParameter }

    $defaultProperties = $Global:HTMLFormStructure.Where{$_.Name -eq 'Default'}
    [Array]$matched = $Global:HTMLFormStructure.Where{($_.Name -eq $Name) -or ($_.Element -eq $Name)}

    # If the Either The Element of the String name can't be found, 
    # then Throw a terminating error.
    if ($matched.count -eq 0) {
        Throw ($LocalizedData.ErrorHTMLFormStructureMissingName -f $Name)
    }

    # If there is more then 1 result, data duplicate. Throw temrinating error.
    if ($matched.count -ne 1) {
        Throw ($LocalizedData.ErrorHTMLFormStructureMissingName -f $Name)
    }

    # Join the Default data with the matched data
    forEach ($Property in $defaultProperties.Properties) {
        # Test if the Element Already Exists. If so, skip.
        if ($matched.Properties.Element -contains $Property.Element) { 
            Write-Debug ("[Get-HTMLFormStructure] Duplicate Element '{0}'" -f $Property.Element)
            continue 
        }

        $obj = [PSCustomObject]@{
            Name = $Property.Name
            Element = $Property.Element
            isRequired = $(
                if ($Property.Keys -notcontains "isRequired") { $false }
                else { $Property.isRequired }
            )
            isSet = $false
        }

        Write-Debug ("[Get-HTMLFormStructure] Adding Default Element '{0}' " -f ($obj | ConvertTo-Json))
        $output.Add($obj)     
    }

    forEach ($Property in $matched.properties) {

        $obj = [PSCustomObject]@{
                    Name = $Property.Name
                    Element = $Property.Element
                    isRequired = $(
                        if ($Property.Keys -notcontains "isRequired") { $false }
                        else { $Property.isRequired }
                    )
                    isSet = $false
                }

        Write-Debug ("[Get-HTMLFormStructure] Adding Element '{0}' " -f ($obj | ConvertTo-Json))
        $output.Add($obj)

    }

    #
    # Join the Formatting Scriptblock form the HTMLFormStructureValidate Variable.
    $output = $output | Select-Object *, @{
        Name = "Format"
        Expression = { 
            $Name = $_.Name
            try { ($Global:HTMLFormStructureValidate.Where{$_.Name -eq $Name}).Format } catch {}
        }
    }

    Write-Output $output      
    Write-Verbose "Get-HTMLFormStructure Completed:"

}
