#!/bin/bash

# API-Endpunkt und API-Schlüssel (Beispiel: exchangeratesapi.io)
API_ENDPOINT="https://api.exchangeratesapi.io/latest"
BASE_CURRENCY="USD"
TARGET_CURRENCY="EUR"

# Hole die Währungskurse
response=$(curl -s "${API_ENDPOINT}?base=${BASE_CURRENCY}&symbols=${TARGET_CURRENCY}")

# Extrahiere den Kurs
exchange_rate=$(echo $response | jq -r ".rates.${TARGET_CURRENCY}")

# Aktuelles Datum und Uhrzeit
timestamp=$(date "+%Y-%m-%d %H:%M:%S")

# Speichere den Kurs in einer Datei
echo "${timestamp} ${exchange_rate}" >> exchange_rates.txt

# Erzeuge die Grafik mit gnuplot
gnuplot -persist <<-EOFMarker
    set title "Währungskurs ${BASE_CURRENCY} zu ${TARGET_CURRENCY}"
    set xlabel "Zeit"
    set ylabel "Kurs"
    set xdata time
    set timefmt "%Y-%m-%d %H:%M:%S"
    set format x "%H:%M:%S"
    set grid
    plot "exchange_rates.txt" using 1:2 with lines title "Kursverlauf"
EOFMarker
