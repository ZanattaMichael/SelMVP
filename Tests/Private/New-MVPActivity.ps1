Describe "New-MVPActivity" -Tag Unit {

    #
    # Standard Execution
    #

    it "Should Auto Execute 'Area' if included in the param() block" {

        Mock -CommandName 'Test-ActivityScriptBlock' -MockWith {
            return ([PSCustomObject]@{
                ParametrizedArea = $true
                ParametrizedContributionArea = $false
            })
        }
        Mock -CommandName 'Test-SEDriver' -MockWith {}
        Mock -CommandName 'Wait-ForMVPElement' -MockWith {}
        Mock -CommandName 'Invoke-MVPActivity' -MockWith {}

        Mock -CommandName 'Area' -MockWith {}
        Mock -CommandName 'Value' -MockWith {}
        Mock -CommandName 'ContributionArea' -MockWith {}

        Mock -CommandName 'Save-MVPActivity' -MockWith {}
        Mock -CommandName 'Stop-MVPActivity' -MockWith {}
        Mock -CommandName 'Wait-ForActivityWindow' -MockWith {}

        $params = @{
            Fixture = { param($Area); Value 'TEST' 'TEST' }
            ArgumentList = @{ Area = "TEST" }
        }

        $null = New-MVPActivity @params

        Should -Invoke 'Test-ActivityScriptBlock' -Exactly 1
        Should -Invoke 'Test-SEDriver' -Exactly 1
        Should -Invoke 'Wait-ForMVPElement' -Exactly 1
        Should -Invoke 'Invoke-MVPActivity' -Exactly 1
        
        Should -Invoke 'Wait-ForActivityWindow' -Exactly 1
        Should -Invoke 'Area' -Exactly 1
        Should -Invoke 'ContributionArea' -Exactly 0
        Should -Invoke 'Stop-MVPActivity' -Exactly 0
        Should -Invoke 'Save-MVPActivity' -Exactly 1
        
    }

    it "Should Auto Execute 'ContributionArea' if included in the param() block" {

        Mock -CommandName 'Test-ActivityScriptBlock' -MockWith {
            return ([PSCustomObject]@{
                ParametrizedArea = $false
                ParametrizedContributionArea = $true
            })
        }
        Mock -CommandName 'Test-SEDriver' -MockWith {}
        Mock -CommandName 'Wait-ForMVPElement' -MockWith {}
        Mock -CommandName 'Invoke-MVPActivity' -MockWith {}

        Mock -CommandName 'Area' -MockWith {}
        Mock -CommandName 'Value' -MockWith {}
        Mock -CommandName 'ContributionArea' -MockWith {}

        Mock -CommandName 'Save-MVPActivity' -MockWith {}
        Mock -CommandName 'Stop-MVPActivity' -MockWith {}
        Mock -CommandName 'Wait-ForActivityWindow' -MockWith {}

        $params = @{
            Fixture = { param($ContributionArea); Value 'TEST' 'TEST' }
            ArgumentList = @{ ContributionArea = "TEST" }
        }

        $null = New-MVPActivity @params

        Should -Invoke 'Test-ActivityScriptBlock' -Exactly 1
        Should -Invoke 'Test-SEDriver' -Exactly 1
        Should -Invoke 'Wait-ForMVPElement' -Exactly 1
        Should -Invoke 'Invoke-MVPActivity' -Exactly 1
        
        Should -Invoke 'Wait-ForActivityWindow' -Exactly 1
        Should -Invoke 'Area' -Exactly 0
        Should -Invoke 'ContributionArea' -Exactly 1
        Should -Invoke 'Stop-MVPActivity' -Exactly 0
        Should -Invoke 'Save-MVPActivity' -Exactly 1
        
    }

    it "Should Auto Execute 'Visibility' if included in the param() block" {

        Mock -CommandName 'Test-ActivityScriptBlock' -MockWith {
            return ([PSCustomObject]@{
                ParametrizedArea = $false
                ParametrizedContributionArea = $false
                ParametrizedVisibility = $true
            })
        }
        Mock -CommandName 'Test-SEDriver' -MockWith {}
        Mock -CommandName 'Wait-ForMVPElement' -MockWith {}
        Mock -CommandName 'Invoke-MVPActivity' -MockWith {}

        Mock -CommandName 'Area' -MockWith {}
        Mock -CommandName 'Value' -MockWith {}
        Mock -CommandName 'ContributionArea' -MockWith {}
        Mock -CommandName 'Visibility' -MockWith {}

        Mock -CommandName 'Save-MVPActivity' -MockWith {}
        Mock -CommandName 'Stop-MVPActivity' -MockWith {}
        Mock -CommandName 'Wait-ForActivityWindow' -MockWith {}

        $params = @{
            Fixture = { param($Visibility); Value 'TEST' 'TEST' }
            ArgumentList = @{ Visibility = "Everyone" }
        }

        $null = New-MVPActivity @params

        Should -Invoke 'Test-ActivityScriptBlock' -Exactly 1
        Should -Invoke 'Test-SEDriver' -Exactly 1
        Should -Invoke 'Wait-ForMVPElement' -Exactly 1
        Should -Invoke 'Invoke-MVPActivity' -Exactly 1
        
        Should -Invoke 'Wait-ForActivityWindow' -Exactly 1
        Should -Invoke 'Visibility' -Exactly 1
        Should -Invoke 'ContributionArea' -Exactly 0
        Should -Invoke 'Stop-MVPActivity' -Exactly 0
        Should -Invoke 'Save-MVPActivity' -Exactly 1
        
    }

    it "Should Auto Execute 'ContributionArea' and 'Area' if included in the param() block" {

        Mock -CommandName 'Test-ActivityScriptBlock' -MockWith {
            return ([PSCustomObject]@{
                ParametrizedArea = $true
                ParametrizedContributionArea = $true
            })
        }
        Mock -CommandName 'Test-SEDriver' -MockWith {}
        Mock -CommandName 'Wait-ForMVPElement' -MockWith {}
        Mock -CommandName 'Invoke-MVPActivity' -MockWith {}

        Mock -CommandName 'Area' -MockWith {}
        Mock -CommandName 'Value' -MockWith {}
        Mock -CommandName 'ContributionArea' -MockWith {}

        Mock -CommandName 'Save-MVPActivity' -MockWith {}
        Mock -CommandName 'Stop-MVPActivity' -MockWith {}
        Mock -CommandName 'Wait-ForActivityWindow' -MockWith {}

        $params = @{
            Fixture = { param($ContributionArea, $Area); Value 'TEST' 'TEST' }
            ArgumentList = @{ Area = "TEST"; ContributionArea = "TEST" }
        }

        $null = New-MVPActivity @params

        Should -Invoke 'Test-ActivityScriptBlock' -Exactly 1
        Should -Invoke 'Test-SEDriver' -Exactly 1
        Should -Invoke 'Wait-ForMVPElement' -Exactly 1
        Should -Invoke 'Invoke-MVPActivity' -Exactly 1
        
        Should -Invoke 'Wait-ForActivityWindow' -Exactly 1
        Should -Invoke 'Area' -Exactly 1
        Should -Invoke 'ContributionArea' -Exactly 1
        Should -Invoke 'Stop-MVPActivity' -Exactly 0
        Should -Invoke 'Save-MVPActivity' -Exactly 1
        
    }

    it "Should execute a standard fixture without any errors" {

        Mock -CommandName 'Test-ActivityScriptBlock' -MockWith {
            return ([PSCustomObject]@{
                ParametrizedArea = $false
                ParametrizedContributionArea = $false
            })
        }
        Mock -CommandName 'Test-SEDriver' -MockWith {}
        Mock -CommandName 'Wait-ForMVPElement' -MockWith {}
        Mock -CommandName 'Invoke-MVPActivity' -MockWith {}

        Mock -CommandName 'Area' -MockWith {}
        Mock -CommandName 'Value' -MockWith {}
        Mock -CommandName 'ContributionArea' -MockWith {}

        Mock -CommandName 'Save-MVPActivity' -MockWith {}
        Mock -CommandName 'Stop-MVPActivity' -MockWith {}
        Mock -CommandName 'Wait-ForActivityWindow' -MockWith {}

        $params = @{
            Fixture = {
                Area 'TEST'
                ContributionArea 'TEST'
                Value 'TEST' 'TEST'
            }
            ArgumentList = $null
        }

        $null = New-MVPActivity @params

        Should -Invoke 'Test-ActivityScriptBlock' -Exactly 1
        Should -Invoke 'Test-SEDriver' -Exactly 1
        Should -Invoke 'Wait-ForMVPElement' -Exactly 1
        Should -Invoke 'Invoke-MVPActivity' -Exactly 1
        
        Should -Invoke 'Wait-ForActivityWindow' -Exactly 1
        Should -Invoke 'Area' -Exactly 1
        Should -Invoke 'Value' -Exactly 1
        Should -Invoke 'ContributionArea' -Exactly 1
        Should -Invoke 'Save-MVPActivity' -Exactly 1

        Should -Invoke 'Stop-MVPActivity' -Exactly 0
        
    }

    it "Should execute a single parameterized fixture without any errors" {

        Mock -CommandName 'Test-ActivityScriptBlock' -MockWith {
            return ([PSCustomObject]@{
                ParametrizedArea = $false
                ParametrizedContributionArea = $false
            })
        }
        Mock -CommandName 'Test-SEDriver' -MockWith {}
        Mock -CommandName 'Wait-ForMVPElement' -MockWith {}
        Mock -CommandName 'Invoke-MVPActivity' -MockWith {}

        Mock -CommandName 'Area' -MockWith {}
        Mock -CommandName 'Value' -MockWith {}
        Mock -CommandName 'ContributionArea' -MockWith {}

        Mock -CommandName 'Save-MVPActivity' -MockWith {}
        Mock -CommandName 'Stop-MVPActivity' -MockWith {}
        Mock -CommandName 'Wait-ForActivityWindow' -MockWith {}

        $params = @{
            Fixture = {
                param($var)
                Area 'TEST'
                ContributionArea 'TEST'
                Value 'TEST' 'TEST'
            }
            ArgumentList = @{
                var = 1
            }
        }

        $null = New-MVPActivity @params

        Should -Invoke 'Test-ActivityScriptBlock' -Exactly 1
        Should -Invoke 'Test-SEDriver' -Exactly 1
        Should -Invoke 'Wait-ForMVPElement' -Exactly 1
        Should -Invoke 'Invoke-MVPActivity' -Exactly 1
        
        Should -Invoke 'Wait-ForActivityWindow' -Exactly 1
        Should -Invoke 'Area' -Exactly 1
        Should -Invoke 'Value' -Exactly 1
        Should -Invoke 'ContributionArea' -Exactly 1
        Should -Invoke 'Save-MVPActivity' -Exactly 1

        Should -Invoke 'Stop-MVPActivity' -Exactly 0
        
    }

    #
    # Non Standard Execution
    #

    $validationFailureTestCases = @(
        @{
            MockScript = {
                Mock -CommandName 'Test-ActivityScriptBlock' -MockWith { Throw "ERROR" }
                Mock -CommandName 'Test-SEDriver' -MockWith {}
                Mock -CommandName 'Wait-ForMVPElement' -MockWith {}
                Mock -CommandName 'Invoke-MVPActivity' -MockWith {}                
            }
        }
        @{
            MockScript = {
                Mock -CommandName 'Test-ActivityScriptBlock' -MockWith {}
                Mock -CommandName 'Test-SEDriver' -MockWith { Throw "ERROR" }
                Mock -CommandName 'Wait-ForMVPElement' -MockWith {}
                Mock -CommandName 'Invoke-MVPActivity' -MockWith {}                
            }
        }
        @{
            MockScript = {
                Mock -CommandName 'Test-ActivityScriptBlock' -MockWith {}
                Mock -CommandName 'Test-SEDriver' -MockWith {}
                Mock -CommandName 'Wait-ForMVPElement' -MockWith { Throw "ERROR" }
                Mock -CommandName 'Invoke-MVPActivity' -MockWith {}                
            }
        }
        @{
            MockScript = {
                Mock -CommandName 'Test-ActivityScriptBlock' -MockWith {}
                Mock -CommandName 'Test-SEDriver' -MockWith {}
                Mock -CommandName 'Wait-ForMVPElement' -MockWith {}
                Mock -CommandName 'Invoke-MVPActivity' -MockWith { Throw "ERROR" }                
            }
        }        
    )

    it "Should throw an error when the validation fails" -TestCases $validationFailureTestCases {
        param($MockScript) 

        $MockScript.Invoke()

        Mock -CommandName 'Save-MVPActivity' -MockWith {}
        Mock -CommandName 'Stop-MVPActivity' -MockWith {}
        Mock -CommandName 'Wait-ForActivityWindow' -MockWith {}
        Mock -CommandName 'Write-Error' -MockWith {}

        $params = @{
            Fixture = { param($Area); Value 'TEST' 'TEST' }
            ArgumentList = @{ Area = "TEST" }
        }

        $null = New-MVPActivity @params
        
        Should -Invoke 'Wait-ForActivityWindow' -Exactly 1
        #Should -Invoke 'Area' -Exactly 0
        #Should -Invoke 'ContributionArea' -Exactly 0
        #Should -Invoke 'Stop-MVPActivity' -Exactly 1
        #Should -Invoke 'Save-MVPActivity' -Exactly 0

    }

    it "Should throw an error when an issue is raised within the fixture" {

        Mock -CommandName 'Test-ActivityScriptBlock' -MockWith {}
        Mock -CommandName 'Test-SEDriver' -MockWith {}
        Mock -CommandName 'Wait-ForMVPElement' -MockWith {}
        Mock -CommandName 'Invoke-MVPActivity' -MockWith {}

        Mock -CommandName 'Area' -MockWith {}
        Mock -CommandName 'Value' -MockWith { Throw "TEST" }
        Mock -CommandName 'ContributionArea' -MockWith {}

        Mock -CommandName 'Save-MVPActivity' -MockWith {}
        Mock -CommandName 'Stop-MVPActivity' -MockWith {}
        Mock -CommandName 'Wait-ForActivityWindow' -MockWith {}
        Mock -CommandName 'Write-Error' -MockWith {}
        Mock -CommandName 'Write-Warning' -MockWith {}

        $params = @{
            Fixture = {
                Area 'TEST'
                ContributionArea 'TEST'
                Value 'TEST' 'TEST' 
            }
            ArgumentList = $null
        }

        $null = New-MVPActivity @params

        Should -Invoke 'Test-ActivityScriptBlock' -Exactly 1
        Should -Invoke 'Test-SEDriver' -Exactly 1
        Should -Invoke 'Wait-ForMVPElement' -Exactly 1
        Should -Invoke 'Invoke-MVPActivity' -Exactly 1
        
        Should -Invoke 'Wait-ForActivityWindow' -Exactly 1
        Should -Invoke 'Area' -Exactly 1
        Should -Invoke 'ContributionArea' -Exactly 1
        Should -Invoke 'Stop-MVPActivity' -Exactly 1
        Should -Invoke 'Save-MVPActivity' -Exactly 0
        
    }

}