function Test-ActivityScriptBlock {
    [CmdletBinding()]
    param (
        # Scriptblock to invoke
        [Parameter(Mandatory)]
        [ScriptBlock]
        $Fixture
    )

    Write-Debug "[Test-ActivityScriptBlock] Validating Scriptblock:"

    #
    # Return a list of Commands
    $CommandAst = $Fixture.ast.FindAll({$args[0] -is [System.Management.Automation.Language.CommandAst]}, $true)

    # Requirement 1:
    # Ensure that there are no additional MVPActivity scriptblocks within it.
    if ($CommandAst -match $LocalizedData.TestActivityRegexMVPActivity) {
        Throw $LocalizedData.ErrorNestedMVPActivity
    }

    # Requirement 2:
    # Ensure that a Area is present and it's a single instance.
    $areaInstance = $CommandAst -match $LocalizedData.TestActivityRegexMVPArea
    if ($areaInstance.count -eq 0) {
        # No Instances were found
        Throw $LocalizedData.ErrorMissingMVPActivityArea
    } elseif ($areaInstance.count -ne 1 ) {
        # Multiple Statements of Area was defined
        Throw $LocalizedData.ErrorMissingMVPActivityAreaMultiple
    }

    # Requirement 3:
    # Ensure that the ContributionArea is present and that there is a maximum of two contributions.
    $MVPContributionArea = $CommandAst -match $LocalizedData.TestActivityRegexMVPContributionArea
    if (($MVPContributionArea).Count -eq 0) {
        Throw $LocalizedData.ErrorMissingMVPActivityContributionArea
    } elseif (($MVPContributionArea).Count -gt 3)  {
        Throw ($LocalizedData.ErrorExceedMVPActivityContributionArea -f $MVPContributionArea.Count)
    }

    # Requirement 4:
    # Ensure that the Value Cmdlet is present.
    [Array]$valueInstance = $CommandAst -match $LocalizedData.TestActivityRegexMVPValue
    if ($valueInstance.Count -eq 0) {
        Throw $LocalizedData.ErrorMissingMVPActivityValue
    }

    # Requirement 5:
    # Ensure that the Mandatory Element Names are present for the Area
    
    # Find the Area and Load the Type
    $HTMLFormType = $Global:HTMLFormStructure
    $areaType = $areaInstance.CommandElements[1].Value
    # Retrive the HTML Form Structure
    $HTMLFormStructure = Get-HTMLFormStructure -Name $areaType
    # Retrive the Parameter Values
    $ParameterValues = $valueInstance.CommandElements.Where{ $_.Value -match $LocalizedData.TestActivityRegexMVPValue}
    
  
    #$areaInstance.CommandElements[1]
    
    Write-Debug "[Test-ActivityScriptBlock] All Tests Passed:"

}