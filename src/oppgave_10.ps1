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
            'J' { 10 }
            'Q' { 10 }
            'K' { 10 }
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


function skrivUtResultat {
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

    if ( $poengmeg -eq 21 -and $poengmagnus -eq 21) {
        #Draw
        Write-Host "Vinner: Draw"
    }
    elseif ( $poengmeg -eq 21) {
        # jeg vant
        Write-Host "Vinner: Meg"
    }
    elseif ( $poengmagnus -eq 21 ) {
        # magnus vant
        Write-Host "Vinner: Magnus"
    }
    elseif ($poengmeg -gt 21) {
        # magnus vant
        Write-Host "Vinner: Magnus"
    }
    elseif ($poengmagnus -gt 21) {
        # jeg vant
        Write-Host "Vinner: Meg"
    }
    else {
        # magnus vant, begge har mindre enn 21, så da har magnus mest
        Write-Host "Vinner: Magnus"     
    } 
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

if ($(KortSum($meg)) -ne 21 -and $(KortSum($magnus)) -ne 21 ) {
    #ingen har 21, begynn å trekke kort
    # meg trekker kort
    while ($(KortSum($meg)) -lt 17 ) {
        $meg += $cards[0]
        $cards = $cards[1..$cards.Length]
    }
    # magnus trekker kort
    if ($(KortSum($meg)) -le 21) {
        while ($(KortSum($magnus)) -ne 21 -and $(KortSum($magnus)) -le $(KortSum($meg)) ) {
            $magnus += $cards[0]
            $cards = $cards[1..$cards.Length]
        }
    }
}
# Calculate and print result
skrivUtResultat $meg  $magnus
   
Write-Host "Kortstokk: $(KortstokkPrint($cards))"

