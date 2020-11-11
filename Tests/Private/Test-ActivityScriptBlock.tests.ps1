Describe "Test-ActivityScriptBlock" {

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
                $Result = Test-ActivityScriptBlock $Fixture
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
                $Result = Test-ActivityScriptBlock $Fixture
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
                $Result = Test-ActivityScriptBlock $Fixture
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

        . $Act
        $Assert.Invoke()

    }

}