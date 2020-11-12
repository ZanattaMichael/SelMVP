Describe "Test-SEActivityTypes" {

    afterAll {
        Remove-Variable -Name SEActivityTypes -Scope Global
    }

    it "When the variable is empty will return `$false" {

        $Global:SEActivityTypes = $null
        $results = Test-SEActivityTypes

        $results | Should -be $false

    }

    it "When the variable is not empty will return `$true" {

        $Global:SEActivityTypes = "TEST"
        $results = Test-SEActivityTypes

        $results | Should -be $true

    }

}