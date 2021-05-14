Function ContributionArea {
<#
.Description
The ContributionArea defines the Contribution Areas within a contribution.
ContributionArea can be used as a String Array (ContributionArea 'Area1','Area2','Area3'), or by specifying multiple ContributionArea statements.

Similarly to Area, if ContributionArea is included within the Param() block, it's not required to be defined and will be automatically invoked.

The current list of 'Contribution Areas' are:
 +   Chef/Puppet in Datacenter
 +   Container Management
 +   Datacenter Management
 +   Enterprise Security
 +   Group Policy
 +   High Availability
 +   Hyper-V
 +   Linux in System Center/Operations Management Suite
 +   Linux on Hyper-V
 +   Networking
 +   PowerShell
 +   Storage
 +   Windows Server for Small & Medium Business
 +   Azure Bot Service
 +   Azure Cognitive Search
 +   Azure Cognitive Services
 +   Azure Machine Learning
 +   Dynamics 365
 +   Power Apps
 +   Power Automate
 +   Power Virtual Agents
 +   Azure Arc Enabled Data Services
 +   Azure Cosmos DB
 +   Azure Data Catalog
 +   Azure Data Lake
 +   Azure Database for MySQL
 +   Azure Database for PostgreSQL
 +   Azure Databricks
 +   Azure HDInsight and Hadoop & Spark on Azure
 +   Azure Search
 +   Azure SQL (Database, Pools, Serverless, Hyperscale, Managed Instance, Virtual Machines)
 +   Azure SQL Edge
 +   Azure Stream Analytics
 +   Azure Synapse Analytics
 +   Big Data Clusters
 +   Cortana Intelligence Suite
 +   Data Warehousing (Azure SQL Data Warehouse, Fast Track & APS)
 +   Information Management (ADF, SSIS, &Data Sync)
 +   Power BI
 +   SQL Server (on Windows, Linux, Containers)
 +   SQL Server Machine Learning Services  (R, Python)
 +   SQL Server Reporting Services & Analysis Services
 +   .NET
 +   Accessibility
 +   ASP.NET/IIS
 +   Azure DevOps
 +   C++
 +   Developer Security
 +   Front End Web Dev
 +   Java
 +   Javascript/Typescript
 +   Node.js
 +   PHP
 +   Python
 +   Quantum
 +   Unity
 +   Visual Studio Extensibility
 +   Xamarin
 +   Endpoint Manager
 +   Identity and Access
 +   Information Protection
 +   Previous Expertise: Directory Services
 +   Remote Desktop Services
 +   ARM Templates (Infra as Code)
 +   Azure API Management
 +   Azure App Service
 +   Azure Arc Enabled Infrastructure
 +   Azure Backup & Disaster Recovery
 +   Azure Blockchain
 +   Azure Core Compute (VMSS, Confidential Computing, Platform Deployment)
 +   Azure Cost Management
 +   Azure Edge + Platform (Azure Stack Hub, Stack Edge, Media Services)
 +   Azure Functions
 +   Azure IoT
 +   Azure Kubernetes, Container Instances, Docker
 +   Azure Lighthouse
 +   Azure Logic Apps
 +   Azure Migrate
 +   Azure Monitor
 +   Azure Networking
 +   Azure Policy & Governance
 +   Azure SDK (Software Development Kit) and CLIs ( Az CLI, PowerShell, Terraform, Ansible)
 +   Azure Service Fabric
 +   Azure Storage
 +   Cloud Infrastructure Protection
 +   Distributed App Runtime (Dapr), Open App Model (OAM), Open Service Mesh (OSM)
 +   Previous Expertise: Microsoft Azure
 +   Service Bus, Event Hubs, Event Grid, Relay
 +   Threat Protection
 +   Access
 +   Excel
 +   Exchange
 +   Microsoft Stream
 +   Microsoft Teams
 +   Office 365
 +   OneDrive
 +   OneNote
 +   Outlook
 +   PowerPoint
 +   Project
 +   SharePoint
 +   Skype for Business
 +   Visio
 +   Word
 +   Yammer
 +   Microsoft Graph
 +   Microsoft Teams Development
 +   Outlook Development
 +   SharePoint Development
 +   W/X/P Development
 +   Surface for IT
 +   Windows for IT
 +   Windows App Development
 +   Windows Design
 +   Windows Hardware Engineering (IoT, Mobile, and Desktop)
 +   Windows Mixed Reality

.PARAMETER SelectedValue
The Contribution Areas that you wish to add.

.EXAMPLE
Single Use:

ContributionArea 'Area1'
.EXAMPLE
ContributionArea can be stacked like so:

ContributionArea 'Area1'
ContributionArea 'Area2'
ContributionArea 'Area3'

.EXAMPLE
ContributionArea can placed in an array:

ContributionArea 'Area1','Area2','Area3'

.SYNOPSIS
The ContributionArea is a command that defines the Contribution Areas within the MVP Portal.

#>
    [cmdletbinding()]
    param(
        # Parameter help description
        [Parameter(Mandatory)]
        [String[]]
        $SelectedValue
    )

    begin {

        # Test if the Driver is active. If not throw a terminating error.
        Test-SEDriver
        # Test the Callstack.
        Test-CallStack $PSCmdlet.MyInvocation.MyCommand.Name
        
    }

    process {

        # Multiple Contribution Areas can be parsed in.
        ForEach ($Param in $SelectedValue) {

            # Validate the $SelectedValue Parameters
            [Array]$matchedActivityType = Get-ContributionAreas | Where-Object { $_.Name -eq $Param }
            if ($matchedActivityType.Count -eq 0) { Throw ($LocalizedData.ErrorMissingSelectedValue -f $Param) }
            if ($matchedActivityType.Count -ne 1) { Throw ($LocalizedData.ErrorTooManySelectedValue -f $Param, $matchedActivityType.count) }
            
            # Generate the ElementId
            $elementId = $(
                if ($Script:ContributionAreas.Count -eq 0) { $LocalizedData.ElementIdContributionArea }
                else { "{0}{1}" -f $LocalizedData.ElementIdContributionArea, ($Script:ContributionAreas.Count + 1) }
            )

            # Add to the Contribution Areas
            $Script:ContributionAreas.Add(
                [PSCustomObject]@{
                    elementId = $matchedActivityType.Name
                    selectedValue = $matchedActivityType.Value
                }
            )

            #
            # If the $Script:ContributionAreas count is gt then 3, then select the 'add more' link

            if ($Script:ContributionAreas.count -ge 3) {
                $AddMoreButton = Find-SeElement -Driver $Global:MVPDriver -By ClassName -Selection 'add' 
                Invoke-SeClick -Element $AddMoreButton 
            }

            #
            # You will need to inspect the elements on the HTML to add additional drop down settings.
            # Make sure you set the id as the value

            ttry {
                Select-DropDown -elementId $elementId -selectedValue $matchedActivityType.Value
                # We are using Views of answers to dertmine if the Javascript has ran
                Wait-ForJavascript -ElementText 'Views of answers'
            } -Catch {       
                # If the Javascript Fails to Populate the Sub entries within the form       
                # it will retrigger by select the "Chef/Puppet in Datacenter"
                Start-Sleep -Seconds 1
                Select-DropDown -elementId $Script:ContributionAreas[-1].elementId -selectedValue $LocalizedData.ElementValueChefPuppetInDataCenter   
            } -RetryLimit 10     
        }   
    }
}
