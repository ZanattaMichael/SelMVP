# Selenium MVP PowerShell Module

Selenium MVP is a PowerShell module that uses PowerShell Selenium combined with a Domain Specific Language (DSL) to automate MVP Submissions. This module is built for *first time MVP nominees* who don't have access to the API.

This module is intended to make submitting new submissions *as simple as possible*, by using the Domain Specific Language.

Using this approach means that you can group different contributions areas and contribution types together in a well structured language.

# About

- Automates MVP Submissions using the Portal.
- Required for Non-MVP nominees, since API is unavailable.
- Written in a DSL (Domain Specific Language)
## Requirements:

- [PowerShell Selenium](https://github.com/adamdriscoll/selenium-powershell)
# Installation

1. ` Install-Module SelMVP `
1. ` Install-Module Selenium `
# Usage

## Connect to the MVPPortal (Default: Firefox)

``` PowerShell

   # Connect to Portal
   ConnectTo-MVPPortal -URLPath "https://Your-URL-Path-Goes-Here.com"

```

OR if you want to explicitly specify a DriverType:

``` PowerShell

   # Connect to Portal
   ConnectTo-MVPPortal -URLPath "https://Your-URL-Path-Goes-Here.com" -DriverType ('Firefox','Chrome' or 'Edge')

```

## Create an Activity:

### Syntax:

``` PowerShell


   # Define Activity
   MVPActivity "Name of Activity" [-ArgumentList $params] {
       param()

       Area [String]"Area"
       ContributionArea [String[]]"ContributionArea"
       Value [String]"TextName" [String]"TextValue"

   }
```

### Usage

``` PowerShell

    MVPActivity "Reddit Contribution" {

        Area 'Article'
        # ContributionArea can accept an Array
        ContributionArea 'PowerShell','Yammer','Word'

        Value 'Date' $date
        Value 'Title' 'TEST'
        Value 'URL' 'https:\\test.com'
        Value 'Description' 'THIS IS A TEST'
        Value 'Number of Posts' '1'
        # Or you can use the HTML DivId Name
        Value 'Number of Subscribers' '1'
        Value 'Annual Unique Visitors' '1'

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

        Value 'Date' $date
        Value 'Title' 'TEST'
        Value 'URL' 'https:\\test.com'
        Value 'Description' 'THIS IS A TEST'
        Value 'Number of Posts' '1'
        # Or you can use the HTML DivId Name
        Value 'Number of Subscribers' '1'
        Value 'Annual Unique Visitors' '1'

    }

```

### Advanced Usage

``` PowerShell

    $params = @{
        Area = "Blog/Website Post"
        ContributionArea = "PowerShell","Yammer","Word"
        date = '26/10/2020'
    }

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
        # Or you can use the HTML Div Id Name
        Value 'Number of Subscribers' '1'
        Value 'Annual Unique Visitors' '1'
        # Still can execute PowerShell within the script block
        Start-Sleep -Seconds 3

   }

```


## Example 1: 

``` PowerShell
# Prior to doing anything we need to connect to the portal
ConnectTo-MVPPortal -URLPath "https://Your-URL-Path-Goes-Here.com"

# Once Loaded we can define our MVP Activity
# In this instance we are adding Reddit Contributions

MVPActivity "Reddit Contributions" {

    # This now follows the MVP Activity Form itself.
    # You need to specify the Area and the Contribution Area
    Area ""
    ContributionArea "PowerShell"

}

```

# Description

### `MVPActivity`:

`MVPActivity` is the top-level definition, which *groups* the MVP contribution types into their respective areas.
For Example: In the example below, I have a personal blog which I would like to group all my content:

```PowerShell
MVPActivity "Personal Blogs" {
    Area 'Article'
}
```

This grouping is not specific to the activity, so you can have multiple `MVPActivities` with the same area.
So what does this look like?

```PowerShell
MVPActivity "Personal Blogs" {
    Area 'Article'
    ContributionArea 'PowerShell'
    Value 'Date' '19/11/2020'
    Value 'Title' 'TEST'
    Value 'URL' 'https:\\test.com'
    Value 'Description' 'THIS IS A TEST'
    Value 'Number of Posts' '1'
    # Or you can use the HTML Div Id Name
    Value 'Number of Subscribers' '1'
    Value 'Annual Unique Visitors' '1'
}

MVPActivity "Another Random Blog" {
    Area 'Article'
    ContributionArea 'PowerShell'
    Value 'Date' '19/11/2020'
    Value 'Title' 'TEST'
    Value 'URL' 'https:\\test.com'
    Value 'Description' 'THIS IS A TEST'
    Value 'Number of Posts' '1'
    # Or you can use the HTML Div Id Name
    Value 'Number of Subscribers' '1'
    Value 'Annual Unique Visitors' '1'
}

```

`MVPActivity` supports arguments being parsed into it using the -ArgumentList parameter, similarly to the -TestCases parameter within Pester. Input is defined as a HashTable 

Now if you have an understanding of PowerShell, you can refactor this logic as follows:

```

$data = @{
    Article = 
}

```