
Describe "Select-DropDown" -Tag Unit {

    it "Standard Execution" {

        class fake_nonError_Select_Element {
            fake_Select_Element($val) {
            }
            [void] SelectByValue($val) {
            }
        }

        Mock -CommandName 'Find-SeElement' -MockWith {
            [PSCustomObject]@{
                Data = "Test"
            }
        }
        Mock -CommandName 'New-Object' -MockWith { New-Object 'fake_nonError_Select_Element' } `
            -ParameterFilter {
                $TypeName -and  
                $TypeName -eq 'OpenQA.Selenium.Support.UI.SelectElement'
            }        

        $result = Select-DropDown -elementId 'TestID' -selectedValue 'TestValue'
        Should -Invoke 'Find-SeElement' -Exactly 1
        { Select-DropDown -elementId 'TestID' -selectedValue 'TestValue' } | Should -Not -Throw
        
    }

    it "An error is raised when searching for the Element" {
       
        Mock -CommandName 'Find-SeElement' -MockWith { Throw "Test" }
        {Select-DropDown -elementId "Id" -selectedValue "Value" } | Should -Throw
    }

    it "An error is raised when selecting the dropdown on the found Element" {

        class fake_Error_Select_Element {
            fake_Select_Element($val) {
            }
            [void] SelectByValue($val) {
                Throw "TEST"
            }
        }    
        

        Mock -CommandName 'Find-SeElement' -MockWith {
            [PSCustomObject]@{
                Data = "Test"
            }
        }
        Mock -CommandName 'New-Object' -MockWith { New-Object 'fake_Error_Select_Element' } `
            -ParameterFilter {
                $TypeName -and  
                $TypeName -eq 'OpenQA.Selenium.Support.UI.SelectElement'
            }  
        
        {Select-DropDown -elementId "Id" -selectedValue "Value" } | Should -Throw
        Should -Invoke 'New-Object' -Exactly 1
        
    }
}