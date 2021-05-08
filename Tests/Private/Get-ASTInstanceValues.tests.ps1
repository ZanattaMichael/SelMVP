Describe 'Get-ASTInstanceValues' {

    $params = @(
        @{
            Fixture = { 
                MockCmdlet 'Mock-Value' 
                AnotherMockCmdlet 'Mock-Value2'
                AnotherMockCmdlet -Mock 'Mock-Value3'
            }
            Expect =  'Mock-Value3','Mock-Value','Mock-Value2'
            ParameterName = 'Mock'
        }        
        @{
            Fixture = { MockCmdlet 'Mock-Value' }
            Expect = 'Mock-Value'
        }
        @{
            Fixture = { MockCmdlet -Name 'Mock-Value' }
            Expect = 'Mock-Value'
            ParameterName = 'Name'
        }
        @{
            Fixture = { 
                MockCmdlet -Name 'Mock-Value' 
                AnotherMockCmdlet 'Mock-Value2'
            }
            Expect = 'Mock-Value','Mock-Value2'
            ParameterName = 'Name'
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
        }                            
    )

    it "Should return the mock value when parsed a ScriptBlock" -TestCases $params {
        param($Fixture, $Expect, $ParameterName)

        # Return a list of Commands
        $CommandAst = $Fixture.ast.FindAll({$args[0] -is [System.Management.Automation.Language.CommandAst]}, $true)

        $params = @{
            InstanceValues = $CommandAst            
        }
        if ($ParameterName) {$params.ParameterName = $ParameterName}

        $Result = Get-ASTInstanceValues @params
        $Result | Should -be $Expect

    }

}