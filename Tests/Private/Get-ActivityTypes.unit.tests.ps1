Describe "Get-ActivityTypes" {
    
    BeforeEach {
        $Global:SEActivityTypes = "TEST"
    }

    AfterEach  {
        try { Remove-Variable -Name SEActivityTypes -ErrorAction Stop} catch {}
    }

    It "When already invoked, will return a cached list" {
        
        Mock -CommandName Test-SEDriver -MockWith {}
        Mock -CommandName Test-SEActivityTypes -MockWith { return "TEST" }
        Mock -CommandName Write-Verbose -MockWith {}

        $Result = Get-ActivityTypes

        Should -Invoke "Write-Verbose" -Exactly 2
        $Result | Should -be "TEST"

    }

    It "When invoked without the cache, will enumerate, cache and return a list" {

        Mock -CommandName Test-SEDriver -MockWith {}
        Mock -CommandName Test-SEActivityTypes -MockWith {}
        Mock -CommandName Write-Verbose -MockWith {}

        # Mock the Global Variable
        $Global:MVPDriver = [PSCustomObject]@{
            PageSource = Get-Content '..\Mocks\Add-NewActivityArea.html.mock'
        }

        $Result = Get-ActivityTypes

        $Result | Should -not -BeNullOrEmpty
        $Result.Value | Should -not -BeNullOrEmpty
        $Result.Name | Should -not -BeNullOrEmpty        
        $Result.Count | Should -BeGreaterThan 1

    }

    it "When invoked without the cache and HTML content. It will fail and throw an error" {

        Mock -CommandName Test-SEDriver -MockWith {}
        Mock -CommandName Test-SEActivityTypes -MockWith {}
        Mock -CommandName Write-Verbose -MockWith {}

        $Global:MVPDriver = [PSCustomObject]@{
            PageSource = "BAD DATA"
        }
        
        {Get-ActivityTypes} | Should -Throw "*Unable to enumerate ActivityTypes*"

    }

}