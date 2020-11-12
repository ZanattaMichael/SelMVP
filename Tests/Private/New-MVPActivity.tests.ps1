Describe "New-MVPActivity" -Tag Unit {

    BeforeAll {
        $Global:MVPDriver = [PSCustomObject]@{ Data = "Test"}
    }

    it "Standard execution with no retries" {
         
        Mock -CommandName Test-SEDriver -MockWith {}
        Mock -CommandName Find-SeElement -MockWith { 
            return ([PSCustomObject]@{ Data = "Test"}) 
        }
        Mock -CommandName Invoke-SeClick -MockWith {} -RemoveParameterType 'Element'
        Mock -CommandName Start-Sleep -MockWith {}
        Mock -CommandName Stop-MVPActivity -MockWith {}

        $Result = New-MVPActivity

        Should -Invoke "Find-SeElement" -Exactly 1
        Should -Invoke "Invoke-SeClick" -Exactly 1
        Should -Invoke "Start-Sleep" -Exactly 1
        Should -Invoke "Stop-MVPActivity" -Exactly 0

    }

    it "Bad Selenium Driver which throws a terminating error" {
         
        Mock -CommandName Test-SEDriver -MockWith { throw "error"}

        {New-MVPActivity} | Should -Throw

    }    

    it "Unable to find the New Activity button" {
         
        Mock -CommandName Test-SEDriver -MockWith {}
        Mock -CommandName Find-SeElement -MockWith { Throw "Bad" }
        Mock -CommandName Start-Sleep -MockWith {}
        Mock -CommandName Stop-MVPActivity -MockWith {}
        Mock -CommandName Write-Error -MockWith {}

        {New-MVPActivity} | Should -Throw $LocalizedData.ErrorNoActivityButton
        Should -Invoke "Find-SeElement" -Exactly 4
        Should -Invoke "Start-Sleep" -Exactly 4
        Should -Invoke "Stop-MVPActivity" -Exactly 4

    }   
    
    it "The function is able to find the New Activity button, but unable to click it" {
         
        Mock -CommandName Test-SEDriver -MockWith {}
        Mock -CommandName Find-SeElement -MockWith { 
            return ([PSCustomObject]@{ Data = "Test"}) 
        }
        Mock -CommandName Invoke-SeClick -MockWith { Throw "Error"} -RemoveParameterType 'Element'
        Mock -CommandName Start-Sleep -MockWith {}
        Mock -CommandName Stop-MVPActivity -MockWith {}
        Mock -CommandName Write-Error -MockWith {}

        {New-MVPActivity} | Should -Throw $LocalizedData.ErrorNoActivityButton
        Should -Invoke "Find-SeElement" -Exactly 4
        Should -Invoke "Invoke-SeClick" -Exactly 4
        Should -Invoke "Start-Sleep" -Exactly 4
        Should -Invoke "Stop-MVPActivity" -Exactly 4

    }           
    
}