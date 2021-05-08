Describe 'Get-ASTInstanceValues' {

    $params = @(
        @{
            Fixture = { MockCmdlet 'Mock-Value' }
            Expect = 'Mock-Value'
        }
        @{
            Fixture = { MockCmdlet -Name 'Mock-Value' }
            Expect = 'Mock-Value'
        }
        @{
            Fixture = { 
                MockCmdlet -Name 'Mock-Value' 
                AnotherMockCmdlet 'Mock-Value2'
            }
            Expect = 'Mock-Value','Mock-Value2'
        }
        @{
            Fixture = { 
                MockCmdlet 'Mock-Value' 
                AnotherMockCmdlet 'Mock-Value2'
            }
            Expect = 'Mock-Value','Mock-Value2'
        }
        @{
            Fixture = { 
                MockCmdlet 'Mock-Value' 
                AnotherMockCmdlet 'Mock-Value2'
                AnotherMockCmdlet 'Mock-Value3'
            }
            Expect = 'Mock-Value','Mock-Value2', 'Mock-Value3'
        },
        @{
            Fixture = { 
                MockCmdlet 'Mock-Value' 
                AnotherMockCmdlet 'Mock-Value2'
                AnotherMockCmdlet -Mock 'Mock-Value3'
            }
            Expect = 'Mock-Value','Mock-Value2', 'Mock-Value3'
        }                             
    )

    it "Should return the mock value when parsed a scriptblock" -TestCases $params {
        param($Fixture, $Expect)

        # Return a list of Commands
        $CommandAst = $Fixture.ast.FindAll({$args[0] -is [System.Management.Automation.Language.CommandAst]}, $true)

        $Result = Get-ASTInstanceValues -InstanceValues $CommandAst
        $Result | Should -be $Expect

    }

}