function Add-TypeContribution {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]
        $ContributionArea        
    )
     
    #
    # Create a new Activity
    New-MVPActivity

    #
    # Select the Area DropDown
    Select-ActivityType -SelectedValue ForumParticipation3rdParty

    #
    # Select the Contribution Area
    Select-ContributionArea -SelectedValue $ContributionArea

    #region MainBlock

    <# MAKE CHANGES HERE USING:
        # Enter in the Details
        Update-Element -ElementId DateOfActivity -Value $Date
        Update-Element -ElementId TitleOfActivity -Value $Title
        Update-Element -ElementId ReferenceUrl -Value $URL
        Update-Element -ElementId Description -Value $Description
        Update-Element -ElementId AnnualQuantity -Value $NumberOfAnswers
        Update-Element -ElementId SecondAnnualQuantity -Value $NumberOfPosts
    #>

    #endregion MainBlock

    #
    # Save
    Save-MVPActivity

}

Export-ModuleMember Add-ContributionTemplate
