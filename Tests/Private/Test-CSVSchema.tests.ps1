Describe "Test-CSVSchema" {

    #
    # Params
    #

    $contributionAreaParams = @(
        # ContributionArea and Area are Present
        # Should not fail.
        @{
            CSVMock = { 
                @(
                    [PSCustomObject]@{
                        Area = "Test"
                        ContributionArea = "Test"
                    },
                    [PSCustomObject]@{
                        Area = "Test"
                        ContributionArea = "Test"
                    }
                ) 
            }

            Assert = {
                { Test-CSVSchema -LiteralPath "TEST" } | Should -not -Throw
                Should -Invoke "Import-CSV" -Exactly 1
                Should -Invoke "Test-Path" -Exactly 1
                Should -Invoke "Get-HTMLFormStructure" -Exactly 1
            }
        }
        @{
            CSVMock = { 
                @(
                    [PSCustomObject]@{
                        Area = "Test"
                    },
                    [PSCustomObject]@{
                        Area = "Test"
                        ContributionArea = "Test"
                    }
                ) 
            }

            Assert = {
                { Test-CSVSchema -LiteralPath "TEST" } | Should -Throw ($LocalizedData.ErrorTestCSVSchemaMissingColumns -f "*")
                Should -Invoke "Import-CSV" -Exactly 1
                Should -Invoke "Test-Path" -Exactly 1
                Should -Invoke "Get-HTMLFormStructure" -Exactly 0
            }
        }
        @{
            CSVMock = { 
                @(
                    [PSCustomObject]@{
                        Area = "Test"
                    },
                    [PSCustomObject]@{
                        Area = "Test"
                    }
                ) 
            }

            Assert = {
                { Test-CSVSchema -LiteralPath "TEST" } | Should -Throw ($LocalizedData.ErrorTestCSVSchemaMissingColumns -f "*")
                Should -Invoke "Import-CSV" -Exactly 1
                Should -Invoke "Test-Path" -Exactly 1
                Should -Invoke "Get-HTMLFormStructure" -Exactly 0
            }
        }
        @{
            CSVMock = { 
                @(
                    [PSCustomObject]@{
                        ContributionArea = "Test"
                    },
                    [PSCustomObject]@{
                        Area = "Test"
                    }
                ) 
            }

            Assert = {
                { Test-CSVSchema -LiteralPath "TEST" } | Should -Throw ($LocalizedData.ErrorTestCSVSchemaMissingColumns -f "*")
                Should -Invoke "Import-CSV" -Exactly 1
                Should -Invoke "Test-Path" -Exactly 1
                Should -Invoke "Get-HTMLFormStructure" -Exactly 0
            }
        }

    )

    #
    # Tests
    #

    it "When called with a bad file path, will throw an error" {

        Mock -CommandName "Test-Path" -MockWith { return $false }
        
        { Test-CSVSchema -LiteralPath "MOCK" } | Should -Throw ($LocalizedData.ErrorTestCSVSchemaMissingCSVFile -f "*")

    }

    it "When a bad CSV file is loaded, will throw an error" {

        Mock -CommandName "Test-Path" -MockWith { return $true }
        Mock -CommandName "Import-CSV" -MockWith { Throw "MOCK ERROR" }
        
        { Test-CSVSchema -LiteralPath "MOCK" } | Should -Throw ($LocalizedData.ErrorTestCSVSchemaImportCSVFile -f "MOCK ERROR")

    }
    
    it "When a good CSV file is loaded, however the Areas are all different. Will throw an error" {

        Mock -CommandName "Test-Path" -MockWith { return $true }
        Mock -CommandName "Import-CSV" -MockWith { 
            @(
                [PSCustomObject]@{
                    Area = "Test"
                },
                [PSCustomObject]@{
                    Area = "Different"
                }
            ) 
        }

        { Test-CSVSchema -LiteralPath "MOCK" | Should -Throw ($LocalizedData.ErrorTestCSVSchemaDifferentAreaColumn -f "*")}

    }

    it "When the same contribution area value is defined will fail" {

        Mock -CommandName "Test-Path" -MockWith { return $true }
        Mock -CommandName "Get-HTMLFormStructure" -MockWith { "TEST" }
        Mock -CommandName "Import-CSV" -MockWith { return (
            @(
                [PSCustomObject]@{
                    Area = "Same"
                    ContributionArea = "Same"
                    SecondContributionArea = "Same"
                    ThrirdContributionArea = "Same"
                },
                [PSCustomObject]@{
                    Area = "Same"
                    ContributionArea = "Different"
                    SecondContributionArea = "SomthingElse"
                    ThrirdContributionArea = "AnotherItem"                    
                }
            ))
        }

        { Test-CSVSchema -LiteralPath "TEST" } | Should -Throw ($LocalizedData.ErrorTestCSVSchemaDuplicateContributionArea -f "*")
        Should -Invoke "Import-CSV" -Exactly 1
        Should -Invoke "Test-Path" -Exactly 1
        Should -Invoke "Get-HTMLFormStructure" -Exactly 1

    }

    it "Parmeterized Execution: Testing Area/ContributionArea" -TestCases $contributionAreaParams -skip {
        param ($CSVMock, $Assert)

        Mock -CommandName "Test-Path" -MockWith { return $true }
        Mock -CommandName "Import-CSV" -MockWith $CSVMock
        Mock -CommandName "Get-HTMLFormStructure" -MockWith {}

        $Assert.Invoke()

    }

}