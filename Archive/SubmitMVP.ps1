

#
# This code is run in sections. F8 the functions and the driver to start the process.
# Import your data and then run it from there.
# Does not work on PowerShell Core.

Import-Module Selenium

<#
Function Select-DropDown {
    #
    # Selects a Value in a DropDown box.
    [cmdletbinding(
        DefaultParameterSetName = 'Standard'
    )]
    param (
        [parameter(Mandatory)]
        [String]
        $elementId,
        [parameter(Mandatory)]
        [ValidateSet("ForumParticipation3rdParty","PowerShell","Article","Other")]
        [String]
        $selectedValue
    )

    #
    # You will need to inspect the elements on the HTML to add additional drop down settings.
    # Make sure you set the id as the value

    switch ($selectedValue) {
        'ForumParticipation3rdParty' { $value = 'd96464de-179a-e411-bbc8-6c3be5a82b68' }
        'PowerShell' { $value = '7cc301bb-189a-e411-93f2-9cb65495d3c4' }
        'Article' { $value = 'e36464de-179a-e411-bbc8-6c3be5a82b68' }
        'Other' { $value = 'ff6464de-179a-e411-bbc8-6c3be5a82b68' }
    }

    $ActivityType = Find-SeElement -Driver $Driver -Id $elementId
    $SelectElement = [OpenQA.Selenium.Support.UI.SelectElement]::new($ActivityType)
    $SelectElement.SelectByValue($value)

}

#>




#
# You can customize your submissions into different functions
# Each of the Parameters are requirements that are needed.
#


#
#
# Main Code
#
#


$Driver = Start-SeFirefox -StartURL ""



#
# Reddit Data
$RedditData = Import-CSV -LiteralPath ""


$id = 0
ForEach ($Post in $RedditData) {

    $params = @{
        Date = $Post.Date
        Title = $Post.Title
        Description = $Post.Description
        URL = $Post.URL
        NumberOfAnswers = $Post.NumberOfAnswers
        NumberOfPosts = $Post.NumberOfPosts
    }
    #$params
    Add-PowerShellRedditActivity @params

    write-host "$id Complete" -ForegroundColor Green
    $id++
}
