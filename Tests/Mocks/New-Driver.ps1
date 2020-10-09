Function New-MockFirefoxDriver {}
Function New-MockChromeDriver {}
Function New-MockEdgeDriver {}



($_ -is [OpenQA.Selenium.Firefox.FirefoxDriver]) -or
($_ -is [OpenQA.Selenium.Chrome.ChromeDriver])

mock 'New-' {
    New-MockObject -Type Thing.Type
}