function Save-MVPActivity {
    
    # Test if the Driver is active. If not throw a terminating error.
    Test-SEDriver
    
    #
    # Save the Activity

    $SaveButton = Find-SeElement -Driver (Get-SEDriver) -Id "submitActivityButton"
    Invoke-SeClick -Element $SaveButton
   
    # Snooze. The more entries you add, it's better to sleep for a little longer.

    if ($null -eq (Get-Variable "SaveActivitySleepCounter" -ErrorAction SilentlyContinue)) {
        $Script:SaveActivitySleepCounter = 1
    }

    $SleepDuration = $Script:SaveActivitySleepCounter * 100
    Start-Sleep -Milliseconds $SleepDuration

    # 5 Seconds is the max wait Time
    if ($Script:SaveActivitySleepCounter -le 50) { $Script:SaveActivitySleepCounter++ }
    
}

Export-ModuleMember Save-MVPActivity