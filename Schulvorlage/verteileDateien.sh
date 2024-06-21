#!/bin/bash

# Verzeichnisse definieren
TEMPLATE_DIR="_templates"
SCHULKLASSEN_DIR="_schulklassen"
OUTPUT_DIR="gen"

# Sicherstellen, dass das Ausgabe-Verzeichnis existiert
mkdir -p $OUTPUT_DIR

# Alle Schulklassen-Dateien verarbeiten
for class_file in $SCHULKLASSEN_DIR/*.txt; do
    # Klassenname aus dem Dateinamen extrahieren (ohne .txt)
    class_name=$(basename "$class_file" .txt)
    class_dir="$OUTPUT_DIR/$class_name"
    
    # Verzeichnis für die Klasse erstellen
    mkdir -p "$class_dir"
    
    # Schülernamen aus der Datei lesen und für jeden Schüler ein Verzeichnis erstellen
    while read -r student; do
        student_dir="$class_dir/$student"
        mkdir -p "$student_dir"
        
        # Dateien aus dem Template-Verzeichnis in das Schülerverzeichnis kopieren
        cp $TEMPLATE_DIR/* "$student_dir/"
    done < "$class_file"
done

echo "Dateien wurden erfolgreich verteilt."
