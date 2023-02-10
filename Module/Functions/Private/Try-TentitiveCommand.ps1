function ttry {
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

#Yup it's gotta be flipped, because I need to mock ttry and I can't mock and alias.
Set-Alias -Name "Try-TentativeCommand" -Value "ttry"