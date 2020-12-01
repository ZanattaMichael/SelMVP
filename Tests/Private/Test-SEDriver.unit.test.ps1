Describe "Test-SEDriver" -Tag Unit {

    BeforeEach {
        Try { Remove-Variable MVPDriver -Scope Global -ErrorAction SilentlyContinue } Catch { }
    }

    It "Should return an error if no variable is set" {       
        { Test-SEDriver } | Should -Throw $LocalizedData.ErrorMissingDriver
    }

    It "Should return an error if the URL property is `$null" {       
        $Global:MVPDriver = [PSCustomObject]@{ Data = "TEST"}
        { Test-SEDriver } | Should -Throw $LocalizedData.ErrorMissingDriver
    }    

    It "Shouldn't return an error if a variable is set" {
        $Global:MVPDriver = [PSCustomObject]@{ Data = "TEST"; Url = "Data"}
        { Test-SEDriver } | Should -Not -Throw
    }

}