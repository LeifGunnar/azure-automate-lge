#aksepter parameter
[CmdletBinding()]
param(
    # Angi navn som skal skrives ut
    [Parameter()]
    [String]
    $navn
)
Write-Host "Hei $navn!"
