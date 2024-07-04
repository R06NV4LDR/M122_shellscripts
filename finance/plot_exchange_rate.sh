#!/bin/bash

# Funktion zur Erzeugung der ASCII-Grafik
draw_chart() {
  local -n data=$1
  local min=${data[0]}
  local max=${data[0]}
  local width=50
  local height=10

  # Min und Max finden
  for value in "${data[@]}"; do
    if (( $(echo "$value < $min" | bc -l) )); then min=$value; fi
    if (( $(echo "$value > $max" | bc -l) )); then max=$value; fi
  done

  # Daten normalisieren und in eine Zeichenreihe konvertieren
  local -a normalized
  for value in "${data[@]}"; do
    normalized+=($(normalize $value $min $max))
  done

  # Grafik zeichnen
  for ((i=0; i<height; i++)); do
    for norm in "${normalized[@]}"; do
      if (( $(echo "$norm > (1 - $i / $height)" | bc -l) )); then
        printf "#"
      else
        printf " "
      fi
    done
    echo
  done

  echo "Min: $min, Max: $max"
}

# Funktion zur Normalisierung der Daten
normalize() {
  local value=$1
  local min=$2
  local max=$3
  echo "scale=2; ($value - $min) / ($max - $min)" | bc -l
}

# Log-Datei mit Wechselkursdaten
log_file="exchange_rate.log"

# Array zum Speichern der Wechselkurse
declare -a rates

# Daten aus der Log-Datei lesen und Wechselkurse extrahieren
while IFS= read -r line; do
  # Extrahieren des Wechselkurses aus der Zeile
  rate=$(echo "$line" | awk '{print $(NF-1)}')
  
  # Prüfen, ob die Zeile den erwarteten Wechselkurs enthält
  if [[ "$rate" =~ ^[0-9]+\.[0-9]+$ ]]; then
    rates+=("$rate")
  fi
done < "$log_file"

# Grafik der Wechselkurse im Terminal anzeigen
draw_chart rates
