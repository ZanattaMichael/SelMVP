

$FormattedData = Import-CliXML -LiteralPath "D:\OneDrive\MVP\REDDIT_EXPORT_CLIXML\FormattedData.clixml"
$CSV = Import-CSV -LiteralPath "D:\OneDrive\MVP\REDDIT_EXPORT_CLIXML\RedditContributionsCSV.csv"


ForEach ($Data in $FormattedData) {

    $b = $Data.Date.ToString("ddMMyyyy")
    $meh = [datetime]::ParseExact($b, "ddMMyyyy", $null)

    $matched = $CSV.Where{
        ($_.URL -eq $Data.URL)
    }

    if (@($matched).Count -eq 0) { 
        write-host "Skipped"
        continue
    }

    if ($matched.Count -gt 1) {
        $matched = $matched.Where{
            $meh -eq (Get-Date $_."Date AU")
        }
    }

    $Data.Date = $matched."Date US"
    $Data.Title = @($matched.Action)[0]

}

$FormattedData, $UnFormattedData = $FormattedData.Where({$_.Title -ne ""}, 'Split')

$UnFormattedData | Export-Csv -LiteralPath 'D:\OneDrive\MVP\REDDIT_EXPORT_CLIXML\unformatted.csv'
$FormattedData | Export-Csv -LiteralPath 'D:\OneDrive\MVP\REDDIT_EXPORT_CLIXML\formattedData.csv'
