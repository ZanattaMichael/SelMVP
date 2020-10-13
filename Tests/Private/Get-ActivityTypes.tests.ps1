Describe "Get-ActivityTypes" {
    
    BeforeAll {
        Add-Type -LiteralPath 'Libraries\HTMLAgilityPack\HtmlAgilityPack.dll'
    }

    It "will return a list of data" {

        Mock -CommandName Test-SEDriver -MockWith {}
        Mock -CommandName Get-SEDriver -MockWith {
            [PSCustomObject]@{
                PageSource = Get-Content 'Tests\Mocks\Add-NewActivityArea.html.mock'
            }
        }

        $Result = Get-ActivityTypes

        $Result | Should -not -BeNullOrEmpty
        $Result.Value | Should -not -BeNullOrEmpty
        $Result.Name | Should -not -BeNullOrEmpty        
        $Result.Count | Should -BeGreaterThan 1

    }

    it "will return an error (If empty)" {

        Mock -CommandName Test-SEDriver -MockWith {}
        Mock -CommandName Get-SEDriver -MockWith {
            [PSCustomObject]@{
                PageSource = "EMPTY"
            }
        }
        
        {Get-ActivityTypes} | Should -Throw "*Unable to enumerate ActivityTypes*"

    }

}