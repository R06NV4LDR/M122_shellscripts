#!/bin/bash

# Aktuelles Datum in einer Variablen speichern
current_date=$(date '+%Y-%m-%d %H:%M:%S')
echo "Das aktuelle Datum: $current_date" >> ~/Docs/logs/autogit.log

# Verzeichnis wechseln
if cd ~/scripts/; then
	echo "Changed directory to ~/scripts/" >> ~/Docs/logs/autogit.log
else
	echo "Couldn't find directory ~/scripts/" >> ~/Docs/logs/autogit.log
	exit 1
fi

# Findet die zuletzt erstellte Datei


last_created_file=$(ls -t | head -n 1)
echo "Last created file: $last_created_file" >> ~/Docs/logs/autogit.log

# Pullt ÃAenderungen aus dem Remote Repo
{
	echo "Pull Date: $current_date"
	git pull
} >> ~/Docs/logs/autogit.log 2>&1


if [ $? -ne 0 ]; then
	echo "Error pulling changes from remote repo" >> ~/Docs/logs/autogit.log
	exit 1
fi


# Aenderungen zu git hinzufuegen
{
	git add .
	echo "Added all changes to git"
} >> ~/Docs/logs/autogit.log 2>&1

if [ $? -ne 0 ]; then
	echo "Error adding changes to git" >> ~/Docs/logs/autogit.log
	exit 1
fi

# Commit mit Datum und und neuestem Skriptnamen erstellen
commit_msg="$current_date | M122 Scripts (Auto Update) | Last File: $last_created_file"
{
	git commit -m "$commit_msg"
	echo "Added commit message: $commit_msg"
} >> ~/Docs/logs/autogit.log 2>&1

if [ $? -ne 0 ]; then
	echo "Error comitting changes" >> ~/Docs/logs/autogit.log
	exit 1
fi

# ÃAenderungen in das Repository pushen
{
	echo "Push Date: $current_date | Message: $commit_msg"
	git push
} >> ~/Docs/logs/autogit.log 2>&1

if [ $? -ne 0 ]; then
	echo "Error pushing changes to remote repo" >> ~/Docs/logs/autogit.log
	exit 1
fi


