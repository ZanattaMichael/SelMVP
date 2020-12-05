Describe "New-CSVArguments" {

    $TestCases = @(
        @{
            ImportCSVMock = @(
                [PSCustomObject]@{
                    Area = 'AreaTest'
                    ContributionArea = 'ContributionAreaTest'
                    Column1 = 'Column1'
                    Column2 = 'Column2'
                    Column3 = 'Column3'
                }
            )
            Assert = {
                $Result | Should -Not -BeNullOrEmpty
                $Result.Area | Should -Be 'AreaTest'
                $Result.ContributionArea | Should -Be 'ContributionAreaTest'
                $Result.Column1 | Should -Be 'Column1'
                $Result.Column2 | Should -Be 'Column2'
                $Result.Column3 | Should -Be 'Column3'
            }
        }
        @{
            ImportCSVMock = @(
                [PSCustomObject]@{
                    Area = 'AreaTest'
                    ContributionArea = 'ContributionAreaTest'
                    SecondContributionArea = 'SecondContributionAreaTest'
                    Column1 = 'Column1'
                    Column2 = 'Column2'
                    Column3 = 'Column3'
                }
            )
            Assert = {
                $Result | Should -Not -BeNullOrEmpty
                $Result.Area | Should -Be 'AreaTest'
                $Result.ContributionArea | Should -Be 'ContributionAreaTest', 'SecondContributionAreaTest'
                $Result.Column1 | Should -Be 'Column1'
                $Result.Column2 | Should -Be 'Column2'
                $Result.Column3 | Should -Be 'Column3'
            }
        }
        @{
            ImportCSVMock = @(
                [PSCustomObject]@{
                    Area = 'AreaTest'
                    ContributionArea = 'ContributionAreaTest'
                    SecondContributionArea = 'SecondContributionAreaTest'
                    ThirdContributionArea = 'ThirdContributionAreaTest'
                    Column1 = 'Column1'
                    Column2 = 'Column2'
                    Column3 = 'Column3'
                }
            )
            Assert = {
                $Result | Should -Not -BeNullOrEmpty
                $Result.Area | Should -Be 'AreaTest'
                $Result.ContributionArea | Should -Be 'ContributionAreaTest', 'SecondContributionAreaTest', 'ThirdContributionAreaTest'
                $Result.Column1 | Should -Be 'Column1'
                $Result.Column2 | Should -Be 'Column2'
                $Result.Column3 | Should -Be 'Column3'
            }
        }
    )

    it "Paramaterized Testing: No errors should be thrown." -TestCases $TestCases {
        param($ImportCSVMock, $Assert)

        Mock -CommandName Import-CSV -MockWith  { return $ImportCSVMock }
        Mock -CommandName Get-HTMLFormStructure -MockWith {
            return ($ImportCSVMock | Select-Object * -ExcludeProperty Area, *Contribution* | Get-Member -Type NoteProperty | ForEach-Object {
                [PSCustomObject]@{
                    Name = $_.Name
                    Element = 'MOCK'
                    isRequird = $false
                    isSet = $false
                    Format = {}
                }
            })
        }
        
        $Result = New-CSVArguments -LiteralPath "Test"

        Should -Invoke "Import-CSV" -Exactly 1
        $Assert.Invoke()

    }

}