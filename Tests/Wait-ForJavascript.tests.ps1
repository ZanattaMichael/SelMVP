
Describe "Wait-ForJavascript" {

    BeforeAll {

    }

    TestCases @(
        @{
            Mocks = @{
                Mock 'New-MockFirefoxDriver' {
                    New-MockObject -Type OpenQA.Selenium.Firefox.FirefoxDriver
                }
            }
        }
    )

}

mock 'Get-Thing' {
    New-MockObject -Type Thing.Type
}