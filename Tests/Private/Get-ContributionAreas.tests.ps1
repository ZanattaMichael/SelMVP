Describe "Get-ContributionAreas" -Tag Unit {
    
    BeforeAll {
        # Load the 
        if ($Global:TestRootPath) {
            $Global:MockMVPDriver = Join-Path -Path $Global:TestRootPath -ChildPath 'Mocks\Add-NewActivityArea.html.mock'
        } else {
            $Global:MockMVPDriver = '..\Mocks\Add-NewActivityArea.html.mock'
        }        
    }

    BeforeEach {
        $Global:SEContributionAreas = "TEST"
    }

    AfterEach  {
        try { Remove-Variable -Name SEContributionAreas -ErrorAction Stop} catch {}
    }

    It "When already invoked, will return a cached list" {
        
        Mock -CommandName Test-SEDriver -MockWith {}
        Mock -CommandName Test-SEContributionAreas -MockWith { return $true }
        Mock -CommandName Write-Verbose -MockWith {}

        $Result = Get-ContributionAreas

        Should -Invoke "Write-Verbose" -Exactly 2
        $Result | Should -be "TEST"

    }

    It "When invoked without the cache, will enumerate, cache and return a list" {

        Mock -CommandName Test-SEDriver -MockWith {}
        Mock -CommandName Test-SEContributionAreas -MockWith {}
        Mock -CommandName Write-Verbose -MockWith {}

        # Mock the Global Variable
        $Global:MVPDriver = [PSCustomObject]@{
            PageSource = Get-Content $Global:MockMVPDriver
        }

        $Result = Get-ContributionAreas

        $Result | Should -not -BeNullOrEmpty
        $Result.Value | Should -not -BeNullOrEmpty
        $Result.Name | Should -not -BeNullOrEmpty        
        $Result.Count | Should -BeGreaterThan 1

    }

    it "When invoked without the cache and HTML content. It will fail and throw an error" {

        Mock -CommandName Test-SEDriver -MockWith {}
        Mock -CommandName Test-SEContributionAreas -MockWith {}
        Mock -CommandName Write-Verbose -MockWith {}

        $Global:MVPDriver = [PSCustomObject]@{
            PageSource = "BAD DATA"
        }
        
        {Get-ContributionAreas} | Should -Throw "*Unable to enumerate ContributionAreas*"

    }

    it "It will remove HTML Formatting from the ContributionAreas" {

        # Mock the Global Variable
        $Global:MVPDriver = [PSCustomObject]@{
            PageSource = Get-Content $Global:MockMVPDriver
        }

        Mock -CommandName Test-SEDriver -MockWith {}
        Mock -CommandName Test-SEContributionAreas -MockWith { return $false }
        Mock -CommandName Write-Verbose -MockWith {}

        $Result = Get-ContributionAreas

        $Result.Name | Where-Object { $_ -in "&amp;","&nbsp;"} | Should -be $null

    } 
 
}