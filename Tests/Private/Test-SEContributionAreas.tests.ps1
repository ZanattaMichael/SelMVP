Describe "Test-SEContributionAreas" {

    afterAll {
        Remove-Variable -Name SEContributionAreas -Scope Global
    }

    it "When the variable is empty will return `$false" {

        $Global:SEContributionAreas = $null
        $results = Test-SEContributionAreas

        $results | Should -be $false

    }

    it "When the variable is not empty will return `$true" {

        $Global:SEContributionAreas = "TEST"
        $results = Test-SEContributionAreas

        $results | Should -be $true

    }

}