Describe "Test-CSVSchema" {

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
        Mock -CommandName "Import-CSV" -MockWith { @(
            [PSCustomObject]@{
                Area = "Test1"
            },
            [PSCustomObject]@{
                Area = "Test2"
            }
        ) }

        { Test-CSVSchema -LiteralPath "MOCK" | Should -Throw ($LocalizedData.ErrorTestCSVSchemaDifferentAreaColumn -f "*")}

    }
}