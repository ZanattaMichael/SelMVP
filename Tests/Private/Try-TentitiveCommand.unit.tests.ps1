
Describe "Testing Try-Tentitive Command" -Tag Unit {

    BeforeAll {
        $PSCommandPath.Replace(".ps1",".tests.ps1")
    }

    BeforeEach {
        $Script:ExternalVariable = "ExternalVariable"
        $Script:ExternalVariableCounter = 0
    }

    AfterEach {
        # Clear out our script variables after each test
       # Remove-Variable ExternalVariable
    }

    $testCases = @(

        @{
            Mock = { Mock Get-Random -MockWith { return 1 } }
            Try = { Get-Random }
            Catch = {}
            Assert = { $Result | Should -Be 1 }
        },
        @{
            Mock = { 
                Mock Get-Random -MockWith { throw "error" }
                Mock Write-Error -MockWith { return }
            }
            Try = { 
                Get-Random                
            }
            Catch = { 
                Write-Output 'TEST'
            }
            Assert = { 
                $Result | Should -be 'TEST'
                Should -Invoke "Write-Error" -Exactly 1
            }
        },
        @{
            Mock = {}
            Try = { $Script:ExternalVariable }
            Catch = {}
            Assert = { $Result | Should -Be 'ExternalVariable' }
        },
        @{
            Mock = { 
                Mock Get-Random -MockWith { throw "error" } 
                Mock Write-Error -MockWith { return }
            }
            Try = { $Script:ExternalVariable }
            Catch = {}
            Assert = { 
                Should -Invoke "Write-Error" -Exactly 0
                $Result | Should -Be 'ExternalVariable' 
            }
        },
        @{
            Mock = { 
                Mock Get-Random -MockWith { throw "error" } 
                Mock Write-Error -MockWith { return }
            }
            Try = { 
                if ($Script:ExternalVariableCounter -eq 0) { 
                    # Throw an Error using Get-Random
                    Get-Random                 
                }
                Write-Output "Success" 
            }
            Catch = {
                # Increment Counter
                $Script:ExternalVariableCounter++   
            }
            Assert = { 
                Should -Invoke "Write-Error" -Exactly 0
                $Result | Should -Be 'Success'
            }
        }
    )

    it "Standard Input - No Errors" -TestCases $testCases {
        param ( $Mock, $Try, $Catch, $ShouldBe )

        # Invoke the Mocks
        $Mock.Invoke()

        $params = @{
            Try = $Try
            Catch = $Catch
        }
        $Result = Try-TentitiveCommand @params

        $Assert.Invoke()

    }

}