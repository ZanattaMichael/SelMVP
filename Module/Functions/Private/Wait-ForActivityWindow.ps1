function Wait-ForActivityWindow {
    [CmdletBinding()]
    param (
    )

    # Test the Selenium Driver
    Test-SEDriver

    # Start Verbose
    Write-Verbose "[Wait-ForActivityWindow] Started:"

    # Wait for the MVPActivity Window to be closed.
    try {
        $DialogElement = Find-SeElement -Driver ($Global:MVPDriver) -ClassName 'mvp-dialog'
    } Catch {
        Throw $_
    }

    While (($null -ne $DialogElement) -and ($DialogElement.Displayed)) {
        Write-Verbose "[Wait-ForActivityWindow] Waiting for 'Add a new activity' to close:"
        Start-Sleep -Seconds 1
    }

    # Start Verbose
    Write-Verbose "[Wait-ForActivityWindow] Finished:"

}