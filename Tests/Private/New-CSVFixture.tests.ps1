Describe "New-CSVFixture" {

    $TestCases = @(
        @{
            ImportCSVMock = @(
                [PSCustomObject]@{
                    Area = 'AreaTest'
                    ContributionArea = 'ContributionAreaTest'
                    Column1 = 'Column1'
                    Column2 = 'Column2'
                    Column3 = 'Column3'
                }
            )
        }
        @{
            ImportCSVMock = @(
                [PSCustomObject]@{
                    Area = 'AreaTest'
                    ContributionArea = 'ContributionAreaTest'
                    SecondContributionArea = 'SecondContributionAreaTest'
                    Column1 = 'Column1'
                    Column2 = 'Column2'
                    Column3 = 'Column3'
                }
            )
        }
        @{
            ImportCSVMock = @(
                [PSCustomObject]@{
                    Area = 'AreaTest'
                    ContributionArea = 'ContributionAreaTest'
                    SecondContributionArea = 'SecondContributionAreaTest'
                    ThirdContributionArea = 'ThirdContributionAreaTest'
                    Column1 = 'Column1'
                    Column2 = 'Column2'
                    Column3 = 'Column3'
                }
            )
        }
        @{
            ImportCSVMock = @(
                [PSCustomObject]@{
                    Area = 'AreaTest'
                    ContributionArea = 'ContributionAreaTest'
                    SecondContributionArea = 'SecondContributionAreaTest'
                    ThirdContributionArea = 'ThirdContributionAreaTest'
                    Column1 = 'Column1'
                    Column2 = 'Column2'
                    Column3 = 'Column3'
                    Column4 = 'Column1'
                    Column5 = 'Column2'
                    Column6 = 'Column3'  
                    Column7 = 'Column1'
                    Column8 = 'Column2'
                    Column9 = 'Column3'
                    Column10 = 'Column1'
                    Column11 = 'Column2'
                    Column12 = 'Column3'                                      
                }
            )
        }
    )

    it "Paramaterized Testing: No errors should be thrown." -TestCases $TestCases {
        param( $ImportCSVMock, $Assert )

        $ExcludedProperties = @(
            'Area'
            'ContributionArea'
            'SecondContributionArea'
            'ThirdContributionArea'
        )
        $ParametersThatShouldntExist = 'SecondContributionArea','ThirdContributionArea'

        $PSObjectProperties = $ImportCSVMock | Get-Member -MemberType NoteProperty | Where-Object {$_.Name -notin $ExcludedProperties}
        $WrappedParameters = $PSObjectProperties | ForEach-Object { "`${$($_.Name)}" }
        $WrappedCommands = $PSObjectProperties | ForEach-Object { "Value '$($_.Name)' `${$($_.Name)}" }

        Mock -CommandName Import-CSV -MockWith  { return $ImportCSVMock }
        Mock -CommandName Get-HTMLFormStructure -MockWith {
            return ($ImportCSVMock | Select-Object * -ExcludeProperty Area, *Contribution* | Get-Member -Type NoteProperty | ForEach-Object {
                [PSCustomObject]@{
                    Name = $_.Name
                    Element = 'MOCK'
                    isRequird = $false
                    isSet = $false
                    Format = {}
                }
            })
        }
        
        $Result = New-CSVFixture -LiteralPath "Test"
        $ASTParameterNames = $Result.Ast.ParamBlock.Parameters.Extent.Text

        # Should be Type ScriptBlock
        $Result | Should -BeOfType [ScriptBlock]
        Should -Invoke "Import-CSV" -Exactly 1
        
        #
        # Parameter Validation

        # Should contain Area, ContributionArea (Mandatory)
        '$Area', '$ContributionArea' | Should -BeIn $ASTParameterNames

        # Should contain the paramters to pass into the value
        $WrappedParameters | Should -BeIn $ASTParameterNames
        # Shouldn't contain any other columns that is parsed in.
        $ParametersThatShouldntExist | Should -Not -BeIn $ASTParameterNames
        
        #
        # Value Validation

        $WrappedCommands | Should -BeIn $Result.ast.endblock.statements.extent.text

    }

}