Function Wait-ForJavascript {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]
        $ElementTextToSearch       
    )
    
    Test-SEDriver

    #
    # Sometimes the Javascript dosen't load and add elements
    # to the HTML page. This checks to see if the element text is present
    # and if so, then continue.

    $retry = 0

    Do {
        if ($Global:Driver.PageSource -like ("*{0}*" -f $ElementTextToSearch)) { break }
        Start-Sleep -Seconds 1
        $retry++
    } Until ($retry -eq 3)
    
    if ($retry -eq 3) {
        $PSCmdlet.ThrowTerminatingError("Javascript Timeout!")
    }
    
}