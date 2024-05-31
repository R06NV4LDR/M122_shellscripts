#!/bin/bash

# Überprüfen, ob ein Benutzername als Parameter übergeben wurde
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

username=$1

# Löschen des Benutzers und seines Home-Verzeichnisses
sudo userdel -r "$username"

# Finde und lösche alle anderen Dateien, die dem Benutzer gehören
sudo find / -user "$username" -exec rm -rf {} \;

echo "User $username and all associated files have been deleted."
