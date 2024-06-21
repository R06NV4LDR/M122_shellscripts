#!/bin/bash

# Verzeichnis für Templates erstellen
TEMPLATE_DIR="_templates"
mkdir -p $TEMPLATE_DIR

# Mindestens 3 Dateien im Template-Verzeichnis erstellen
touch $TEMPLATE_DIR/datei-1.txt
touch $TEMPLATE_DIR/datei-2.docx
touch $TEMPLATE_DIR/datei-3.pdf

# Verzeichnis für Schulklassen-Dateien erstellen
SCHULKLASSEN_DIR="_schulklassen"
mkdir -p $SCHULKLASSEN_DIR

# Mindestens 2 Schulklassen-Dateien erstellen und mit mindestens 12 Schülernamen füllen
for class in M122-AP22b M122-AP22c M122-AP22d; do
    cat > $SCHULKLASSEN_DIR/$class.txt <<EOL
Amherd
Baume
Keller
Arslan
Buehler
Camenisch
Müller
Schneider
Fischer
Weber
Meyer
Wagner
EOL
done

echo "Vorlagen und Schulklassen-Dateien wurden erfolgreich erstellt."
