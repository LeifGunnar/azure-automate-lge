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

$Sum = 0
foreach ($card in $Cards) {
    $Sum += switch ($card.value) {
        'J' { 10 }
        'Q' { 10 }
        'K' { 10 }
        'A' { 11 }
        Default { $card.value }
    }
}



# Skriver ut kortstokk
$Kortstokk = @()
foreach ($card in $Cards) {
    $Kortstokk += ($card.suit)[0] + $card.value 
}
Write-Host "Kortstokk: $Kortstokk"
Write-Host "Poengsum" $Sum
