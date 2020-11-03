New-Variable -Name HTMLFormStructureValidate -Scope Global -Option ReadOnly -Force -Value @(

    @{
        Name = "Date"
        Format = {
            param($date)
            $currentCultureDate = [DateTime]::Parse($date, [cultureinfo]::New((Get-Culture).Name))                    
            write-output ($currentCultureDate.ToString("MM/dd/yyyy"))
        }
    }

    @{
        Name = "URL"
        Format = {
            param($url)
            Write-Output ([URI]::New($url).AbsoluteUri)
        }
    }    

)