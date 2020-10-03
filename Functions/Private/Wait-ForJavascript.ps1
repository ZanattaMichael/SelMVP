Function Wait-ForJavascript {
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
        $ElementTextToSearch       
    )
    
    #
    # Sometimes the Javascript dosen't load and add elements
    # to the HTML page. This checks to see if the element text is present
    # and if so, then continue.

    $retry = 0

    Do {
        if ($Driver.PageSource -like ("*{0}*" -f $ElementTextToSearch)) { break }
        Start-Sleep -Seconds 1
        $retry++
    } Until ($retry -eq 3)
    
    if ($retry -eq 3) {
        $PSCmdlet.ThrowTerminatingError("Javascript Timeout!")
    }
    
}