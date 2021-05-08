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
        
        Should -Invoke "Write-Host" -Exactly 1
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

}