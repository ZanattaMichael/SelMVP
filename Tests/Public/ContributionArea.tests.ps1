
function Global:Get-ContributionAreasMockedData {

    return @(
        [PSCustomObject]@{
            Name = 'Test'
            Value = 'TestGUID'
        }
        [PSCustomObject]@{
            Name = 'Test2'
            Value = 'Test2GUID'
        }
        [PSCustomObject]@{
            Name = 'Test3'
            Value = 'Test3GUID'
        }
    )  

}

Function Global:Get-ContributionAreaGlobalMock {
    Mock -CommandName "Test-SEDriver" -MockWith {}
    Mock -CommandName "Test-CallStack" -MockWith {}
    Mock -CommandName "Start-Sleep" -MockWith {} 
    Mock -CommandName "Write-Error" -MockWith {}       
}

Describe "ContributionArea" {

    #
    # Test Cases

    $badContributionTypeTestCases = @(
        @{
            Values = 'Badata'
        }
        @{
            Values = 'Badata', 'Badata2'
        }
    )

    $standardExecutionTestCases = @(
        @{
            Values = 'Test'
            Assert = {
                Should -Invoke 'Find-SeElement' -Exactly 0
                Should -Invoke 'Invoke-SeClick' -Exactly 0
            }
        }
        @{
            Values = 'Test','Test2'
            Assert = {
                Should -Invoke 'Find-SeElement' -Exactly 0
                Should -Invoke 'Invoke-SeClick' -Exactly 0
            }
        }
        @{
            Values = 'Test','Test2','Test3'
            Assert = {
                Should -Invoke 'Find-SeElement' -Exactly 1
                Should -Invoke 'Invoke-SeClick' -Exactly 1
            }
        }
    )

    #
    # Before Each

    BeforeEach {
        $Script:ContributionAreas = [System.Collections.Generic.List[PSCustomObject]]::New()
    }

    #
    # Assertations

    it "Standard Execution, shouldn't thow any errors" -TestCases $standardExecutionTestCases {
        param($Values, $Assert)

        Global:Get-ContributionAreaGlobalMock
        Mock -CommandName "Get-ContributionAreas" -MockWith { Get-ContributionAreasMockedData }
        Mock -CommandName "Select-DropDown" -MockWith {}
        Mock -CommandName "Wait-ForJavascript" -MockWith {}
        Mock -CommandName "Start-Sleep" -MockWith {}
        Mock -CommandName "Find-SeElement" -MockWith { return [PSCustomObject]@{ Data = "TEST" }}
        Mock -CommandName "Invoke-SeClick" -MockWith {} -RemoveParameterType 'Element'

        { ContributionArea $Values } | Should -not -Throw
        
        Should -Invoke "Test-SEDriver" -Exactly 1
        Should -Invoke "Test-CallStack" -Exactly 1
        Should -Invoke "Get-ContributionAreas" -Times 1
        Should -Invoke "Wait-ForJavascript" -Times 1
        Should -Invoke "Start-Sleep" -Exactly 0

        # Invoke any additional Asset's defined in the params
        $Assert.Invoke()
        
    }

    it "Parsing a known ContributionArea Type, however Get-ContributionAreas throws a terminating error" {

        Global:Get-ContributionAreaGlobalMock
        Mock -CommandName "Get-ContributionAreas" -MockWith { Throw "Test" }
        Mock -CommandName "Wait-ForJavascript" -MockWith {}
        Mock -CommandName "Select-DropDown" -MockWith {}
        Mock -CommandName "Get-HTMLFormStructure" -MockWith {}
        
        { ContributionArea 'Test' } | Should -Throw "Test"
        
        Should -Invoke "Get-HTMLFormStructure" -Exactly 0
        
    }
  
    it "Parsing a bad ContributionArea Type that dosen't exist, will throw a terminating error" -TestCases $badContributionTypeTestCases {
        param($values)

        Global:Get-ContributionAreaGlobalMock
        Mock -CommandName "Get-ContributionAreas" -MockWith { Get-ContributionAreasMockedData }
        Mock -CommandName "Wait-ForJavascript" -MockWith {}
        Mock -CommandName "Select-DropDown" -MockWith {}
        Mock -CommandName "Get-HTMLFormStructure" -MockWith {}
        
        { ContributionArea $values } | Should -Throw ($LocalizedData.ErrorMissingSelectedValue -f "*")
        
        Should -Invoke "Get-HTMLFormStructure" -Exactly 0
        
    }
   
    it "Parsing a bad ContributionArea type that returned multiple values" {

        Global:Get-ContributionAreaGlobalMock
        Mock -CommandName "Get-ContributionAreas" -MockWith { 
            return @(
                [PSCustomObject]@{
                    Name = 'Test'
                    Value = 'TestGUID'
                }
                [PSCustomObject]@{
                    Name = 'Test'
                    Value = 'TestGUID'
                }
            )
        }

        Mock -CommandName "Wait-ForJavascript" -MockWith {}
        Mock -CommandName "Select-DropDown" -MockWith {}
        Mock -CommandName "Write-Error" -MockWith {}
        
        { ContributionArea 'Test' } | Should -Throw ($LocalizedData.ErrorTooManySelectedValue -f "*", "2")
        
        Should -Invoke "Select-DropDown" -Exactly 0
        
    }

    it "Standard Execution however there is a problem with selecting the dropdown box" {

        Global:Get-ContributionAreaGlobalMock
        Mock -CommandName "Get-ContributionAreas" -MockWith { Get-ContributionAreasMockedData }
        Mock -CommandName Select-DropDown -ParameterFilter { $selectedValue -eq 'TestGUID'} -MockWith {
            Throw "Test Error"
        }
        Mock -CommandName Select-DropDown -MockWith {} -ParameterFilter { $selectedValue -eq $LocalizedData.ElementValueChefPuppetInDataCenter }
        Mock -CommandName Write-Error -MockWith {}
        Mock -CommandName Wait-ForJavascript -MockWith {}

        { ContributionArea 'Test' } | Should -Not -Throw

        Should -Invoke "Wait-ForJavascript" -Exactly 0
        Should -Invoke "Select-DropDown" -Times 2
        Should -Invoke "Write-Error" -Times 1
        Should -Invoke "Start-Sleep" -Times 1
        
    }

    it "Standard Execution however Wait-ForJavascript fails because the form is bad" -testCases $standardExecutionTestCases {
        param($Values, $Assert)

        Global:Get-ContributionAreaGlobalMock
        Mock -CommandName "Get-ContributionAreas" -MockWith { Get-ContributionAreasMockedData }
        Mock -CommandName "Select-DropDown" -MockWith {}
        Mock -CommandName "Wait-ForJavascript" -MockWith { Throw "Test Error" }
        Mock -CommandName "Find-SeElement" -MockWith { return [PSCustomObject]@{ Data = "TEST" }}
        Mock -CommandName "Invoke-SeClick" -MockWith {} -RemoveParameterType 'Element'

        { ContributionArea $Values } | Should -not -Throw
        
        Should -Invoke "Test-SEDriver" -Exactly 1
        Should -Invoke "Test-CallStack" -Exactly 1
        Should -Invoke "Get-ContributionAreas" -Times 1
        Should -Invoke "Wait-ForJavascript" -Times 1
        Should -Invoke "Start-Sleep" -Times 1

        # Invoke any additional Asset's defined in the params
        $Assert.Invoke()
        
    }

}