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
        echo "User $username already exists."
    else
        sudo useradd "$username" -m -s /bin/bash
        if [ $? -eq 0 ]; then
            echo "User $username created successfully."
        else
            echo "Failed to create user $username."
            continue
        fi
    fi
    
    # Hinzufügen des Benutzers zu den Gruppen
    IFS=',' read -ra groups_array <<< "$groups"
    for group in "${groups_array[@]}"; do
        if grep -q "^$group:" /etc/group; then
            sudo usermod -aG "$group" "$username"
            if [ $? -eq 0 ]; then
                echo "User $username added to group $group."
            else
                echo "Failed to add user $username to group $group."
            fi
        else
            sudo groupadd "$group"
            if [ $? -eq 0 ]; then
                sudo usermod -aG "$group" "$username"
                echo "User $username added to new group $group."
            else
                echo "Failed to create group $group and add user $username."
            fi
        fi
    done
done < "$user_group_list"
