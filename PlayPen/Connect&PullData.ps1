<#

Import-Module MVP

$SubscriptionKey = Read-Host "Enter In Subscription Key"

Set-MVPConfiguration -SubscriptionKey $SubscriptionKey

PSv5.1 -> C:\WINDOWS\system32>Import-MOdule Selenium
PSv5.1 -> C:\WINDOWS\system32>$Driver = Start-SeFirefox
1592806097555   mozrunner::runner       INFO    Running command: "C:\\Program Files\\Mozilla Firefox\\firefox.exe" "-marionette" "-foreground" "-no-remote" "-profile" "C:\\Users\\MICHAE~1.ZAN\\AppData\\Local\\Temp\\rust_mozprofileu5iTLW"
PSv5.1 -> C:\WINDOWS\system32>$Element = Find-SeElement -Driver $Driver -Id "addNewActivityBtn"
PSv5.1 -> C:\WINDOWS\system32>

#>

Import-Module Selenium

Function Send-EnterKey {
    $wshell = New-Object -ComObject wscript.shell;
    $wshell.SendKeys('{ENTER}')
}

Function Write-Text ($text, $elementId, $NumberOfTimes, [Switch]$sendEnter) {
    # Now Enter the Forum Post
    $ActivityType = Find-SeElement -Driver $Driver -Id $elementId
    Invoke-SeClick -Element $ActivityType
    # Enter in the Text
    0 .. $NumberOfTimes | ForEach-Object {
        $text | ForEach-Object {$Window | Send-Input -Input $_; Start-Sleep -Milliseconds 50}
    }
    if ($sendEnter) {Send-EnterKey}    
    Start-Sleep -Milliseconds 250
}

Function Update-Element($ElementId, $Value) {
    $Element = Find-SeElement -Driver $Driver -Id $ElementId
    Send-SeKeys -Element $Element -Keys $Value
}


$Driver = Start-SeFirefox -StartURL "https://apc01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fazure.microsoft.com%2Femail%2F%3Fdestination%3Dhttps%253A%252F%252Fmvp.microsoft.com%252Fen-us%252FNomination%253Fenid%253Dka3dylo7FAFZULR2KfMbPFYxtmt.NV25aGxn79stFYlpD0NAVyQ4Rb5pYFlojmpSqhdeJupj6fTqPlI1GP1vfKd.qjqp4QqSLFdk3PQ0Bzjo0USJoITeAhpaNQVxf7ksRa3YBViGj75iJfA4r8X3uys3rQi3Jsqc1H7lyefAnjI_%2526rn%253D1%26p%3DbT01YWI4NmQ4OS02MTQxLTRhZDgtYWFiMS05OWZkY2QzYTJjODImdT1hZW8mbD1Ob21pbmF0aW9uXzI%253D&data=02%7C01%7C%7Cf3b47725018143d50e4d08d812df6729%7C84df9e7fe9f640afb435aaaaaaaaaaaa%7C1%7C0%7C637280098001712286&sdata=rcNhJx9yE%2FAtLIsKj8WDE2gsvV4%2FcS6LhaYHHMVUPEA%3D&reserved=0"

#
# Wait for Login

Function Add-PowerShellRedditActivity($Date, $Title, $Description, $URL, $NumberOfAnswers, $NumberOfPosts) {
    #
    # Selet the Window
    $GetWindowElement = Select-UIElement
    $Window = $GetWindowElement.Where{$_.Name -like "MVP Nominee*"} 

    #
    # Create a new Activity

    $ActivityButton = Find-SeElement -Driver $Driver -Id "addNewActivityBtn" -Wait -Timeout 120 
    Invoke-SeClick -Element $ActivityButton

    # Select Third Party Forums
    Write-Text -text "Forum Part" -elementId "activityTypeSelector" -NumberOfTimes 0 

    Start-Sleep -Seconds 2

    # Enter in the Date
    Update-Element -ElementId DateOfActivity -Value $Date
    Update-Element -ElementId TitleOfActivity -Value $Title
    Update-Element -ElementId ReferenceUrl -Value $URL
    Update-Element -ElementId Description -Value 'Responding to Reddit Question'
    Update-Element -ElementId AnnualQuantity -Value $NumberOfAnswers
    Update-Element -ElementId SecondAnnualQuantity -Value $Description

    # Enter in PowerShell
    Write-Text -Text "P" -elementId "select_contributionAreasDDL" -NumberOfTimes 2 -sendEnter

    Start-Sleep -Seconds 1
    $SaveButton = Find-SeElement -Driver $Driver -Id "submitActivityButton"
    Invoke-SeClick -Element $SaveButton
    

    
    Write-Host "A"
}


Write-Host "A"