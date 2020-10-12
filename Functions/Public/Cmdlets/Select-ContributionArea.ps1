function Select-ContributionArea {
    #
    # Selects a Value in a DropDown box.
    [cmdletbinding(
        DefaultParameterSetName = 'Standard'
    )]
    param(
        [parameter()]
        [ValidateSet("Primary","Additional")]
        [String]
        $Type="Primary"    
    )
    DynamicParam {
        $SelectedValue = [System.Management.Automation.ParameterAttribute]::new()
        $SelectedValue.Mandatory = $true

        $attributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::New()
        $attributeCollection.Add($SelectedValue)

        $dynParam1 = [System.Management.Automation.RuntimeDefinedParameter]::New("DP1", [Int32], $attributeCollection)

      $paramDictionary = New-Object `
        -Type System.Management.Automation.RuntimeDefinedParameterDictionary
      $paramDictionary.Add("DP1", $dynParam1)

    }

    param (      
        [parameter(Mandatory)]
        [ValidateSet("PowerShell","Other")]
        [String]
        $SelectedValue,
    
    )
     
    # Test if the Driver is active. If not throw a terminating error.
    Test-SEDriver       

    # Filter the Contribution Area
    $contributionArea = $(
        switch ($Type) {
            'Primary' { 'select_contributionAreasDDL' }
            'Additional' { 'select_contributionAreasDDL2' }
        }
    )

    #
    # You will need to inspect the elements on the HTML to add additional drop down settings.
    # Make sure you set the id as the value
    
    switch ($selectedValue) {
        'PowerShell' { $value = '7cc301bb-189a-e411-93f2-9cb65495d3c4' }
        'Other' { $value = 'ff6464de-179a-e411-bbc8-6c3be5a82b68' }
    }
    

    <option data-contributionid="b803f4ef-066b-e511-810b-fc15b428ced0" value="b803f4ef-066b-e511-810b-fc15b428ced0">Chef/Puppet in Datacenter</option>
    <option data-contributionid="be03f4ef-066b-e511-810b-fc15b428ced0" value="be03f4ef-066b-e511-810b-fc15b428ced0">Container Management</option>
    <option data-contributionid="c603f4ef-066b-e511-810b-fc15b428ced0" value="c603f4ef-066b-e511-810b-fc15b428ced0">Datacenter Management</option>
    <option data-contributionid="90c301bb-189a-e411-93f2-9cb65495d3c4" value="90c301bb-189a-e411-93f2-9cb65495d3c4">Enterprise Security</option>
    <option data-contributionid="7ac301bb-189a-e411-93f2-9cb65495d3c4" value="7ac301bb-189a-e411-93f2-9cb65495d3c4">Group Policy</option>
    <option data-contributionid="d003f4ef-066b-e511-810b-fc15b428ced0" value="d003f4ef-066b-e511-810b-fc15b428ced0">High Availability</option>
    <option data-contributionid="9ec301bb-189a-e411-93f2-9cb65495d3c4" value="9ec301bb-189a-e411-93f2-9cb65495d3c4">Hyper-V</option>
    <option data-contributionid="e403f4ef-066b-e511-810b-fc15b428ced0" value="e403f4ef-066b-e511-810b-fc15b428ced0">Linux in System Center/Operations Management Suite</option>
    <option data-contributionid="e203f4ef-066b-e511-810b-fc15b428ced0" value="e203f4ef-066b-e511-810b-fc15b428ced0">Linux on Hyper-V</option>
    <option data-contributionid="e603f4ef-066b-e511-810b-fc15b428ced0" value="e603f4ef-066b-e511-810b-fc15b428ced0">Networking</option>
    <option data-contributionid="7cc301bb-189a-e411-93f2-9cb65495d3c4" value="7cc301bb-189a-e411-93f2-9cb65495d3c4">PowerShell</option>
    <option data-contributionid="4604f4ef-066b-e511-810b-fc15b428ced0" value="4604f4ef-066b-e511-810b-fc15b428ced0">Storage</option>
    <option data-contributionid="98c301bb-189a-e411-93f2-9cb65495d3c4" value="98c301bb-189a-e411-93f2-9cb65495d3c4">Windows Server for Small &amp; Medium Business</option>

    <option data-contributionid="432e48a3-1c35-e711-810e-3863bb363e80" value="432e48a3-1c35-e711-810e-3863bb363e80">Azure Bot Service</option>
    <option data-contributionid="922e5279-1e31-ea11-a810-000d3a8ccaf5" value="922e5279-1e31-ea11-a810-000d3a8ccaf5">Azure Cognitive Search</option>    
    <option data-contributionid="6708a593-1c35-e711-810e-3863bb363e80" value="6708a593-1c35-e711-810e-3863bb363e80">Azure Cognitive Services</option>
    <option data-contributionid="a003f4ef-066b-e511-810b-fc15b428ced0" value="a003f4ef-066b-e511-810b-fc15b428ced0">Azure Machine Learning</option>
    <option data-contributionid="6679469e-e083-e811-8136-3863bb2bca60" value="6679469e-e083-e811-8136-3863bb2bca60">Dynamics 365</option>
    <option data-contributionid="fc78c036-45ac-e911-a9a0-000d3a1362e3" value="fc78c036-45ac-e911-a9a0-000d3a1362e3">Power Apps</option>
    <option data-contributionid="8ab4d989-45ac-e911-a9a0-000d3a1362e3" value="8ab4d989-45ac-e911-a9a0-000d3a1362e3">Power Automate</option>
    <option data-contributionid="0cd8fd4f-cac4-ea11-a812-000d3a8dfe0d" value="0cd8fd4f-cac4-ea11-a812-000d3a8dfe0d">Power Virtual Agents</option>
    <option data-contributionid="9c03f4ef-066b-e511-810b-fc15b428ced0" value="9c03f4ef-066b-e511-810b-fc15b428ced0">Azure Cosmos DB</option>
    <option data-contributionid="9a03f4ef-066b-e511-810b-fc15b428ced0" value="9a03f4ef-066b-e511-810b-fc15b428ced0">Azure Data Lake</option>
    <option data-contributionid="041f6ea2-bc62-e711-8117-3863bb36edf8" value="041f6ea2-bc62-e711-8117-3863bb36edf8">Azure Database for MySQL</option>
    <option data-contributionid="f5c002bd-bc62-e711-8117-3863bb36edf8" value="f5c002bd-bc62-e711-8117-3863bb36edf8">Azure Database for PostgreSQL</option>
    <option data-contributionid="9e03f4ef-066b-e511-810b-fc15b428ced0" value="9e03f4ef-066b-e511-810b-fc15b428ced0">Azure HDInsight and Hadoop &amp; Spark on Azure</option>




    $ActivityType = Find-SeElement -Driver (Get-SEDriver) -Id $contributionArea
    $SelectElement = [OpenQA.Selenium.Support.UI.SelectElement]::new($ActivityType)
    $SelectElement.SelectByValue($value)
    
}

Export-ModuleMember Select-ContributionArea