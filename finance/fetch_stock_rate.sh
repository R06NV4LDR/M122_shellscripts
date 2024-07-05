#!/bin/bash

# Verzeichnis für Logdateien
LOG_DIR="/home/rooney/Docs/logs/finance"

# Funktion zum Extrahieren des neuesten Wechselkurses aus der Logdatei
fetch_exchange_rate() {
    # Den neuesten Wechselkurs aus der Logdatei holen (letzte Zeile)
    EXCHANGE_RATE=$(tail -n 1 "$LOG_DIR/exchange_CHFUSD.log" | awk '{print $(NF-1)}')
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

    # Überprüfen, ob der API-Aufruf erfolgreich war
    if [ $? -ne 0 ]; then
        echo "Fehler beim Abrufen der Aktienkurse für $SYMBOL"
        exit 1
    fi

    # Preis aus der Antwort extrahieren
    # Hier wird angenommen, dass der Preis in der letzten Zeile von `results` steht
    PRICE=$(echo $RESPONSE | grep -o '"c":[0-9.]*' | tail -n 1 | awk -F':' '{print $2}')

    # Überprüfen, ob der Preis erfolgreich abgerufen wurde
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

# Funktion zum Loggen der Ergebnisse in eine Datei
log_results() {
    SYMBOL=$1
    STOCK_PRICE=$2
    EXCHANGE_RATE=$3
    STOCK_VALUE_CHF=$4
    LOG_FILE="$LOG_DIR/${SYMBOL}_fetch_stock_rate.log"
    # Logdatei aktualisieren mit Datum, Symbol, Preis in USD und Preis in CHF
    echo "$(date +"%Y-%m-%d %H:%M:%S"), $SYMBOL, $STOCK_PRICE USD, $STOCK_VALUE_CHF CHF" >> "$LOG_FILE"
    echo "Logdatei für $SYMBOL wurde aktualisiert: $LOG_FILE"
}

# Hauptteil des Skripts

# Benutzereingabe für das Aktiensymbol und das Startdatum
read -p "Gib das Aktiensymbol ein (z.B. MSFT): " SYMBOL
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

# Ergebnisse in Logdatei schreiben
log_results $SYMBOL $STOCK_PRICE $EXCHANGE_RATE $STOCK_VALUE_CHF
