$Auth = Invoke-WebRequest 

"https://www.reddit.com/api/v1/authorize?client_id=O26xwQJO1M43YQ&response_type=code&state=mvp4life&redirect_uri=https%3A%2F%2F127.0.0.1%2F&duration=permanent&scope=identity history  mysubreddits privatemessages read"


/r/mysubreddit/top/.json?count=20

https://127.0.0.1/

2TaLR0d1mHGVXhWLhcPzqCzvW2A

$clientsecret = 'O26xwQJO1M43YQ:PEWvlLDpx-uGpmxLOmpmySkz9b8'
$userPass = [system.convert]::tobase64string([char[]]$clientsecret)

$Param = @{
    URI = "https://www.reddit.com/api/v1/access_token"
    Method = "POST"
    ContentType = "application/x-www-form-urlencoded"
    Body = @{
       grant_type='authorization_code'
       code= 'ML5O3ZiBOA6bYsaAYZnw_Px6Goo'
       redirect_uri='https://127.0.0.1/'
    }
    Header = @{
        Authorization = "Basic $userPass"
    }
}

$Token = Invoke-RestMethod @param

$URI = 'https://oauth.reddit.com/api/v1'
$URI2 = 'https://oauth.reddit.com/'

$header = @{
    Authorization = "Bearer $($Token.access_token)"
    ContentType = "application/json"
}

# Me
$me = Invoke-RestMethod -Method Get -Headers $header -Uri "$URI/me"

# Get Karma Breakdown
$karma = Invoke-RestMethod -Method Get -Headers $header -Uri "$URI/me/karma" 

#
# Get All Comments
#

$arr = @()
$obj = $null
Do {
    # Submitted
    $obj = Invoke-RestMethod -Method Get -Headers $header -Uri "$($URI2)user/PowerShellMichael/comments.json?limit=100&after=$($obj.data.after)" 
    $arr += $obj.Data.children
} Until ($null -eq $obj.data.after)

#
# Sort Comments by URL to give us the data we need. :-D

$Responses = $arr.data | Group-Object -Property link_url

$Data = $Responses | ForEach-Object {

    # Iterate Through Each Submission
    $items = $_

    ForEach ($item in $items.Group) {

            [PSCustomObject]@{
                Date = Format-Date $item.created
                Title = ""
                Description = "Tile of the Post: {0}
Number of UpVotes: {2}
Response:         
`"{1}`"
" -f $item.link_title, $item.body, $item.ups
                URL = $item.link_url
                NumberOfAnswers = @($items.Group).count
                NumberOfPosts = @($items.Group).count
            }
    }
}

# Export all the Data to CliXMl
$Data | Export-Clixml -LiteralPath 'D:\OneDrive\MVP\REDDIT_EXPORT_CLIXML\FormattedData.clixml'

Function Format-Date($Seconds) {

    [datetime]$origin = '1970-01-01 00:00:00'
    $origin.AddSeconds($Seconds)
    write-host "A"
}


#
# Time to Extract the PowerShell Posts
#

$arr = @()
$obj = $null
Do {
    # Submitted
    $obj = Invoke-RestMethod -Method Get -Headers $header -Uri "$($URI2)user/PowerShellMichael/submitted.json?limit=100&after=$($obj.data.after)" 
    $arr += $obj.Data.children
} Until ($null -eq $obj.data.after)

