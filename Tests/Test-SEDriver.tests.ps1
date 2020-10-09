Describe "Test-SEDriver" {

    BeforeEach {
        Try { Remove-Variable Driver -Scope Global -ErrorAction Sil  } Catch { }
    }

    It "should return an error if no variable is set" {       
        { Test-SEDriver } | Should -Throw "Missing*"
    }

    It "shouldn't return an error if a variable is set" {
        $Global:Driver = [PSCustomObject]@{}
        { Test-SEDriver } | Should -Not -Throw
    }

}