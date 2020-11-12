function Test-CallStack {
    [CmdletBinding()]
    param(
        # Parameter help description
        [Parameter(Mandatory)]
        [String]
        $Name
    )

    if ((Get-PSCallStack).Command -notcontains "MVPActivity") {
        Throw ($LocalizedData.ErrorMissingMVPActivityInCallStack -f $Name)
    }

}