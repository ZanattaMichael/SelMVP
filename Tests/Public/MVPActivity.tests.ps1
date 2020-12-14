Describe "MVPActivity" {

    it "CSV Input. Standard Import." {

        Mock -CommandName 'Import-CSV' -MockWith {
            return @(
                [PSCustomObject]@{
                    Date = 28/11/2020
                    Area = 'Article'
                    ContributionArea = 'PowerShell'
                    SecondContriutionArea = 'Networking'
                    Url = 'https://www.google.com'
                    Description = 'TEST'
                    Title = 'TITLE'
                    'Number of Articles' = 1
                    'Number of Views' = 1
                }
                [PSCustomObject]@{
                    Date = 28/11/2021
                    Area = 'Article'
                    ContributionArea = 'PowerShell'
                    SecondContriutionArea = 'Networking'
                    Url = 'https://www.google.com'
                    Description = 'TEST'
                    Title = 'TITLE2'
                    'Number of Articles' = 1
                    'Number of Views' = 1
                }
            )
        }

        Mock -CommandName 'New-MVPActivity' -MockWith {}
        Mock -CommandName 'Test-Path' -MockWith { return $true }

        $null = MVPActivity -CSVPath 'TEST'

        Should -Invoke "New-MVPActivity" -Exactly 2
        Should -Invoke "Test-CSVSchema" -Exactly 2
        Should -Invoke "New-CSVFixture" -Exactly 2
        Should -Invoke "New-CSVArguments" -Exactly 2

    }

}