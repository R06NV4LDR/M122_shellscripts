#!/bin/bash

# Überprüfen, ob eine Datei als Parameter übergeben wurde
if [ "$#" -ne 1 ]; then
	echo "Usage: $0 <user_group_list>"
	exit 1
fi

user_group_list=$1

# Überprüfen, ob die Datei existiert
if [ ! -f "$user_group_list" ]; then
	echo "File not found: $user_group_list"
	exit 1
fi

# Lesen der Benutzer und Gruppen aus der Datei
while IFS=: read -r username groups; do
	# Überprüfen, ob der Benutzer bereits existiert
	if id "$username" &>/dev/null; then
		echo "User"
