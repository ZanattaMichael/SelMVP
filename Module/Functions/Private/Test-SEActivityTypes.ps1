function Test-SEActivityTypes {
    
    $result = $false
    # If there Driver Variable is $null. Throw a Terminating Error
    if ($null -ne $Global:SEActivityTypes) { $result = $true }
    Write-Output $result

}