#!/bin/bash

# Pfad zur Logdatei
LOG_FILE="/home/rooney/Docs/logs/finance/exchange_CHFUSD.log"

# Funktion zum Extrahieren des neuesten Wechselkurses aus der Logdatei
fetch_exchange_rate() {
    # Den neuesten Wechselkurs aus der Logdatei holen (letzte Zeile)
    EXCHANGE_RATE=$(tail -n 1 "$LOG_FILE" | awk '{print $(NF-1)}')
    echo $EXCHANGE_RATE
}

# Funktion zum Abrufen des Aktienkurses für einen Tag
get_stock_price() {
    SYMBOL=$1
    DATE=$2
    NEXT_DAY=$(date -d "$DATE + 1 day" +%Y-%m-%d)
    API_KEY="sO4EvJx00lON9Af5H0jnEXlWcKMw1KrI"
    BASE_URL="https://api.polygon.io/v2/aggs/ticker/"
    URL="${BASE_URL}${SYMBOL}/range/1/day/${DATE}/${NEXT_DAY}?adjusted=true&sort=asc&apiKey=${API_KEY}"
    RESPONSE=$(curl -s "$URL")
    # Überprüfe, ob der API-Aufruf erfolgreich war
    if [ $? -ne 0 ]; then
        echo "Fehler beim Abrufen der Aktienkurse für $SYMBOL"
        exit 1
    fi
    # Preis aus der Antwort extrahieren
    PRICE=$(echo $RESPONSE | grep -o '"c":[0-9.]*' | awk -F':' '{print $2}')
    if [ -z "$PRICE" ]; then
        echo "Fehler: Aktienkurs für $SYMBOL konnte nicht abgerufen werden."
        exit 1
    fi
    echo $PRICE
}

# Funktion zum Berechnen des Aktienwerts in CHF
calculate_stock_value_in_chf() {
    STOCK_PRICE_USD=$1
    EXCHANGE_RATE=$2
    STOCK_VALUE_CHF=$(echo "$STOCK_PRICE_USD * $EXCHANGE_RATE" | bc)
    echo $STOCK_VALUE_CHF
}

# Hauptteil des Skripts

# Benutzereingabe für das Aktiensymbol und das Startdatum
read -p "Gib das Aktiensymbol ein (z.B. AAPL): " SYMBOL
read -p "Gib das Startdatum (YYYY-MM-DD) ein: " START_DATE

# Wechselkurs aus der Logdatei holen
EXCHANGE_RATE=$(fetch_exchange_rate)

# Aktienkurs für den angegebenen Tag holen
STOCK_PRICE=$(get_stock_price $SYMBOL $START_DATE)

# Prüfen, ob der Aktienkurs erfolgreich abgerufen wurde
if [ -z "$STOCK_PRICE" ]; then
    echo "Fehler: Aktienkurs für $SYMBOL konnte nicht abgerufen werden."
    exit 1
fi

# Wert einer Aktie in CHF berechnen
STOCK_VALUE_CHF=$(calculate_stock_value_in_chf $STOCK_PRICE $EXCHANGE_RATE)

echo "Aktueller Preis von $SYMBOL: $STOCK_PRICE USD"
echo "Letzter bekannter Wechselkurs CHF zu USD: $EXCHANGE_RATE"
echo "Wert einer $SYMBOL Aktie in CHF: $STOCK_VALUE_CHF"
