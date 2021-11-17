[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $UrlKortstokk = "http://nav-deckofcards.herokuapp.com/shuffle"
)

$ErrorActionPreference = 'Stop'

$Response = Invoke-WebRequest -Uri $UrlKortstokk

$Cards = $Response.Content | ConvertFrom-Json

#$Cards.GetType()

$Kortstokk = @()
foreach ($card in $Cards) {
    $Kortstokk += ($card.suit)[0] + $card.value 
}
Write-Host "Kortstokk: $Kortstokk"
