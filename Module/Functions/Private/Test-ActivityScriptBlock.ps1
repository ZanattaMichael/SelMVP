function Test-ActivityScriptBlock {
    [CmdletBinding()]
    param (
        # Scriptblock to invoke
        [Parameter(Mandatory)]
        [ScriptBlock]
        $Fixture
    )

    #
    # Return a list of Commands
    $CommandAst = $Fixture.ast.FindAll({$args[0] -is [System.Management.Automation.Language.CommandAst]}, $true)

    # Requirement 1:
    # Ensure that there are no additional MVPActivity scriptblocks within it.
    if ($CommandAst -match $LocalizedData.TestActivityRegexMVPActivity) {
        $PSCmdlet.ThrowTerminatingError($LocalizedData.ErrorNestedMVPActivity)
    }

    # Requirement 2:
    # Ensure that a Area is present and it's a single instance.
    $areaInstance = $CommandAst -match $LocalizedData.TestActivityRegexMVPArea
    if ($areaInstance.count -eq 0) {
        # No Instances were found
        $PSCmdlet.ThrowTerminatingError($LocalizedData.ErrorMissingMVPActivityArea)
    } elseif ($areaInstance.count -ne 1 ) {
        # Multiple Statements of Area was defined
        $PSCmdlet.ThrowTerminatingError($LocalizedData.ErrorMissingMVPActivityAreaMultiple)
    }

    # Requirement 3:
    # Ensure that the ContributionArea is present.   
    if ($CommandAst -match $LocalizedData.TestActivityRegexMVPContributionArea) {
        $PSCmdlet.ThrowTerminatingError($LocalizedData.ErrorMissingMVPActivityContributionArea)
    }

    # Requirement 3:
    # Ensure that the Element is present.   
    if ($CommandAst -match $LocalizedData.TestActivityRegexMVPElement) {
        $PSCmdlet.ThrowTerminatingError($LocalizedData.ErrorMissingMVPActivityElement)
    }   

    #
    # Ensure that the statements are organized as follows (Area, ContributionArea, Element)

    

}