Describe "Wait-ForMVPElement" -Tag Unit {

    BeforeAll {
        $Global:MVPDriver = [PSCustomObject]@{
            Name = "Data"
            Url = ''
        }
    }

    it "Standard Execution" {

        Mock -CommandName Enter-SeUrl -MockWith {}
        Mock -CommandName Find-SeElement -MockWith {
            [PSCustomObject]@{
                Data = 'Test'
            }
        }
        Mock -CommandName Start-Sleep -MockWith {}
        Mock -CommandName Write-Debug -MockWith {}
        Mock -CommandName Write-Warning -MockWith {}

        Wait-ForMVPElement

        Should -Invoke Find-SeElement -Exactly 1
        Should -Invoke Write-Debug -Exactly 1
        Should -Invoke Enter-SeUrl -Exactly 0

    }

    it "Where it times out" {

        Mock -CommandName Enter-SeUrl -MockWith {}
        Mock -CommandName Find-SeElement -MockWith {}
        Mock -CommandName Start-Sleep -MockWith {}
        Mock -CommandName Write-Debug -MockWith {}
        Mock -CommandName Write-Warning -MockWith {}
        Mock -CommandName Write-Error -MockWith {}

        Wait-ForMVPElement

        Should -Invoke Write-Error -Exactly 1
        Should -Invoke Write-Debug -Exactly 11
        Should -Invoke Enter-SeUrl -Exactly 10

    }

    it "Raises a 500 raised from Microsoft" {

        Mock -CommandName Enter-SeUrl -MockWith {
            $Global:MVPDriver.Url = 'https://mvp.microsoft.com/Error/500?aspxerrorpath=/' 
        }
        Mock -CommandName Find-SeElement -MockWith {}
        Mock -CommandName Start-Sleep -MockWith {}
        Mock -CommandName Write-Debug -MockWith {}
        Mock -CommandName Write-Warning -MockWith {}

        {Wait-ForMVPElement} | Should -Throw "*$($LocalizedData.Error500)*"

    }    

}