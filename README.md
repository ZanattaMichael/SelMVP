# Selenium MVP PowerShell Module

![Current Test Status](https://github.com/ZanattaMIchael/SelMVP/workflows/Current%20Test%20Status/badge.svg)

Selenium MVP is a PowerShell module that uses PowerShell Selenium combined with a Domain Specific Language (DSL) to automate MVP Submissions. This module targets *first time MVP nominees* who don't have access to the API.

# About

- Automates MVP Submissions using the Portal.
- Required for Non-MVP nominees since API is unavailable.
- Written in a custom DSL (Domain Specific Language)

## Requirements

- [PowerShell Selenium](https://github.com/adamdriscoll/selenium-powershell)
- Windows PowerShell 5.1 (Minimum)

*Please note that this Module is not supported on PowerShell Core.*

# Installation

1. ` Install-Module SelMVP `
1. ` Install-Module Selenium `

## (Optional) Installing the WebDriver

_For the best experience, Mozilla Firefox is recommended._

As newer browsers are released, older versions of the WebDrivers need to be updated. Currently, there is no method for correcting these automatically. When updating, download the same version that your browser is. To check your version, you can:

- [Microsoft Edge:](https://support.microsoft.com/en-us/microsoft-edge/find-out-which-version-of-microsoft-edge-you-have-c726bee8-c42e-e472-e954-4cf5123497eb)
- [Mozilla Firefox:](https://support.mozilla.org/en-US/kb/find-what-version-firefox-you-are-using)
- [Google Chrome:](https://support.google.com/chrome/answer/95414?co=GENIE.Platform%3DDesktop&hl=en)

To update the Web Driver, head over to the following links:

- [Microsoft Edge](https://developer.microsoft.com/en-us/microsoft-edge/tools/webdriver/)
- [Mozilla Firefox](https://github.com/mozilla/geckodriver/releases)
- [Google Chrome](https://sites.google.com/a/chromium.org/chromedriver/downloads)

Once downloaded, unblock and extract the driver to the 'Assemblies' sub-directory within the Selenium PowerShell directory.

To determine the location of the Module, you can run the following PowerShell:

`Import-Module Selenium ; Get-Module Selenium | Select-Object Path`

# Usage

## Connect to the MVPPortal (Default: Firefox)

``` PowerShell

   # Connect to Portal
   ConnectTo-MVPPortal -URLPath "https://Your-URL-Path-Goes-Here.com"

```

OR if you want to specify the DriverType explicitly:

``` PowerShell

   # Connect to Portal
   ConnectTo-MVPPortal -URLPath "https://Your-URL-Path-Goes-Here.com" -DriverType ('Firefox','Chrome' or 'Edge')

```

## Create an Activity (using a CSV)

### Usage

``` PowerShell
# Import the CSV File and Parse it. Note that the headers for the Activity Need to be Present:
MVPActivity -CSVPath 'Path to CSV File'
```

Example CSV File:

``` CSV
Date,Title,URL,Description,Number of Articles,Number of Views,Area,ContributionArea,SecondContributionArea,ThirdContributionArea
28/11/2020,TEST,https://www.google.com,TEST,1,1,Article,PowerShell,Networking,Storage
28/11/2020,TEST,https://www.google.com,TEST,1,1,Article,PowerShell,Networking,Storage
```

## Create an Activity (using DSL)

### Activity Syntax

``` PowerShell
   # Define Activity
   MVPActivity [String]"Name of Activity" [-ArgumentList [Hashtable[]]$params] [-CSVPath [String]'CSVPath'] {
       param()

       Area [String]"Area"
       ContributionArea [String[]]"ContributionArea"
       Value [String]"TextName" [String]"TextValue"

   }
```

### Usage

``` PowerShell

    MVPActivity "Article Contributions" {

        Area 'Article'
        # ContributionArea can accept an Array
        ContributionArea 'PowerShell','Yammer','Word'

        Value 'Date' '08/05/2021'
        Value 'Title' 'TEST'
        Value 'URL' 'https:\\test.com'
        Value 'Description' 'THIS IS A TEST'
        Value 'Number of Articles' '1'
        # Or you can use the HTML DivId
        Value 'Number of Views' 1
    }

```

OR

``` PowerShell

    MVPActivity "Reddit Contribution" {

        Area 'Article'
        # ContributionArea can be added each time.
        ContributionArea 'PowerShell'
        ContributionArea 'Yammer'
        ContributionArea 'Word'

        Value -Name 'Date' -Value '08/05/2021'
        Value 'Title' 'TEST'
        Value 'URL' 'https:\\test.com'
        Value 'Description' 'THIS IS A TEST'
        Value 'Number of Articles' '1'
        # Or you can use the HTML DivId
        Value 'Number of Views' 1

    }
```

### Advanced Usage

``` PowerShell

    #
    # Parameters can be parsed into the Fixture as a HashTable
    #

    $params = @{
        Area = "Blog/Website Post"
        ContributionArea = "PowerShell","Yammer","Word"
        date = '26/10/2020'
    }

    # Define Activity
    MVPActivity "Name of Activity" -ArgumentList $params {
        # If the Parameters -Area or -ContributionArea are defined 
        # in the param block, the cmdlet is not required (Area or ContributionArea).
        param($Area, $ContributionArea, $date)

        # You can use the String Name
        Value 'Date' $date
        Value 'Title' 'TEST'
        Value 'URL' 'https:\\test.com'
        Value 'Description' 'THIS IS A TEST'
        Value 'Number of Posts' '1'
        # Or you can use the HTML Div Id
        Value 'Number of Subscribers' '1'
        Value 'Annual Unique Visitors' '1'
        # Still can execute PowerShell within the script block
        Start-Sleep -Seconds 3

   }
```

OR

``` PowerShell

    #
    # For those who love complexity, the Fixture supports an array of HashTables to be parsed
    # into the Fixture.
    #

    $params = @(
        @{
            Area = "Blog/Website Post"
            ContributionArea = "PowerShell","Yammer","Word"
            date = '26/10/2020'
        }
        @{
            Area = "Blog/Website Post"
            ContributionArea = "PowerShell","Yammer","Word"
            date = '15/10/2020'
        }
    )

    # Define Activity
    MVPActivity "Name of Activity" -ArgumentList $params {
        # If the Parameters -Area or -ContributionArea are defined in the param block, 
        # the cmdlet is not required (Area or ContributionArea).
        param($Area, $ContributionArea, $date)

        # You can use the String Name
        Value 'Date' $date
        Value 'Title' 'TEST'
        Value 'URL' 'https:\\test.com'
        Value 'Description' 'THIS IS A TEST'
        Value 'Number of Posts' '1'
        # Or you can use the HTML Div Id
        Value 'Number of Subscribers' '1'
        Value 'Annual Unique Visitors' '1'
        # Still can execute PowerShell within the script block
        Start-Sleep -Seconds 3

   }
```

# Description

## `MVPActivity`

`MVPActivity` is the top-level definition command, which *groups* the MVP contribution types into their respective areas.
For Example: In the example below, I have a personal blog which I would like to group all my content:

```PowerShell
MVPActivity "Personal Blogs" {
    Area 'Article'
}
```

This grouping is not specific to the Activity to have multiple `MVPActivities` with the same Area.
For Example:

```PowerShell

MVPActivity "Personal Blogs" {
    Area 'Blog/Website Post'
    ContributionArea 'PowerShell'
    Value 'Date' '19/11/2020'
    Value 'Title' 'TEST'
    Value 'URL' 'https:\\test.com'
    Value 'Description' 'THIS IS A TEST'
    Value 'Number of Posts' '1'
    # Or you can use the HTML Div Id
    Value 'Number of Subscribers' '1'
    Value 'Annual Unique Visitors' '1'
}

MVPActivity "Another Random Blog" {
    Area 'Blog/Website Post'
    ContributionArea 'PowerShell'
    Value 'Date' '19/11/2020'
    Value 'Title' 'TEST2'
    Value 'URL' 'https:\\test.com'
    Value 'Description' 'THIS IS A TEST2'
    Value 'Number of Posts' '1'
    # Or you can use the HTML Div Id
    Value 'Number of Subscribers' '1'
    Value 'Annual Unique Visitors' '1'
}

```

`MVPActivity` supports arguments being parsed into it using the `-ArgumentList` parameter, similarly to the -TestCases parameter within Pester. Input is defined as a `[HashTable]` or a `[HashTable[]]`.

Now we can refactor this logic to take advantage of the `-ArgumentList` parameter:

``` PowerShell

$arguments = @(
    @{
        Area = 'Blog/Website Post'
        ContributionArea = 'PowerShell'
        Date = '19/11/2020'
        Title = 'TEST'
        Url = 'https:\\test.com'
        Description = 'THIS IS A TEST'
        NumberOfPosts = 1
        NumberOfSubscribers = 1
        NumberOfVisitors = 1
    },
    @{
        Area = 'Blog/Website Post'
        ContributionArea = 'PowerShell'
        Date = '19/11/2020'
        Title = 'TEST2'
        Url = 'https:\\test.com'
        Description = 'THIS IS A TEST2'
        NumberOfPosts = 1
        NumberOfSubscribers = 1
        NumberOfVisitors = 1
    }
)

MVPActivity "Another Random Blog" -ArgumentList $arguments {
    param($Area, $ContributionArea, $Date, $Title, $Url, $Description, $NumberOfPosts, $NumberOfSubscribers, $NumberOfVisitors)

    Area $Area
    ContributionArea $ContributionArea
    Value 'Date' $Date
    Value 'Title' $Title
    Value 'URL' $Url
    Value 'Description' $Description
    Value 'Number of Posts' $NumberOfPosts
    Value 'Number of Subscribers' $NumberOfSubscribers
    Value 'Annual Unique Visitors' $NumberOfVisitors
}

```

The code block can be refactored further. The DSL enables automatic Area and ContributionArea execution within the Fixture only by including `$Area` or `$ContributionArea` within the parameter:

``` PowerShell

$arguments = @(
    @{
        Area = 'Blog/Website Post'
        ContributionArea = 'PowerShell'
        Date = '19/11/2020'
        Title = 'TEST'
        Url = 'https:\\test.com'
        Description = 'THIS IS A TEST'
        NumberOfPosts = 1
        NumberOfSubscribers = 1
        NumberOfVisitors = 1
    },
    @{
        Area = 'Blog/Website Post'
        ContributionArea = 'PowerShell'
        Date = '19/11/2020'
        Title = 'TEST2'
        Url = 'https:\\test.com'
        Description = 'THIS IS A TEST2'
        NumberOfPosts = 1
        NumberOfSubscribers = 1
        NumberOfVisitors = 1
    }
)

MVPActivity "Another Random Blog" -ArgumentList $arguments {
    param($Area, $ContributionArea, $Date, $Title, $Url, $Description, $NumberOfPosts, $NumberOfSubscribers, $NumberOfVisitors)

    # Removed $Area and $ContributionArea, since they are included in the Fixture's param block.
    Value 'Date' $Date
    Value 'Title' $Title
    Value 'URL' $Url
    Value 'Description' $Description
    Value 'Number of Posts' $NumberOfPosts
    Value 'Number of Subscribers' $NumberOfSubscribers
    Value 'Annual Unique Visitors' $NumberOfVisitors

}

```

## `Area [String]'Area Name'`

`Area` is a command that defines the MVP Contribution Area in the Portal. `Area` can only be used within MVPActivity.

Usage:

``` PowerShell
MVPActivity "Test" {

    # Specify the Area. In this instance we are specifying the article.
    Area 'Article'

}
```

`Area` is not required to be included when `$Area` is added to the `param()` within the Fixture. For Example:

``` PowerShell

MVPActivity "Test" -ArgumentList $params {
    param($Area)
}

```

The Current List of Areas are:

- Article
- Blog/WebSite Post
- Book (Author)
- Book (Co-Author)
- Conference (Staffing)
- Docs.Microsoft.com Contribution
- Forum Moderator
- Forum Participation (3rd Party forums)
- Forum Participation (Microsoft Forums)
- Mentorship
- Microsoft Open Source Projects
- Non-Microsoft Open Source Projects
- Organizer (User Group/Meetup/Local Events)
- Organizer of Conference
- Other
- Product Group Feedback
- Sample Code/Projects/Tools
- Site Owner
- Speaking (Conference)
- Speaking (User Group/Meetup/Local events)
- Technical Social Media (Twitter, Facebook, LinkedIn...)
- Translation Review, Feedback and Editing
- Video/Webcast/Podcast
- Workshop/Volunteer/Proctor

## ContributionArea `[String[]]'ContributionAreas'`

The ContributionArea defines the Contribution Areas within a contribution.
ContributionArea can be used as a String Array (ContributionArea 'Area1','Area2','Area3'), or by specifying multiple ContributionArea statements.

Similarly to Area, if ContributionArea is included within the Param() block, it's not required to be defined and will be automatically invoked.

The current list of 'Contribution Areas' are:

- Chef/Puppet in Datacenter
- Container Management
- Datacenter Management
- Enterprise Security
- Group Policy
- High Availability
- Hyper-V
- Linux in System Center/Operations Management Suite
- Linux on Hyper-V
- Networking
- PowerShell
- Storage
- Windows Server for Small & Medium Business
- Azure Bot Service
- Azure Cognitive Search
- Azure Cognitive Services
- Azure Machine Learning
- Dynamics 365
- Power Apps
- Power Automate
- Power Virtual Agents
- Azure Arc Enabled Data Services
- Azure Cosmos DB
- Azure Data Catalog
- Azure Data Lake
- Azure Database for MySQL
- Azure Database for PostgreSQL
- Azure Databricks
- Azure HDInsight and Hadoop & Spark on Azure
- Azure Search
- Azure SQL (Database, Pools, Serverless, Hyperscale, Managed Instance, Virtual Machines)&nbsp;
- Azure SQL Edge
- Azure Stream Analytics
- Azure Synapse Analytics
- Big Data Clusters
- Cortana Intelligence Suite
- Data Warehousing (Azure SQL Data Warehouse, Fast Track & APS)
- Information Management (ADF, SSIS, &Data Sync)
- Power BI
- SQL Server (on Windows, Linux, Containers)
- SQL Server Machine Learning Services  (R, Python)
- SQL Server Reporting Services & Analysis Services
- .NET
- Accessibility
- ASP.NET/IIS
- Azure DevOps
- C++
- Developer Security
- Front End Web Dev
- Java
- Javascript/Typescript
- Node.js
- PHP
- Python
- Quantum
- Unity
- Visual Studio Extensibility
- Xamarin
- Endpoint Manager
- Identity and Access
- Information Protection
- Previous Expertise: Directory Services
- Remote Desktop Services
- ARM Templates (Infra as Code)
- Azure API Management
- Azure App Service
- Azure Arc Enabled Infrastructure
- Azure Backup & Disaster Recovery
- Azure Blockchain
- Azure Core Compute (VMSS, Confidential Computing, Platform Deployment)
- Azure Cost Management
- Azure Edge + Platform (Azure Stack Hub, Stack Edge, Media Services)
- Azure Functions
- Azure IoT
- Azure Kubernetes, Container Instances, Docker
- Azure Lighthouse
- Azure Logic Apps
- Azure Migrate
- Azure Monitor
- Azure Networking
- Azure Policy & Governance
- Azure SDK (Software Development Kit) and CLIs ( Az CLI, PowerShell, Terraform, Ansible)
- Azure Service Fabric
- Azure Storage
- Cloud Infrastructure Protection
- Distributed App Runtime (Dapr), Open App Model (OAM), Open Service Mesh (OSM)
- Previous Expertise: Microsoft Azure
- Service Bus, Event Hubs, Event Grid, Relay
- Threat Protection
- Access
- Excel
- Exchange
- Microsoft Stream
- Microsoft Teams
- Office 365
- OneDrive
- OneNote
- Outlook
- PowerPoint
- Project
- SharePoint
- Skype for Business
- Visio
- Word
- Yammer
- Microsoft Graph
- Microsoft Teams Development
- Outlook Development
- SharePoint Development
- W/X/P Development
- Surface for IT
- Windows for IT
- Windows App Development
- Windows Design
- Windows Hardware Engineering (IoT, Mobile, and Desktop)
- Windows Mixed Reality

Single:

``` PowerShell

MVPActivity "Test" {
    ContributionArea 'Area1','Area2','Area3'
}

```

Multiple:

``` PowerShell

MVPActivity "Test" {

    ContributionArea 'Area1'
    ContributionArea 'Area2'
    ContributionArea 'Area3'

}
```

Param Block:

``` PowerShell

MVPActivity "Test" {
    Param($ContributionArea)

    # ContributionArea is not required when included in the Param Block.
}

```

## Value `[String]'Name' [String]'Value'`

The `Value` command input's the data into the HTML form, using the 'Name' (*Being the HTML Div Element ID or Text Name*) and 'Value' (Corresponding Value) syntax. Since different Area's have various fields, you can use `Get-AreaNamedValues 'AreaName'` to identify the fields.

> `Value` is *mandatory*, within  `MVPActivity` and won't invoke when specified within the `Param()` bock.

In the example below, we will use `Get-AreaNamedValues 'Article'` to get the `Value` names:  

``` Text
Get-AreaNamedValues Article

Name               Mandatory
----               ---------
Number of Articles      True
Title                   True
Date                    True
Number of Views        False
URL                    False
Description            False
```

Once the list is returned, we can construct the data structure using the output:

``` PowerShell
MVPActivity "Test" {
    
    # Let's set the Area and the Contribution Area
    Area 'Article'
    ContributionArea 'PowerShell'

    # We can set the mandatory parameters
    Value "Number or Articles" 1
    Value Title "Test Entry"
    Value Date "30/11/2020"

}

```

`Value` supports the auto-formatting of inputted data to meet the requirements of the MVP Portal.
Currently, the following Portal dependencies are auto-formatted:

- Date (Required to be US Date Format) (MM-DD-YYYY)
- URL (Required to meet URL format) (https://site.com)
# Contributing

## Getting Started

1. Fork and Clone the Repo `git clone "https://github.com/ZanattaMichael/SelMVP.git" dirpath`
1. Update.
1. Load the Module by running: `SelMVP\Build\LocalLoader.ps1`.
1. Update Changes and Push.
1. Raise Pull Request.
1. Sit Back and Relax.

# Building the Module Locally

1. Clone the Repo `git clone "https://github.com/ZanattaMichael/SelMVP.git" dirpath`
1. Open VSCode
1. Run 'Build Module' Task

OR

1. Clone the Repo `git clone "https://github.com/ZanattaMichael/SelMVP.git" dirpath`
1. Run '\Build\BuildModule.ps1'
## Things to know

- You can run the tests locally by running the "Run Pester Tests" VSCode Task.
- If you want to test the Module locally without importing the Module, you can run: `SelMVP\Build\LocalLoader.ps1`. This script will dot-source the functions and dll's needed.
- I have created a React Site that emulates the functionality of the Portal.
Moving forward, I plan to add integration tests against this Portal.