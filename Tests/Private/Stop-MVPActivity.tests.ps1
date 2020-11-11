Describe "Stop-MVPActivity" {

    it "Standard Exeuction - No Issues" {

        Mock -CommandName Test-SEDriver -MockWith {}
        Mock -CommandName Find-SeElement -MockWith { return [PSCustomObject]@{data = "TEST"}}
        Mock -CommandName Invoke-SeClick -MockWith {} -RemoveParameterType 'Element'
        
        {Stop-MVPActivity} | Should -Not -Throw
        Should -Invoke "Find-SeElement" -Exactly 1
        Should -Invoke "Invoke-SeClick" -Exactly 1   
        
    }

    it "An Error is raised with Find-SeElement will cause the function to throw an error" {

        Mock -CommandName Test-SEDriver -MockWith {}
        Mock -CommandName Find-SeElement -MockWith { Throw "TEST" }
        
        {Stop-MVPActivity} | Should -Throw ($LocalizedData.ErrorStopMVPActivity -f "*")
        Should -Invoke "Find-SeElement" -Exactly 1
        Should -Invoke "Invoke-SeClick" -Exactly 0
        
    }    

    it "An Error is raised with Find-SeElement will cause the function to throw an error" {

        Mock -CommandName Test-SEDriver -MockWith {}
        Mock -CommandName Find-SeElement -MockWith { return [PSCustomObject]@{data = "TEST"}}
        Mock -CommandName Invoke-SeClick -MockWith { Throw "TEST" } -RemoveParameterType 'Element'
        
        {Stop-MVPActivity} | Should -Throw ($LocalizedData.ErrorStopMVPActivity -f "*")
        Should -Invoke "Find-SeElement" -Exactly 1
        Should -Invoke "Invoke-SeClick" -Exactly 1
        
    }

}