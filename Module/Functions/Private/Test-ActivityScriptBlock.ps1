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
        ParametrizedVisibility = $false
    }

    #
    # Return a list of Commands
    $CommandAst = $Fixture.ast.FindAll({$args[0] -is [System.Management.Automation.Language.CommandAst]}, $true)
    $AreaValue = $null
    $ContributionAreaValues = $null

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
        $AreaValue = Get-ASTInstanceValues -InstanceValues $areaInstance -ParameterName 'Name'
    }

    # Requirement 3:
    # Ensure that the ContributionArea is present and that there is a maximum of two contributions.
    $ContributionAreaInstance = $CommandAst -match $LocalizedData.TestActivityRegexMVPContributionArea
    if ((($ContributionAreaInstance).Count -eq 0) -and ($null -eq $ArgumentList.ContributionArea)) {
        Throw $LocalizedData.ErrorMissingMVPActivityContributionArea
    } elseif (($ContributionAreaInstance.count -eq 0) -and ($null -ne $ArgumentList.ContributionArea)) {
        $resultObject.ParametrizedContributionArea = $true
        $ContributionAreaValues = $ArgumentList.ContributionArea        
    } elseif (($ContributionAreaInstance).Count -gt 3)  {
        Throw ($LocalizedData.ErrorExceedMVPActivityContributionArea -f $ContributionAreaInstance.Count)
    } elseif (($ContributionAreaInstance.count -ne 0) -and ($null -eq $ArgumentList.ContributionArea)) {
        $ContributionAreaValues = Get-ASTInstanceValues -InstanceValues $ContributionAreaInstance -ParameterName 'SelectedValue'
    }

    # Requirement 4:
    # Ensure that the Value Cmdlet is present.
    [Array]$valueInstances = $CommandAst -match $LocalizedData.TestActivityRegexMVPValue
    if ($valueInstances.Count -eq 0) {
        Throw $LocalizedData.ErrorMissingMVPActivityValue
    }

    # Requirement 5:
    # Visibility dosen't need to be included into the statement, however ensure that there are only one of them.
    [Array]$visibilityInstances = $CommandAst -match $LocalizedData.TestActivityRegexMVPVisibility
    if ($visibilityInstances.Count -gt 1) {
        Throw $LocalizedData.ErrorMultipleVisibilityStatements
    } 
    # If Visability is included as a parameter, process it.
    elseif (($visibilityInstances.count -eq 0) -and ($null -ne $ArgumentList.Visibility)) {
        $resultObject.ParametrizedVisibility = $true          
    }

    # Requirement 6:
    # Ensure that all Values added to the fixture are (required) AND are correct
    $HTMLFormStructure = Get-HTMLFormStructure -Name $AreaValue
    $ASTInstanceValues = Get-ASTInstanceValues -InstanceValues $valueInstances -ParameterName 'Name'

    $testMandatoryValues = $HTMLFormStructure | Where-Object { (
        ($_.isRequired) -and 
        (
            ($_.Name -notin $ASTInstanceValues) -and 
            ($_.Element -notin $ASTInstanceValues)
        )    
    )}

    $testMisnamedValues = $ASTInstanceValues | Where-Object {
        $_ -notin $HTMLFormStructure.Name -and 
        $_ -notin $HTMLFormStructure.Element
    }

    if ($testMandatoryValues -or $testMisnamedValues) {
        Throw ($LocalizedData.ErrorParseValueCheck -f $AreaValue)
    }

    # Requirement 5:
    # Ensure that all ContributionAreas are added to the fixture are (required) AND are correct

    if ($ContributionAreaValues | Where-Object { $_ -notin $Global:HTMLContributionAreas}) {
        Throw ($LocalizedData.ErrorParseContributionAreaCheck -f $AreaValue)
    }

    #
    # Finished

    Write-Output $resultObject
    
    Write-Debug "[Test-ActivityScriptBlock] All Tests Passed:"

}