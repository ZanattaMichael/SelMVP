Describe "Get-HTMLFormStructure Mocked" -Tag Unit {

    BeforeAll {
        # Define the HTMLFormStructure

        # Take a Backup of the HTMLFormStructure 
        $Global:BackupHTMLFormStructure = $Global:HTMLFormStructure.Clone()
        try { Remove-Variable HTMLFormStructure -Force -Scope Global -ErrorAction Stop} catch {}

        $Global:HTMLFormStructure = @(
                                        @{
                                            Name       = "Default"
                                            Properties = @(
                                                @{
                                                    Name       = 'Date'
                                                    Element    = $LocalizedDataHTMLElements.Date
                                                    isRequired = $true
                                                }
                                                @{
                                                    Name       = 'Title'
                                                    Element    = $LocalizedDataHTMLElements.Title
                                                    isRequired = $true
                                                }
                                                @{
                                                    Name       = 'URL'
                                                    Element    = $LocalizedDataHTMLElements.URL
                                                    isRequired = $false
                                                }
                                                @{
                                                    Name    = 'Description'
                                                    Element = $LocalizedDataHTMLElements.Description
                                                }            
                                            )
                                        }
                                        @{
                                            Name       = "Test"
                                            Properties = @(
                                                @{
                                                    Name       = 'TestData'
                                                    Element    = $LocalizedDataHTMLElements.AnnualQuantity
                                                    isRequired = $true
                                                },
                                                @{
                                                    Name    = 'MoreTestData'
                                                    Element = $LocalizedDataHTMLElements.AnnualReach
                                                }           
                                            )
                                        }
                                        @{
                                            Name       = "SecondTest"
                                            Properties = @(
                                                @{
                                                    Name       = 'TestData'
                                                    Element    = $LocalizedDataHTMLElements.AnnualQuantity
                                                    isRequired = $true
                                                    Format     = { Write-Host "A" }
                                                },
                                                @{
                                                    Name    = 'MoreTestData'
                                                    Element = $LocalizedDataHTMLElements.AnnualReach
                                                    Format  = { Write-Host "A" }
                                                }           
                                            )
                                        } 
                                        @{
                                            Name       = "ThirdTest"
                                            Properties = @(
                                                @{
                                                    Name       = 'TestData'
                                                    Element    = $LocalizedDataHTMLElements.AnnualQuantity
                                                    isRequired = $true
                                                    Format     = "TEST"
                                                }         
                                            )
                                        }                                                                                 
                                    )
    }

    AfterAll {
        # Restore from the Copy of the HTML Form Structure
        $Global:HTMLFormStructure = $Global:BackupHTMLFormStructure.Clone()
    }

    it "will throw an error if the -name 'default' is used" {

        Mock -CommandName Write-Verbose -MockWith {}
        Mock -CommandName Write-Debug -MockWith {}

        {Get-HTMLFormStructure -Name "Default"} | Should -Throw $LocalizedData.ErrorHTMLFormStructureDefaultParameter
    }

    it "Standard Execution where an object is returned containing HTML elements" {

        Mock -CommandName Write-Verbose -MockWith {}
        Mock -CommandName Write-Debug -MockWith {}
        
        $Result = Get-HTMLFormStructure -Name "Test"
        
        $Result | Should -Not -BeNullOrEmpty
        $Result.Name | Should -Not -BeNullOrEmpty
        $Result.Element | Should -Not -BeNullOrEmpty
        $Result.isRequired | Should -Not -BeNullOrEmpty
        $Result.isSet | Should -Not -BeNullOrEmpty
        $Result.Format | Should -Not -BeNullOrEmpty               

    }

}

Describe "Get-HTMLFormStructure Actual" -Tag Unit {

    $TestCases = $Global:HTMLFormStructure.Name | Where-Object { $_ -ne 'default'} | ForEach-Object { @{ Name = $_ }}

    it "Standard Execution where an object is returned containing HTML elements" -TestCases $TestCases {
        param($Name)

        Mock -CommandName Write-Verbose -MockWith {}
        Mock -CommandName Write-Debug -MockWith {}
        
        $Result = Get-HTMLFormStructure -Name $Name
        
        $Result | Should -Not -BeNullOrEmpty
        $Result.Name | Should -Not -BeNullOrEmpty
        $Result.Element | Should -Not -BeNullOrEmpty
        $Result.isRequired | Should -Not -BeNullOrEmpty
        $Result.isSet | Should -Not -BeNullOrEmpty
        $Result.Format | Should -Not -BeNullOrEmpty               

    }

}