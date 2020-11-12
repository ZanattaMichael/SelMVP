function Test-SEContributionAreas {
    [cmdletbinding()]
    param()
    $result = $false
    # If there Driver Variable is $null. Throw a Terminating Error
    if ($null -ne $Global:SEContributionAreas) { $result = $true }
    Write-Output $result

}