

Function Global:Get-HTMLFormStructureMockedData  {

    return @(
        [PSCustomObject]@{
            Name = 'Test'
            Element = 'Test'
            isRequired = $True
            isSet = $false
            Format = {}
        }
        [PSCustomObject]@{
            Name = 'Test2'
            Element = 'Test2'
            isRequired = $True
            isSet = $false
            Format = {}
        }
        [PSCustomObject]@{
            Name = 'Test3'
            Element = 'Test3'
            isRequired = $True
            isSet = $false
            Format = {}
        }
    )

}

function Global:Get-ActivityTypesMockedData {

    return @(
        [PSCustomObject]@{
            Name = 'Test'
            Value = 'TestGUID'
        }
        [PSCustomObject]@{
            Name = 'Test2'
            Value = 'Test2GUID'
        }
        [PSCustomObject]@{
            Name = 'Test3'
            Value = 'Test3GUID'
        }
    )  

}

Function Global:Get-AreaGlobalMock {
    Mock -CommandName "Test-SEDriver" -MockWith {}
    Mock -CommandName "Test-CallStack" -MockWith {}
    Mock -CommandName "Start-Sleep" -MockWith {}        
    Mock -CommandName "Get-HTMLFormStructure" -MockWith { Global:Get-HTMLFormStructureMockedData }
}

Describe "Area" {

    it "Standard Execution" {

        Global:Get-AreaGlobalMock
        Mock -CommandName "Get-ActivityTypes" -MockWith { Global:Get-ActivityTypesMockedData }
        Mock -CommandName "Select-DropDown" -MockWith {}
        Mock -CommandName "Wait-ForJavascript" -MockWith {}

        $Result = Area 'Test'
        
        Should -Invoke "Get-HTMLFormStructure" -Exactly 1
        Should -Invoke "Test-SEDriver" -Exactly 1
        Should -Invoke "Test-CallStack" -Exactly 1
        Should -Invoke "Get-ActivityTypes" -Exactly 1
        Should -Invoke "Wait-ForJavascript" -Times 1
        Should -Invoke "Start-Sleep" -Exactly 0
        
    }

    it "Parsing a bad activity type that dosen't exist" {

        Global:Get-AreaGlobalMock
        Mock -CommandName "Get-ActivityTypes" -MockWith { Global:Get-ActivityTypesMockedData }
        Mock -CommandName "Select-DropDown" -MockWith {}
        Mock -CommandName "Wait-ForJavascript" -MockWith {}
        
        { Area 'BadData' } | Should -Throw ($LocalizedData.ErrorMissingSelectedValue -f "*")
        
        Should -Invoke "Get-HTMLFormStructure" -Exactly 0
        
    }
   
    it "Parsing a bad activity type that returned multiple values" {

        Mock -CommandName Test-SEDriver -MockWith {}
        Mock -CommandName Test-CallStack -MockWith {} 
        Mock -CommandName Get-HTMLFormStructure -MockWith {} 
        Mock -CommandName Get-ActivityTypes -MockWith {
            return @(
                [PSCustomObject]@{
                    Name = 'Test'
                    Value = 'TestGUID'
                }
                [PSCustomObject]@{
                    Name = 'Test'
                    Value = 'TestGUID'
                }
            )
        }

        { Area 'Test' } | Should -Throw ($LocalizedData.ErrorTooManySelectedValue -f "*", 2)
        
        Should -Invoke "Get-HTMLFormStructure" -Exactly 0
        
    }

    it "Standard Execution however there is a problem with selecting the dropdown box" {

        Global:Get-AreaGlobalMock
        Mock -CommandName "Get-ActivityTypes" -MockWith { Global:Get-ActivityTypesMockedData }
        Mock -CommandName Select-DropDown -ParameterFilter { $selectedValue -eq 'TestGUID'} -MockWith {
            Throw "Test Error"
        }
        Mock -CommandName Select-DropDown -MockWith {} -ParameterFilter { $selectedValue -eq $LocalizedData.ElementValueArticle }
        Mock -CommandName Write-Error -MockWith {}
        Mock -CommandName Wait-ForJavascript -MockWith {}
        
        { Area 'Test' } | Should -Throw $LocalizedData.ErrorAreaFailure

        Should -Invoke "Wait-ForJavascript" -Exactly 0
        Should -Invoke "Select-DropDown" -Times 2
        Should -Invoke "Write-Error" -Times 1
        Should -Invoke "Start-Sleep" -Times 1
        
    }

    it "Standard Execution however Wait-ForJavascript fails because the form is bad" {

        Global:Get-AreaGlobalMock
        Mock -CommandName "Get-ActivityTypes" -MockWith { Global:Get-ActivityTypesMockedData }
        Mock -CommandName "Select-DropDown" -MockWith {}
        Mock -CommandName "Wait-ForJavascript" -MockWith { Throw "TestError" }
        Mock -CommandName Write-Error -MockWith {}

        { Area 'Test' } | Should -Throw $LocalizedData.ErrorAreaFailur6e
        
        Should -Invoke "Wait-ForJavascript" -Times 1
        Should -Invoke "Select-DropDown" -Times 2
        Should -Invoke "Write-Error" -Times 1
        Should -Invoke "Start-Sleep" -Times 1
        
    }

}