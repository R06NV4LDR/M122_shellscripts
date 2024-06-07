#!/bin/bash

# Aktuelles Datum in einer Variablen speichern
current_date=$(date '+%Y-%m-%d %H:%M:%S')
echo "Das aktuelle Datum: $current_date"

# Verzeichnis wechseln
cd ~/scripts/ || { echo "Verzeichnis ~/scripts/ nicht gefunden"; exit 1; }
echo "Change directory to scripts/"

# Pullt Änderungen aus dem Remote Repo
echo "Pull Date: $current_date" >> ~/Docs/logs/autogit.log
git pull

# Änderungen zu git hinzufügen
git add .
echo "Added all to git"

# Commit mit Datum und Nachricht erstellen
commit_msg="$current_date | M122 | Scripts (Auto Update)"
git commit -m "$commit_msg"
echo "Added commit message: $commit_msg"

# Änderungen in das Repository pushen
echo "Push Date: $current_date | Message: $commit_msg" >> ~/Docs/logs/autogit.log
git push


