data LocalizedData {
    ConvertFrom-StringData @'
    ErrorNestedMVPActivity=Nested MVPActivity. MVPActivity is only requried for the top-level declaration. Refer to usage.
    ErrorMissingMVPActivityArea=Missing 'Area' Statement.
    ErrorMissingMVPActivityAreaMultiple=Multiple Statements of 'Area' was detected. Only a single instance is permitted.
    ErrorMissingMVPActivityContributionArea=Missing 'ContributionArea' Statement.
    ErrorMissingMVPActivityElement=Missing 'Element' Statement.
    ErrorMissingActivityType=Unable to enumerate ActivityTypes from source HTML.
    ErrorMissingContributionType=Unable to enumerate ContributionAreas from source HTML.
    ErrorMissingDriver=Missing Selinum Driver. Use: ConnectTo-Selenium to connect.
    ErrorTryTentitiveCommand=Try-TentitiveCommand: Exceeded Retry Limit.
    ErrorJavaScriptTimeout=Javascript Timeout.
    ErrorNoActivityButton=Cannot Select Add New Activity Button.
    ErrorAreaNotNested=Error. 'Area' is not nested within MVPActivity.
    ErrorContributionAreaNotNested=Error. 'ContributionArea' is not nested within MVPActivity.
    ElementIdActivityType=activityTypeSelector 
    ElementIdContributionArea=select_contributionAreasDDL
    ElementButtonNewActivity=addNewActivityBtn
    ElementButtonCancelActivity=submitCloseButton
    ElementButtonSubmitActivity=submitActivityButton
    ElementValueArticle=e36464de-179a-e411-bbc8-6c3be5a82b68
    ElementValueChefPuppetInDataCenter=b803f4ef-066b-e511-810b-fc15b428ced0
    VariableSaveActivitySleepCounter=SaveActivitySleepCounter
    DynamicParameterAreaNameParameterName=SelectedValue
    TestActivityRegexMVPActivity=^MVPActivity
    TestActivityRegexMVPArea=^Area
    TestActivityRegexMVPContributionArea=^ContributionArea
    TestActivityRegexMVPElement=^Element
'@
}