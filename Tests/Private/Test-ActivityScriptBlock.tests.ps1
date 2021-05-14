Describe "Test-ActivityScriptBlock" -Tag Unit {

    BeforeAll {

        Remove-Variable -Name HTMLContributionAreas -ErrorAction SilentlyContinue
        New-Variable -Name HTMLContributionAreas -Scope Global -Option ReadOnly -Force -Value @(
            'TEST'
        )

    }

    $testCases = @(
        @{
            Fixture = {
                Area "TEST"
                ContributionArea "TEST"
                Value "TEST"
            }
            Act = {
                $Result = Test-ActivityScriptBlock $Fixture
            }
            Assert = {
                $Result.ParametrizedArea | Should -be $false
                $Result.ParametrizedContributionArea | Should -be $false
            }
        }

        @{
            Fixture = {
                Area "TEST"
                ContributionArea "TEST"
                Value "TEST"
                Value "TEST"
            }
            Act = {
                $Result = Test-ActivityScriptBlock $Fixture
            }
            Assert = {
                $Result.ParametrizedArea | Should -be $false
                $Result.ParametrizedContributionArea | Should -be $false
            }
        }

        @{
            Fixture = {
                param($Area)
                Area "TEST"
                ContributionArea "TEST"
                Value "TEST"
            }
            Act = {
                $Result = Test-ActivityScriptBlock $Fixture
            }
            Assert = {
                $Result.ParametrizedArea | Should -be $false
                $Result.ParametrizedContributionArea | Should -be $false
            }
        }

        @{
            Fixture = {
                param($ContributionArea)
                Area "TEST"
                ContributionArea "TEST"
                Value "TEST"
            }
            Act = {
                $Result = Test-ActivityScriptBlock $Fixture
            }
            Assert = {
                $Result.ParametrizedArea | Should -be $false
                $Result.ParametrizedContributionArea | Should -be $false
            }
        }

        @{
            Fixture = {
                param($Area, $ContributionArea)
                Area "TEST"
                ContributionArea "TEST"
                Value "TEST"
            }
            Act = {
                $Result = Test-ActivityScriptBlock $Fixture
            }
            Assert = {
                $Result.ParametrizedArea | Should -be $false
                $Result.ParametrizedContributionArea | Should -be $false
            }
        }

        @{
            Fixture = {
                param($Area, $ContributionArea)
                Value "TEST"
            }
            Act = {
                $Result = Test-ActivityScriptBlock $Fixture -ArgumentList @{ Area = 'Test'; 'ContributionArea' = 'Test'}
            }
            Assert = {
                $Result.ParametrizedArea | Should -be $true
                $Result.ParametrizedContributionArea | Should -be $true
            }
        }

        @{
            Fixture = {
                param($Area, $ContributionArea)
                Area "TEST"           
                Value "TEST"
            }
            Act = {
                $Result = Test-ActivityScriptBlock $Fixture -ArgumentList @{ 'ContributionArea' = 'Test'}
            }
            Assert = {
                $Result.ParametrizedArea | Should -be $false
                $Result.ParametrizedContributionArea | Should -be $true
            }
        }

        @{
            Fixture = {
                param($Area, $ContributionArea)
                ContributionArea "TEST"           
                Value "TEST"
            }
            Act = {
                $Result = Test-ActivityScriptBlock $Fixture -ArgumentList @{ 'Area' = 'Test'}
            }
            Assert = {
                $Result.ParametrizedArea | Should -be $true
                $Result.ParametrizedContributionArea | Should -be $false
            }
        }

        @{
            Fixture = {
                param($ContributionArea)
                ContributionArea "TEST"           
                Value "TEST"
            }
            Act = {
            }
            Assert = {
                { Test-ActivityScriptBlock $Fixture } | Should -Throw $LocalizedData.ErrorMissingMVPActivityArea
            }
        }  
        
        @{
            Fixture = {
                param($ContributionArea)
                Area
                Area
                ContributionArea "TEST"           
                Value "TEST"
            }
            Act = {
            }
            Assert = {
                { Test-ActivityScriptBlock $Fixture } | Should -Throw $LocalizedData.ErrorMissingMVPActivityAreaMultiple
            }
        } 
        
        @{
            Fixture = { 
                Area "TEST"       
                Value "TEST"
            }
            Act = {
            }
            Assert = {
                { Test-ActivityScriptBlock $Fixture } | Should -Throw $LocalizedData.ErrorMissingMVPActivityContributionArea
            }
        }           

        @{
            Fixture = { 
                Area "TEST"       
                Value "TEST"
            }
            Act = {
            }
            Assert = {
                { Test-ActivityScriptBlock $Fixture } | Should -Throw $LocalizedData.ErrorMissingMVPActivityContributionArea
            }
        }  

        @{
            Fixture = { 
                ContributionArea "TEST"
                Area "TEST"       
            }
            Act = {
            }
            Assert = {
                { Test-ActivityScriptBlock $Fixture } | Should -Throw $LocalizedData.ErrorMissingMVPActivityValue
            }
        }          

    )

    it "Testing Parameter Use Cases" -TestCases $testCases {
        param($Fixture, $Act, $Assert)

        Mock -CommandName Get-HTMLFormStructure -MockWith { 
            return @(
                @{
                    Name       = 'Test'
                    Element    = 'TestElement'
                    isRequired = $False
                }
            )
        }

        . $Act
        $Assert.Invoke()

    }

    it "Testing Value Parser: Missing Required Values will throw an error" {

        Mock -CommandName Get-HTMLFormStructure -MockWith { 
            return @(
                @{
                    Name       = 'Test'
                    Element    = 'TestElement'
                    isRequired = $true
                }
                @{
                    Name       = 'Mock'
                    Element    = 'MockElement'
                    isRequired = $false
                }
            )
        }

        { Test-ActivityScriptBlock -Fixture {
                Area 'Test'
                ContributionArea 'Test'
                Value 'Mocked-Value'
            } 
        } | Should -Throw ($LocalizedData.ErrorPreParseValueCheck -f 'Test')

    }

    it "Testing Value Parser: Misnamed Required Values will throw an error" {

        Mock -CommandName Get-HTMLFormStructure -MockWith { 
            return @(
                @{
                    Name       = 'Test'
                    Element    = 'TestElement'
                    isRequired = $true
                }
                @{
                    Name       = 'Mock'
                    Element    = 'MockElement'
                    isRequired = $false
                }
            )
        }

        { Test-ActivityScriptBlock -Fixture {
                Area 'Test'
                ContributionArea 'Test'
                Value 'Tests'
            } 
        } | Should -Throw ($LocalizedData.ErrorPreParseValueCheck -f 'Test')

    }

    it "Testing Value Parser: Required Values will throw an error, with non-required inputted" {

        Mock -CommandName Get-HTMLFormStructure -MockWith { 
            return @(
                @{
                    Name       = 'Test'
                    Element    = 'TestElement'
                    isRequired = $true
                }
                @{
                    Name       = 'Mock'
                    Element    = 'MockElement'
                    isRequired = $false
                }
            )
        }

        { Test-ActivityScriptBlock -Fixture {
                Area 'Test'
                ContributionArea 'Test'
                Value 'Mock'
            } 
        } | Should -Throw ($LocalizedData.ErrorPreParseValueCheck -f 'Test')

    }

    it "Testing Value Parser: Parsing Required HTML Element Name, should not throw an error" {

        Mock -CommandName Get-HTMLFormStructure -MockWith { 
            return @(
                @{
                    Name       = 'Test'
                    Element    = 'TestElement'
                    isRequired = $true
                }
                @{
                    Name       = 'Mock'
                    Element    = 'MockElement'
                    isRequired = $false
                }
            )
        }

        { Test-ActivityScriptBlock -Fixture {
                Area 'Test'
                ContributionArea 'Test'
                Value 'TestElement'
            } 
        } | Should -Not -Throw

    }

    it "Testing ContributionArea Parser: Invalid Contribution Area will throw an error (no parameter)" {

        Mock -CommandName Get-HTMLFormStructure -MockWith { 
            return @(
                @{
                    Name       = 'Test'
                    Element    = 'TestElement'
                    isRequired = $true
                }
                @{
                    Name       = 'Mock'
                    Element    = 'MockElement'
                    isRequired = $false
                }
            )
        }

        { Test-ActivityScriptBlock -Fixture {
                Area 'Test'
                ContributionArea 'Not-Valid'
                Value 'Test'
            } 
        } | Should -Throw ($LocalizedData.ErrorParseContributionAreaCheck)

    }

    it "Testing ContributionArea Parser: Invalid Contribution Area will throw an error (with parameter)" {

        Mock -CommandName Get-HTMLFormStructure -MockWith { 
            return @(
                @{
                    Name       = 'Test'
                    Element    = 'TestElement'
                    isRequired = $true
                }
                @{
                    Name       = 'Mock'
                    Element    = 'MockElement'
                    isRequired = $false
                }
            )
        }

        $params = @{
            ContributionArea = 'not-valid'
        }

        { Test-ActivityScriptBlock -Fixture {
                param($ContributionArea)
                Area 'Test'
                Value 'Test'
            } -ArgumentList $params
        } | Should -Throw ($LocalizedData.ErrorParseContributionAreaCheck)

    }

    it "Testing ContributionArea Parser: Valid Contribution Area will not throw an error (no parameter)" {

        Mock -CommandName Get-HTMLFormStructure -MockWith { 
            return @(
                @{
                    Name       = 'Test'
                    Element    = 'TestElement'
                    isRequired = $true
                }
                @{
                    Name       = 'Mock'
                    Element    = 'MockElement'
                    isRequired = $false
                }
            )
        }

        { Test-ActivityScriptBlock -Fixture {
                Area 'Test'
                ContributionArea 'test'
                Value 'Test'
            } 
        } | Should -Not -Throw

    }

    it "Testing ContributionArea Parser: Valid Contribution Area will not throw an error (with parameter)" {

        Mock -CommandName Get-HTMLFormStructure -MockWith { 
            return @(
                @{
                    Name       = 'Test'
                    Element    = 'TestElement'
                    isRequired = $true
                }
                @{
                    Name       = 'Mock'
                    Element    = 'MockElement'
                    isRequired = $false
                }
            )
        }

        $params = @{
            ContributionArea = 'test'
        }

        { Test-ActivityScriptBlock -Fixture {
                param($ContributionArea)
                Area 'Test'
                Value 'Test'
            } -ArgumentList $params
        } | Should -Not -Throw

    }

}