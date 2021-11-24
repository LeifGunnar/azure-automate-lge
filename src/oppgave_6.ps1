[CmdletBinding()]
param (
    [Parameter(HelpMessage = "Url til kortstokk")]
    [string]
    $UrlKortstokk = "http://nav-deckofcards.herokuapp.com/shuffle"
)

$ErrorActionPreference = 'Stop'
try {
    $Response = Invoke-WebRequest -Uri $UrlKortstokk    
}
catch {
    Write-Host "Not a valid url $UrlKortstokk"
    exit 1
}

$Cards = $Response.Content | ConvertFrom-Json

#$Cards.GetType()

$Sum = 0
foreach ($card in $Cards) {
    $Sum += switch ($card.value) {
        { $_ -cin @('J', 'Q', 'K') } { 10 }
        'A' { 11 }
        Default { $card.value }
    }
}


# Returnerer kortstokk på formen CA H6 D9
function KortstokkPrint {
    param (
        [Parameter()]
        [Object[]]
        $cards    
    )
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

