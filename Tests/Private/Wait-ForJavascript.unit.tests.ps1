
Describe "Wait-ForJavascript" {

    BeforeAll {
        $Global:MVPDriver = [PSCustomObject]@{
            PageSource = "THIS IS A TEST STRING"
        } 
    }

    AfterAll {
        try {Remove-Variable -Name MVPDriver -Scope Global } finally {}
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
