function Test-ActivityScriptBlock {
    [CmdletBinding()]
    param (
        # Scriptblock to invoke
        [Parameter(Mandatory)]
        [ScriptBlock]
        $Fixture,
        [Parameter()]
        [HashTable]
        $ArgumentList
    )

    Write-Debug "[Test-ActivityScriptBlock] Validating Scriptblock:"

    #
    # Return an Object
    $resultObject = [PSCustomObject]@{
        ParametrizedArea = $false
        ParametrizedContributionArea = $false
    }

    #
    # Return a list of Commands
    $CommandAst = $Fixture.ast.FindAll({$args[0] -is [System.Management.Automation.Language.CommandAst]}, $true)
    $AreaValue = $null

    # Requirement 1:
    # Ensure that there are no additional MVPActivity scriptblocks within it.
    if ($CommandAst -match $LocalizedData.TestActivityRegexMVPActivity) {
        Throw $LocalizedData.ErrorNestedMVPActivity
    }

    # Requirement 2:
    # Ensure that a Area is present and it's a single instance.
    $areaInstance = $CommandAst -match $LocalizedData.TestActivityRegexMVPArea
    if (($areaInstance.count -eq 0) -and ($null -eq $ArgumentList.Area)) {
        # No Instances were found
        Throw $LocalizedData.ErrorMissingMVPActivityArea
    } elseif (($areaInstance.count -eq 0) -and ($null -ne $ArgumentList.Area)) {
        $resultObject.ParametrizedArea = $true
        $AreaValue = $ArgumentList.Area
    } elseif ($areaInstance.count -ne 1 ) {
        # Multiple Statements of Area was defined
        Throw $LocalizedData.ErrorMissingMVPActivityAreaMultiple
    } elseif (($areaInstance.count -ne 0) -and ($null -eq $ArgumentList.Area)) {
        $AreaValue = $areaInstance.CommandElements[1].Value
    }

    # Requirement 3:
    # Ensure that the ContributionArea is present and that there is a maximum of two contributions.
    $MVPContributionArea = $CommandAst -match $LocalizedData.TestActivityRegexMVPContributionArea
    if ((($MVPContributionArea).Count -eq 0) -and ($null -eq $ArgumentList.ContributionArea)) {
        Throw $LocalizedData.ErrorMissingMVPActivityContributionArea
    } elseif (($MVPContributionArea.count -eq 0) -and ($null -ne $ArgumentList.ContributionArea)) {
        $resultObject.ParametrizedContributionArea = $true        
    } elseif (($MVPContributionArea).Count -gt 3)  {
        Throw ($LocalizedData.ErrorExceedMVPActivityContributionArea -f $MVPContributionArea.Count)
    }

    # Requirement 4:
    # Ensure that the Value Cmdlet is present.
    [Array]$valueInstances = $CommandAst -match $LocalizedData.TestActivityRegexMVPValue
    if ($valueInstances.Count -eq 0) {
        Throw $LocalizedData.ErrorMissingMVPActivityValue
    }


    # Requirement 5:
    # Ensure that all values are correct according to the Area

    $ValuesAddedToScriptblock = [System.Collections.Generic.List[String]]::New()

    $valueInstancesWithParameterNames,$valueInstancesWithoutParameterNames = $valueInstances.Where({
        $_.CommandElements.Where{$_.ParameterName}
    }, 'Split')

    # Return a list of cmdlet's that have parsed parameters into the input and capture their values
    forEach ($valueInstance in $valueInstancesWithParameterNames) {

        $Result = 0..$valueInstance.CommandElements.count | Where-Object { 
            ($valueInstance.CommandElements[$_].ParameterName -eq "Name") 
        }

        # Get the following item in the array, which will be the value of the parameter name
        $ValuesAddedToScriptblock.Add($valueInstance.CommandElements[$Result+1].Value)

    }

    $valueInstancesWithoutParameterNames | ForEach-Object { $ValuesAddedToScriptblock.Add( $_.CommandElements[1].Value )  }

    # Get the HTMLFormStructure and Test for the
    $HTMLFormStructure = Get-HTMLFormStructure -Name $AreaValue

    $testMandatoryValues = $HTMLFormStructure | Where-Object { (
        ($_.isRequired) -and 
        (
            ($_.Name -notin $ValuesAddedToScriptblock) -and 
            ($_.Element -notin $ValuesAddedToScriptblock)
        )    
    )}

    $testMisnamedValues = $ValuesAddedToScriptblock | Where-Object {
        $_ -notin $HTMLFormStructure.Name -and 
        $_ -notin $HTMLFormStructure.Element
    }

    if ($testMandatoryValues -or $testMisnamedValues) {
        Throw ($LocalizedData.ErrorPreParseValueCheck -f $AreaValue)
    }

    #
    # Finished

    Write-Output $resultObject
    
    Write-Debug "[Test-ActivityScriptBlock] All Tests Passed:"

}