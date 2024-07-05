#!/bin/bash

# Pfad zur Logdatei
LOG_FILE="/home/rooney/Docs/logs/finance/exchange_CHFUSD.log"

# Funktion zum Extrahieren des neuesten Wechselkurses aus der Logdatei
fetch_exchange_rate() {
    # Den neuesten Wechselkurs aus der Logdatei holen (letzte Zeile)
    EXCHANGE_RATE=$(tail -n 1 "$LOG_FILE" | awk '{print $(NF-1)}')
    echo $EXCHANGE_RATE
}

# API-Schlüssel und Basis-URL festlegen
API_KEY="sO4EvJx00lON9Af5H0jnEXlWcKMw1KrI"
BASE_URL="https://api.polygon.io/v2/aggs/ticker/"

# Aktienkurse abrufen für einen Tag
get_stock_price() {
    SYMBOL=$1
    DATE=$2
    NEXT_DAY=$(date -d "$DATE + 1 day" +%Y-%m-%d)
    URL="${BASE_URL}${SYMBOL}/range/1/day/${DATE}/${NEXT_DAY}?adjusted=true&sort=asc&apiKey=${API_KEY}"
    RESPONSE=$(curl -s "$URL")
    # Überprüfe, ob der API-Aufruf erfolgreich war
    if [ $? -ne 0 ]; then
        echo "Fehler beim Abrufen der Aktienkurse für $SYMBOL"
        exit 1
    fi
    # Preis aus der Antwort extrahieren
    PRICE=$(echo $RESPONSE | grep -o '"c":[0-9.]*' | awk -F':' '{print $2}')
    echo $PRICE
}

# Wechselkurs abrufen
get_exchange_rate() {
    EXCHANGE_RATE=$(./fetch_exchange_rate.sh)
    echo $EXCHANGE_RATE
}

# Anzahl der Aktien berechnen, die pro CHF gekauft werden können
calculate_shares() {
    STOCK_PRICE=$1
    EXCHANGE_RATE=$2
    # Preis in CHF umrechnen
    PRICE_IN_CHF=$(echo "$STOCK_PRICE * $EXCHANGE_RATE" | bc)
    # Anzahl der Aktien berechnen, die man für 1 CHF kaufen kann
    SHARES=$(echo "scale=2; 1 / $PRICE_IN_CHF" | bc)
    echo $SHARES
}

# Hauptteil des Skripts

# Benutzereingabe für das Aktiensymbol und das Startdatum
read -p "Gib das Aktiensymbol ein (z.B. AAPL): " SYMBOL
read -p "Gib das Startdatum (YYYY-MM-DD) ein: " START_DATE

STOCK_PRICE=$(get_stock_price $SYMBOL $START_DATE)
EXCHANGE_RATE=$(get_exchange_rate)
SHARES=$(calculate_shares $STOCK_PRICE $EXCHANGE_RATE)

echo "Aktueller Preis von $SYMBOL: $STOCK_PRICE USD"
echo "Wechselkurs USD zu CHF: $EXCHANGE_RATE"
echo "Anzahl der $SYMBOL Aktien, die man für 1 CHF kaufen kann: $SHARES"
