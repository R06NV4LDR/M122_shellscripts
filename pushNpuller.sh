#!/bin/bash

# Aktuelles Datum in einer Variablen speichern
current_date=$(date '+%Y-%m-%d %H:%M:%S')
echo "Das aktuelle Datum: $current_date"

# Verzeichnis wechseln
cd ~/scripts/ || { echo "Verzeichnis ~/scripts/ nicht gefunden"; exit 1; }
echo "Change directory to scripts/"

# Änderungen zu git hinzufügen
git add .
echo "Added all to git"

# Commit mit Datum und Nachricht erstellen
git commit -m "$current_date | M122 | Scripts"
echo "Added commit message"

# Änderungen in das Repository pushen
git push
echo "pushed to git"

# Zeit des Push erfassen und mit Datum in Logfile schreiben
echo "Zeitpunkt des Push: $current_date" >> ~/Docs/logs/autogit.log
