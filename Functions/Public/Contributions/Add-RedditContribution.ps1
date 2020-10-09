Function Add-RedditContribution {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]
        $ContributionArea,
        [Parameter(Mandatory)]
        [DateTime]
        $Date,
        [Parameter(Mandatory)]
        [String]
        $Title,
        [Parameter(Mandatory)]
        [String]
        $Description,
        [Parameter(Mandatory)]
        [String]
        $URL,
        [Parameter(Mandatory)]
        [String]
        $NumberOfAnswers,                                                
        [Parameter(Mandatory)]
        [String]
        $NumberOfPosts
    )

    #
    # Create a new Activity
    New-MVPActivity

    # Select ForumParticipation3rdParty Forums in the DropDown Box
    # The reason why it's in a loop is becuase the javascript won't load and will need to be retriggered.
    Select-AreaDropdown-SelectedValue ForumParticipation3rdParty

    #
    # Select the Contribution Area
    Select-ContributionArea -SelectedValue $ContributionArea
    
    # Enter in the Details
    Update-Element -ElementId DateOfActivity -Value $Date
    Update-Element -ElementId TitleOfActivity -Value $Title
    Update-Element -ElementId ReferenceUrl -Value $URL
    Update-Element -ElementId Description -Value $Description
    Update-Element -ElementId AnnualQuantity -Value $NumberOfAnswers
    Update-Element -ElementId SecondAnnualQuantity -Value $NumberOfPosts

    #
    # Save
    Save-MVPActivity

}

Export-ModuleMember Add-RedditContribution
