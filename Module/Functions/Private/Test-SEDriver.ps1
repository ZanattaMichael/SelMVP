function Test-SEDriver {
    [CmdletBinding()]
    param()
    # If there Driver Variable is $null. Throw a Terminating Error
    if ($null -eq $Global:MVPDriver) {
        $PSCmdlet.ThrowTerminatingError($LocalizedData.ErrorMissingDriver) 
    }

}