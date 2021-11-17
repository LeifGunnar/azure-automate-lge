# Blackjack oppgave 3
#$Jsoncards = Invoke-WebRequest -Uri "http://nav-deckofcards.herokuapp.com/shuffle"
#Write-Host $Jsoncards
#$deckofcards = ConvertFrom-Json $Jsoncards
#Write-Host $deckofcards
#Write-Host $deckofcards[4]
#Write-Host $deckofcards[4].suit
#foreach ($card in $deckofcards) {
#    Write-Host $card.suit $card.value ","
#}
$Url = "http://nav-deckofcards.herokuapp.com/shuffle"
$Response = Invoke-WebRequest -Uri $Url

$Cards = $Response.Content | ConvertFrom-Json

#$Cards.GetType()

$Kortstokk = @()
foreach ($card in $Cards) {
    $Kortstokk += ($card.suit)[0] + $card.value 
}
Write-Host "Kortstokk: $Kortstokk"
