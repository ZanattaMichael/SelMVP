Describe "ConnectTo-MVPPortal" {

    AfterEach {
        Remove-Variable -Name MVPDriver -Force -Scope Global
    }

    BeforeEach {
        $Global:MVPDriver = ""
    }

    $standardExecutionTestCases = @(
        @{
            Assert = {
                Should -Invoke "Start-SeFirefox" -Exactly 1
                Should -Invoke "Start-SeChrome" -Exactly 0
                Should -Invoke "Start-SeNewEdge" -Exactly 0
            }
            DriverType = "Firefox"            
        }
        @{
            Assert = {
                Should -Invoke "Start-SeFirefox" -Exactly 0
                Should -Invoke "Start-SeChrome" -Exactly 1
                Should -Invoke "Start-SeNewEdge" -Exactly 0
            }
            DriverType = "Chrome"     
        }
        @{
            Assert = {
                Should -Invoke "Start-SeFirefox" -Exactly 0
                Should -Invoke "Start-SeChrome" -Exactly 0
                Should -Invoke "Start-SeNewEdge" -Exactly 1
            }
            DriverType = "Edge"     
        }        
    )

    $standardExecutionThrow = @(
        @{ DriverType = "Firefox" }
        @{ DriverType = "Chrome" }
        @{ DriverType = "Edge" }
        @{ DriverType = "OldEdge" }
    )

    it "Standard Execution (with immediate redirection)" -TestCases $standardExecutionTestCases {
        param($Assert, $DriverType)
        Mock -CommandName 'Start-SeFirefox' -MockWith { return [PSCustomObject]@{ Url = "Mocked" } }
        Mock -CommandName 'Start-SeChrome' -MockWith { return [PSCustomObject]@{ Url = "Mocked" }  }
        Mock -CommandName 'Start-SeEdge' -MockWith { return [PSCustomObject]@{ Url = "Mocked" } }
        Mock -CommandName 'Start-SeNewEdge' -MockWith { return [PSCustomObject]@{ Url = "Mocked" } }
        Mock -CommandName 'Write-Verbose' -MockWith { return [PSCustomObject]@{ Url = "Mocked" } }
        Mock -CommandName 'Start-Sleep' -MockWith { return [PSCustomObject]@{ Url = "Mocked" } }
        Mock -CommandName 'Test-MVPDriverisMicrosoftLogin' -ParameterFilter { $waitUntilLoaded -eq $true} -MockWith { $true }
        Mock -CommandName 'Test-MVPDriverisMicrosoftLogin' -ParameterFilter { $isCompleted -eq $true} -MockWith { $false }

        $result = ConnectTo-MVPPortal -URLPath "https://test.com" -DriverType $DriverType

        $Assert.Invoke()
        $Global:MVPDriver | Should -Not -BeNullOrEmpty

    }

    it "Standard Execution, however an error was raised." -TestCases $standardExecutionThrow {
        param($DriverType)

        Mock -CommandName 'Start-SeFirefox' -MockWith { Throw "Test" }
        Mock -CommandName 'Start-SeChrome' -MockWith { Throw "Test" }
        Mock -CommandName 'Start-SeEdge' -MockWith { Throw "Test" }
        Mock -CommandName 'Start-SeNewEdge' -MockWith { Throw "Test" }
        Mock -CommandName 'Write-Verbose' -MockWith {}
        Mock -CommandName 'Start-Sleep' -MockWith {}
        Mock -CommandName 'Test-MVPDriverisMicrosoftLogin' -ParameterFilter { $waitUntilLoaded -eq $true} -MockWith { $true }
        Mock -CommandName 'Test-MVPDriverisMicrosoftLogin' -ParameterFilter { $isCompleted -eq $true} -MockWith { $false }


        { ConnectTo-MVPPortal -URLPath "https://test.com" -DriverType $DriverType } | 
            Should -Throw ($LocalizedData.ErrorConnectToMVPPortal -f "*")

        $Global:MVPDriver | Should -BeNullOrEmpty

    }

}