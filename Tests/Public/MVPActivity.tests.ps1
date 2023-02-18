Describe "MVPActivity" {

    if ($Global:TestRootPath) {
        $badTestCasePath = Join-Path -Path $Global:TestRootPath -ChildPath '\Mocks\MVPActivity\BadTestCases'
        $goodTestCasePath = Join-Path -Path $Global:TestRootPath -ChildPath '\Mocks\MVPActivity\GoodTestCases'
    } else {
        $badTestCasePath = '..\Mocks\MVPActivity\BadTestCases'
        $goodTestCasePath = '..\Mocks\MVPActivity\GoodTestCases'
    }        

    $badTestCases = (Get-ChildItem -Path $badTestCasePath -File).FullName | ForEach-Object { @{ CSVPath = $_ } }
    $goodTestCases = (Get-ChildItem -Path $goodTestCasePath -File).FullName | ForEach-Object { @{ CSVPath = $_ } }

    if ($badTestCases.Length -eq 0) { Throw "Missing badTestCases CSV Files." }
    if ($goodTestCases.Length -eq 0) { Throw "Missing goodTestCases CSV Files." }
    
    it "CSV Input. Standard Import." -TestCases $goodTestCases {
        param($CSVPath)

        Mock -CommandName 'New-MVPActivity' -MockWith {}
        Mock -CommandName 'Write-Host' -MockWith {}

        $null = MVPActivity -CSVPath $CSVPath
        
        Should -Invoke "Write-Host" -Exactly 3
        Should -Invoke "New-MVPActivity" -Exactly 2

    }

    it "CSV Input. Standard Import. Bad CSV Data Should Fail" -TestCases $badTestCases {
        param($CSVPath)

        Mock -CommandName 'New-MVPActivity' -MockWith {}
        Mock -CommandName 'Write-Host' -MockWith {}

        { MVPActivity -CSVPath $CSVPath } | Should -Throw

        Should -Not -Invoke 'New-MVPActivity'
        Should -Not -Invoke 'Write-Host'

    }

    it "Should retry multiple times when the 'Add Activity' Form fails." -TestCases $goodTestCases {
        param($CSVPath)

        Mock -CommandName 'New-MVPActivity' -MockWith { throw "Error" }
        Mock -CommandName 'Write-Host' -MockWith {}
        Mock -CommandName 'Write-Warning' -MockWith {}
        Mock -CommandName 'Enter-SeUrl' -MockWith {}
        Mock -CommandName 'Start-Sleep' -MockWith {}
        Mock -CommandName 'Write-Error' -MockWith {}

        $Result = MVPActivity -CSVPath $CSVPath

        $Result | Should -BeNullOrEmpty

        Should -Invoke 'Write-Error' -Times 2
        Should -Invoke 'New-MVPActivity' -Times 1
        Should -Invoke 'Write-Host' -Times 1
        Should -Invoke 'Write-Warning' -Times 1
        Should -Invoke 'Enter-SeUrl' -Times 1
        Should -Invoke 'Start-Sleep' -Times 1

    }

}