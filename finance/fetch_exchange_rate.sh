#!/bin/bash

# Überprüfen, ob genau drei Argumente übergeben wurden
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <amount> <from_currency> <to_currency>"
    exit 1
fi

# Eingabeparameter in Variablen speichern
amount=$1
from_currency=$2
to_currency=$3

# API-Host und Endpunkt
host="api.frankfurter.app"
endpoint="/latest?amount=${amount}&from=${from_currency}&to=${to_currency}"

# Anfrage an die API senden
response=$(curl -s "https://${host}${endpoint}")

# Überprüfen, ob die Anfrage erfolgreich war
if [ $? -ne 0 ]; then
  echo "Fehler bei der Anfrage an die API"
  echo "$(date) - Fehler bei der Anfrage an die API" >> exchange_rate.log
  exit 1
fi

# JSON-Antwort parsen und den Ziel-Wechselkurs extrahieren
rate=$(echo "$response" | grep -oP '"'"${to_currency}"'":\K[0-9.]+')

# Überprüfen, ob der Ziel-Wechselkurs erfolgreich extrahiert wurde
if [ -z "$rate" ]; then
  echo "Fehler beim Extrahieren des Wechselkurses"
  echo "$(date) - Fehler beim Extrahieren des Wechselkurses" >> exchange_rate.log
  exit 1
fi

# Ergebnis anzeigen und in die Log-Datei schreiben
result="${amount} ${from_currency} = ${rate} ${to_currency}"
echo "$result"
echo "$(date) - $result" >> exchange_rate.log
