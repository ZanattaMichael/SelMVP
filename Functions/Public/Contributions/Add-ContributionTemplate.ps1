function Add-TypeContribution {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateScript({
            ($_ -is [OpenQA.Selenium.Firefox.FirefoxDriver]) -or
            ($_ -is [OpenQA.Selenium.Chrome.ChromeDriver])
        })]
        [Object]
        $Driver,
        [Parameter(Mandatory)]
        [String]
        $ContributionArea        
    )
     
    #
    # Create a new Activity
    New-MVPActivity -Driver $Driver

    #
    # Select the Area DropDown
    Select-AreaDropdown -Driver $Driver -SelectedValue ForumParticipation3rdParty

    #
    # Select the Contribution Area
    Select-ContributionArea -Driver $Driver -SelectedValue $ContributionArea

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
