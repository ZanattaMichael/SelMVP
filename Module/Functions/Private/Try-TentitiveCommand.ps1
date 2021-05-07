function Try-TentativeCommand {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [Scriptblock]
        $Try,
        [Parameter(Mandatory,  Position = 1)]
        [Scriptblock]
        $Catch,
        [Parameter(Position = 3)]
        [Int]
        $RetryLimit = 3
    )

    $Count = 0
    Do {

        Try {
            $Result = $Try.Invoke()
            break
        } Catch {            
            $Result = $Catch.Invoke()
            $Count++
        }

    } Until ($Count -eq $RetryLimit)

    if ($Count -eq $RetryLimit) {
        Write-Error $LocalizedData.ErrorTryTentitiveCommand
    }

    Write-Debug "[Try-TentativeCommand] Returning:"
    
    return $Result

}

Set-Alias -Name "ttry" -Value "Try-TentativeCommand"