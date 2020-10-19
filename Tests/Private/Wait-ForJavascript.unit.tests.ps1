
Describe "Wait-ForJavascript" {

    BeforeAll {
        $Global:Driver = [PSCustomObject]@{
            PageSource = "THIS IS A TEST STRING"
        } 
    }

    AfterAll {
        Remove-Variable -Name Driver -Scope Global
    }

    $TestCases = @(
        @{
            Arrange = {
                Mock Test-SEDriver -MockWith {}
                Mock Start-Sleep -MockWith {}                                              
            }
            ElementTextToSearch = "TEST"
            Assert = {
                { Wait-ForJavascript $ElementTextToSearch } | Should -Not -Throw
            }            
        },
        @{
            Arrange = {
                Mock Test-SEDriver -MockWith {}
                Mock Start-Sleep -MockWith {}                                               
            }
            ElementTextToSearch = "INVALID STRING"
            Assert = {
                { Wait-ForJavascript $ElementTextToSearch } | Should -Throw
            }            
        }        
    )

    it "Should execute correctly" -TestCases $TestCases {
        param ($Arrange, $ElementTextToSearch, $Assert)        
        $Arrange.Invoke()
        $Assert.Invoke()
    }
}
