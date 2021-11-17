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


function KortstokkPrint {
    param (
        [Parameter()]
        [Object[]]
        $cards    
    )
# Skriver ut kortstokk
$Kortstokk = @()
foreach ($card in $Cards) {
    $Kortstokk += ($card.suit)[0] + $card.value 
}
$Kortstokk
    
}


Write-Host "Kortstokk: $(KortstokkPrint($cards))"
Write-Host "Poengsum" $Sum

$meg = $cards[0..1]
$cards = $cards[2..$cards.Length]

$magnus = $cards[0..1]
$cards = $cards[2..$cards.Length]

Write-Host "Meg: $(KortstokkPrint($meg))"
Write-Host "Magnus: $(KortstokkPrint($magnus))"

Write-Host "Kortstokk: $(KortstokkPrint($cards))"

