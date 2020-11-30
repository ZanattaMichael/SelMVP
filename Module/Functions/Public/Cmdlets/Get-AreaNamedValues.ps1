function Get-AreaNamedValues {
    [CmdletBinding()]
    param (
        [Parameter()]
        [String]
        $AreaName
    )

    # Call the HTML FormStrucutre and Parse in the Article Name
    Get-HTMLFormStructure $AreaName | Select-Object Name, @{Name='Mandatory';Exp={$_.isRequired}} | Sort-Object -Property Mandatory -Descending

}