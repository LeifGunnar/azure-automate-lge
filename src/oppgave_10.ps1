[CmdletBinding()]
param (
    [Parameter()]
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

# Returner sum av verdien i en samling kort
function KortSum {
    param (
        [Parameter()]
        [Object[]]
        $Cards
    )
    $Sum = 0
    foreach ($card in $Cards) {
        $Sum += switch ($card.value) {
            { $_ -cin @('J', 'Q', 'K') } { 10 }
            'A' { 11 }
            Default { $card.value }
        }
    }
    $Sum
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

function finnVinner {
    param (
        [Parameter()]
        [System.Object[]]
        $meg,
        [Parameter()]
        [System.Object[]]
        $magnus
    )
    $poengmeg = KortSum($meg)
    $poengmagnus = KortSum($magnus)
    $blackjack = 21

    if ( $poengmeg -eq $blackjack -and $poengmagnus -eq $blackjack) {
        # Draw
        "Draw"
    }
    elseif ( $poengmeg -eq $blackjack) {
        # jeg vant
        "Meg"
    }
    elseif ( $poengmagnus -eq $blackjack) {
        # magnus vant
        "Magnus"
    }
    elseif ($poengmeg -gt $blackjack) {
        # magnus vant
        "Magnus"
    }
    elseif ($poengmagnus -gt $blackjack) {
        # jeg vant
        "Meg"
    }
    else {
        # magnus vant, begge har mindre enn 21, så da har magnus mest
        "Magnus"     
    }
}

function skrivUtResultat {
    param (
        [Parameter()]
        [string]
        $vinner,
        [Parameter()]
        [System.Object[]]
        $meg,
        [Parameter()]
        [System.Object[]]
        $magnus
    )
    $poengmeg = KortSum($meg)
    $poengmagnus = KortSum($magnus)

    Write-Host "Vinner: $vinner"      
    Write-Host "Magnus | $poengmagnus | $(KortstokkPrint($magnus))"
    Write-Host "Meg | $poengmeg | $(KortstokkPrint($meg))"
}


Write-Host "Kortstokk: $(KortstokkPrint($cards))"
Write-Host "Poengsum: $(KortSum($cards))"

# Deal cards
$meg = $cards[0..1]
$cards = $cards[2..$cards.Length]
$magnus = $cards[0..1]
$cards = $cards[2..$cards.Length]

$blackjack = 21

if ($(KortSum($meg)) -ne $blackjack -and $(KortSum($magnus)) -ne $blackjack ) {
    #ingen har 21, begynn å trekke kort
    # meg trekker kort
    while ($(KortSum($meg)) -lt 17 ) {
        $meg += $cards[0]
        $cards = $cards[1..$cards.Length]
    }
    # magnus trekker kort hvis jeg ikke har mere enn 21 poeng
    # trekker inntil magnus får mere enn meg eller 21
    if ($(KortSum($meg)) -le $blackjack) {
        while ($(KortSum($magnus)) -ne $blackjack -and $(KortSum($magnus)) -le $(KortSum($meg)) ) {
            $magnus += $cards[0]
            $cards = $cards[1..$cards.Length]
        }
    }
}
# Calculate and print result
skrivUtResultat $(finnVinner $meg $magnus) $meg  $magnus
   
