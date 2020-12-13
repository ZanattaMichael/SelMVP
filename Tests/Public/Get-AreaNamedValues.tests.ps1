Describe "Get-AreaNamedValues" {

    $NamedValuesThatExistTestParams = $Global:HTMLFormStructure.Name | Where-Object {
        $_ -ne 'Default'
    } | ForEach-Object { @{ Name = $_ }}

    $NamedValuesThatExistWhiteSpaceTestParams = $Global:HTMLFormStructure.Name | Where-Object {
        $_ -ne 'Default'
    } | ForEach-Object { @{ Name = " $($_) " }}

    $NameValuesThatDontExistTestParams = @(
        @{ Name = 'NOTEXIST' }
        @{ Name = 'ALSODOSENTEXIST' }
    )

    it "When parsed values that exist should return an object and not an error." -TestCases $NamedValuesThatExistTestParams {
        param($Name)

        $Result = Get-AreaNamedValues -AreaName $Name
        $Result | Should -Not -BeNullOrEmpty

        $Properties = $Result | Get-Member -MemberType NoteProperty

        'Name' | Should -BeIn $Properties.Name
        'Mandatory' | Should -BeIn $Properties.Name
    
    }

    it "When parsed values that DONT exist will return an error" -TestCases $NameValuesThatDontExistTestParams {
        param($Name)

        { Get-AreaNamedValues -AreaName $Name } | Should -Throw ($LocalizedData.ErrorHTMLFormStructureMissingName -f "*")
    
    }

    it "When parsed the default value, should throw an error" {
        { Get-AreaNamedValues -AreaName 'Default' } | Should -Throw ($LocalizedData.ErrorHTMLFormStructureDefaultParameter) 
    }

    it "When whitespaces are parsed, it should automatically trim the input" -TestCases $NamedValuesThatExistWhiteSpaceTestParams {
        param($Name)

        $Result = Get-AreaNamedValues -AreaName $Name
        $Result | Should -Not -BeNullOrEmpty

        $Properties = $Result | Get-Member -MemberType NoteProperty

        'Name' | Should -BeIn $Properties.Name
        'Mandatory' | Should -BeIn $Properties.Name
            
    }

}