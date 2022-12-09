function Area {
<#
.Description
Used inside of the MVPActivity block, the ‘Area’ Describes the Contribution Area.
The Current List of Areas are:

+    Article
+    Blog/WebSite Post
+    Book (Author)
+    Book (Co-Author)
+    Conference (Staffing)
+    Docs.Microsoft.com Contribution
+    Forum Moderator
+    Forum Participation (3rd Party forums)
+    Forum Participation (Microsoft Forums)
+    Mentorship
+    Microsoft Open Source Projects
+    Non-Microsoft Open Source Projects
+    Organizer (User Group/Meetup/Local Events)
+    Organizer of Conference
+    Other
+    Product Group Feedback
+    Sample Code/Projects/Tools
+    Site Owner
+    Speaking (Conference)
+    Speaking (User Group/Meetup/Local events)
+    Technical Social Media (Twitter, Facebook, LinkedIn...)
+    Translation Review, Feedback and Editing
+    Video/Webcast/Podcast
+    Workshop/Volunteer/Proctor

.PARAMETER SelectedValue
The MVP Contribution Area

.EXAMPLE
Area 'Article'

.SYNOPSIS
'Area' defines the MVP Contribution Area within the Portal. Area can only be used within MVPActivity.
#>
    [CmdletBinding()]
    param(
        # Selected Value
        [Parameter(Mandatory=$true)]
        [String]
        $SelectedValue
    )
   
    begin {

        # Test if the Driver is active. If not throw a terminating error.
        Test-SEDriver
        # Test the Callstack.
        Test-CallStack $PSCmdlet.MyInvocation.MyCommand.Name
        
    }

    Process {


        # Validate the $SelectedValue Attributes
        [Array]$matchedActivityType = Get-ActivityTypes | Where-Object { $_.Name -eq $SelectedValue }
        if ($matchedActivityType.Count -eq 0) { Throw ($LocalizedData.ErrorMissingSelectedValue -f $SelectedValue) }
        if ($matchedActivityType.Count -ne 1) { Throw ($LocalizedData.ErrorTooManySelectedValue -f $SelectedValue, $matchedActivityType.count) }
        
        # If the Activity Type matches, we need to do a lookup to get the HTML Form structure
        $HTMLFormStructure = Get-HTMLFormStructure $SelectedValue

        # Select the Element        
        $output = ttry {

            Select-DropDown -elementId $LocalizedData.ElementIdActivityType -selectedValue $matchedActivityType.Value

            # We are using Views of Answers to dertmine if the Javascript has ran
            $HTMLFormStructure | ForEach-Object {
                Wait-ForJavascript -ElementText $_.Name
            }

            # Update the Area
            $Script:MVPArea = $SelectedValue
            $Script:MVPHTMLFormStructure = $HTMLFormStructure

            Write-Output $true

        } -Catch {       
            # If the Javascript Fails to Populate the Sub entries within the form       
            # it will retrigger by select the "Article"
            Start-Sleep -Seconds 1
            Select-DropDown -elementId $LocalizedData.ElementIdActivityType -selectedValue $LocalizedData.ElementValueArticle   
        } -RetryLimit 10
        
        # If it failed to select the Area, we need to fail the cmdlet
        if ($output -ne $true) {
            # Throw a terminating error
            Throw $LocalizedData.ErrorAreaFailure
        }

    }

}
