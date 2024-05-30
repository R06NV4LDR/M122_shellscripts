#!/bin/bash

# Überprüfen, ob eine Datei als Parameter übergeben wurde
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <userlist>"
    exit 1
fi

userlist=$1

# Überprüfen, ob die Datei existiert
if [ ! -f "$userlist" ]; then
    echo "File not found: $userlist"
    exit 1
fi

# Lesen der Benutzernamen aus der Datei und hinzufügen der Benutzer
while IFS= read -r username; do
    # Überprüfen, ob der Benutzer bereits existiert
    if id "$username" &>/dev/null; then
        echo "User $username already exists."
    else
        sudo useradd "$username"
        if [ $? -eq 0 ]; then
            echo "User $username created successfully."
        else
            echo "Failed to create user $username."
        fi
    fi
done < "$userlist"
