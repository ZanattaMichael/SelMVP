data LocalizedData {
    ConvertFrom-StringData @'
    ErrorNestedMVPActivity=Nested MVPActivity. MVPActivity is only requried for the top-level declaration. Refer to usage.
    ErrorMissingMVPActivityArea=Missing 'Area' Statement.
    ErrorMissingMVPActivityAreaMultiple=Multiple Statements of 'Area' was detected. Only a single instance is permitted.
    ErrorMissingMVPActivityContributionArea=Missing 'ContributionArea' Statement.
    ErrorExceedMVPActivityContributionArea=Exceeded 'ContributionArea' Limit. Limit is 2. Count was '{0}'.
    ErrorMissingMVPActivityValue=Missing 'Value' Statement.
    ErrorMissingActivityType=Unable to enumerate ActivityTypes from source HTML.
    ErrorMissingContributionType=Unable to enumerate ContributionAreas from source HTML.
    ErrorMissingDriver=Missing Selinum Driver. Use: ConnectTo-Selenium to connect.
    ErrorTryTentitiveCommand=Try-TentitiveCommand: Exceeded Retry Limit.
    ErrorMissingSelectedValue=The Parameter '-SelectedValue' value '{0}', could not be found
    ErrorTooManySelectedValue=The Parameter '-SelectedValue' value '{0}', returned too many items. Count '{1}'
    ErrorJavaScriptTimeout=Javascript Timeout.
    ErrorNoActivityButton=Cannot Select Add New Activity Button.
    ErrorAreaNotNested=Error. 'Area' is not nested within MVPActivity.
    ErrorContributionAreaNotNested=Error. 'ContributionArea' is not nested within MVPActivity.
    ErrorHTMLFormStructureDefaultParameter=Error. The 'default' Parameter Value is prohibited.
    ErrorHTMLFormStructureMissingName=Error. Could not match name '{0}' with HTMLFormStructure.
    ErrorCannotFindHTMLElement=Error. Could not match HTML element '{0}' with HTMLFormStructure.
    ErrorTooManyHTMLElements=Error. Too many results with HTML element '{0} with HTMLFormStructure. Count '{1}'
    ErrorFieldValidationError=Error. A field validation error was found within the form. Error: '{0}'"
    ErrorMissingRequiredEntries=Error. Missing Required HTML Fields: '{0}'
    WarningEntryWasNotSaved=An Error occured when attempting to add the entry. THE ENTRY WAS NOT SAVED.
    ElementIdActivityType=activityTypeSelector 
    ElementIdContributionArea=select_contributionAreasDDL
    ElementButtonNewActivity=addNewActivityBtn
    ElementButtonCancelActivity=submitCloseButton
    ElementButtonSubmitActivity=submitActivityButton
    ElementValueArticle=e36464de-179a-e411-bbc8-6c3be5a82b68
    ElementValueChefPuppetInDataCenter=b803f4ef-066b-e511-810b-fc15b428ced0
    VariableSaveActivitySleepCounter=SaveActivitySleepCounter
    TestActivityRegexMVPActivity=^MVPActivity
    TestActivityRegexMVPArea=^Area
    TestActivityRegexMVPContributionArea=^ContributionArea
    TestActivityRegexMVPValue=^Value
'@
}