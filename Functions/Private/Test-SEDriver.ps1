function Test-SEDriver {
    
    # If there Driver Variable is $null. Throw a Terminating Error
    if ($null -eq $Global:Driver) { Throw "Missing Selinum Driver. Use: ConnectTo-Selenium to connect!" }

}