# This Test is Disabled until I can figure out an effective way to test the logic
# within the Pester Framework.
Describe "Test-CallStack" -Skip {

    BeforeAll {
        # We need to unload the MVPActivity public cmdlet so we can mock it
        Rename-Item -Path Function:\MVPActivity -NewName unloaded-MVPActivity
    }

    AfterAll {
        # Unload the Mocked Function
        Remove-Item -Path Function:\MVPActivity
        # load the Origional Function
        Rename-Item -Path Function:\unloaded-MVPActivity -NewName MVPActivity
    }

    it "Standard Execution. MVPActivity was called in the stack" {

        Function MVPActivity {
            Function TestFunction {
                Test-CallStack -Name 'TestFunction'
            }        

            TestFunction
        }
        
        { MVPActivity } | Should -not Throw

    }

}