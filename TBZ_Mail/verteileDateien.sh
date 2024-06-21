#!/bin/bash

# Ensure required directories exist
mkdir -p Docs/logs
mkdir -p emails

# Function to clean names
clean_name() {
    echo "$1" | iconv -f utf8 -t ascii//TRANSLIT | tr -d '[:space:][:punct:]' | tr '[:upper:]' '[:lower:]'
}

# Generate a random password
generate_password() {
    tr -dc 'A-Za-z0-9' </dev/urandom | head -c 12
}

# Create log file
LOGFILE="Docs/logs/$(date '+%Y-%m-%d_%H-%M-%S')_mailimports.csv"
> $LOGFILE

# Read the CSV file and process each line
while IFS=',' read -r id vorname nachname geschlecht strasse hausnummer plz ort; do
    # Clean and format names
    email_vorname=$(clean_name "$vorname")
    email_nachname=$(clean_name "$nachname")
    email="${email_vorname}.${email_nachname}@edu.tbz.ch"
    password=$(generate_password)

    # Append to log file
    echo "${email};${password}" >> $LOGFILE

    # Create email letter
    letter_file="emails/${email}.brf"
    echo "Technische Berufsschule Zürich" > $letter_file
    echo "Ausstellungsstrasse 70" >> $letter_file
    echo "8005 Zürich" >> $letter_file
    echo "" >> $letter_file
    echo "Zürich, den $(date '+%d.%m.%Y')" >> $letter_file
    echo "" >> $letter_file
    echo "                        ${vorname} ${nachname}" >> $letter_file
    echo "                        ${strasse} ${hausnummer}" >> $letter_file
    echo "                        ${plz} ${ort}" >> $letter_file
    echo "" >> $letter_file
    if [ "$geschlecht" = "männlich" ]; then
        echo "Lieber ${vorname}," >> $letter_file
    else
        echo "Liebe ${vorname}," >> $letter_file
    fi
    echo "" >> $letter_file
    echo "Es freut uns, Sie im neuen Schuljahr begrüssen zu dürfen." >> $letter_file
    echo "" >> $letter_file
    echo "Damit Sie am ersten Tag sich in unsere Systeme einloggen" >> $letter_file
    echo "können, erhalten Sie hier Ihre neue Emailadresse und Ihr" >> $letter_file
    echo "Initialpasswort, das Sie beim ersten Login wechseln müssen." >> $letter_file
    echo "" >> $letter_file
    echo "Emailadresse:   ${email}" >> $letter_file
    echo "Passwort:       ${password}" >> $letter_file
    echo "" >> $letter_file
    echo "Mit freundlichen Grüssen" >> $letter_file
    echo "" >> $letter_file
    echo "[IhrVorname] [IhrNachname]" >> $letter_file
    echo "(TBZ-IT-Service)" >> $letter_file
    echo "" >> $letter_file
    echo "admin.it@tbz.ch, Abt. IT: +41 44 446 96 60" >> $letter_file

done < mock_data.csv

# Create the archive file
ARCHIVE_NAME="$(date '+%Y-%m-%d')_newMailadr_YourClass_YourLastName.zip"
zip -r $ARCHIVE_NAME Docs/logs emails

echo "Emails and letters have been generated and archived into $ARCHIVE_NAME."
