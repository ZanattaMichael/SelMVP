function Test-CallStack {
    [CmdletBinding()]
    param()

    return ((Get-PSCallStack).Command -contains "MVPActivity")

}