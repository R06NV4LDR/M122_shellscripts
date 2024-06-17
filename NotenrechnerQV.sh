#!/bin/bash

cd ~ || exit

log_file=~/Docs/logs/NotenrechnerQV.log

echo "" >> "$log_file"

log_message() {
	local message="$1"
	echo -e "$(date '+%Y-%m-%d %H:%M:%S') - $message" >> "$log_file"
}

log_message "Current directory: $(pwd)"
log_message "Log file path: $log_file"


# Funktion zur Berechnung des Durchschnitts
calculate_weighted_average() {
	local total=0
	local weight=0

	while [[ $# -gt 0 ]]; do
		local grade=$1
		local grade_weight=$2
		total=$(echo "$total + ($grade * $grade_weight)" | bc -l)
		weight=$(echo "$weight + $grade_weight" | bc -l)
		shift 2
	done


	if ["$weight" == "0"]; then
		echo "0"
	else
		echo "scale=2; $total / $weight" | bc -l
	fi
}


# Noteneingabe
log_message "Starting grade input process..."

echo "Enter the average grade for überbetriebliche Kurse (rounded to 1/2):"
read ueberbetriebliche_kurse_average
log_message "Entered überbetriebliche Kurse average: $ueberbetriebliche_kurse_average"

echo "Enter the average grade for Berufsschule Informatikkompetenzen (rounded to 1/2):"
read informatikkompetenzen_average
log_message "Entered Informatikkompetenzen average: $informatikkompetenzen_average"

echo "Enter the average grade for Berufsschule erweiterte Grundkompetenzen (rounded to 1/2):"
read berufsschule_erweiterte_grundkompetenzen
log_message "Entered erweiterte_grundkompetenzen average: $berufsschule_erweiterte_grundkompetenzen"

echo "Enter the grade for Dokumentation (rounded to 1/2):"
read dokumentation
log_message "Entered Dokumentation grade: $dokumentation"

echo "Enter the grade for Fachgespräch und Präsentation (rounded to 1/2):"
read fachgesprach_und_praesentation
log_message "Entered Fachgespräch und Präsentation grade: $fachgesprach_und_praesentation"

echo "Enter the grade for Resultat der Arbeit (rounded to 1/2):"
read resultat_der_arbeit
log_message "Entered Resultat der Arbeit grade: $resultat_der_arbeit"

# Berechnet die Durchschnitte der einzelnen Kategorien
praktische_arbeit=$(calculate_weighted_average $resultat_der_arbeit 0.5 $dokumentation 0.25 $fachgesprach_und_praesentation 0.25)
log_message "Calculated praktische Arbeit grade : $praktische_arbeit"

erfahrungsnote_informatik=$(calculate_weighted_average $informatikkompetenzen_average 0.8 $ueberbetriebliche_kurse_average 0.2)
log_message "Calculated Erfahrungsnote Informatik average: $erfahrungsnote_informatik"

erweiterte_grundkompetenzen=$(echo "scale=2; $berufsschule_erweiterte_grundkompetenzen" | bc -l)
log_message "Calculated erweiterte Grundkompetenzen average: $erweiterte_grundkompetenzen"

# Berechnet den Gesamtdurchschnitt
final_average=$(calculate_weighted_average $praktische_arbeit 0.5 $erfahrungsnote_informatik 0.375 $erweiterte_grundkompetenzen 0.125)

# Output the results
echo "Erfahrungsnote «erweiterte Grundkompetenzen»: $erweiterte_grundkompetenzen"
# echo Qualifikationsbereich Allgemeinbildung: $allgemeinbildung
echo "Praktische Arbeit als IPA: $praktische_arbeit"
echo "Finaler Notenschnitt: $final_average"

# Log final output to file
echo "$(date '+%Y-%m-%d %H:%M:%S')" >> "$log_file"
echo "Final grades" >> "$log_file"
echo "	├── erweiterte Grundkompetenzen: $erweiterte_grundkompetenzen" >> "$log_file"
echo "	│	├── Mathematik: -----" >> "$log_file"
echo "	│	└── Englisch:   -----" >> "$log_file"
echo "	├── praktische Arbeit als IPA: $praktische_arbeit" >> "$log_file"
echo "	│	├── Resultat der Arbeit: $resultat_der_arbeit" >> "$log_file"
echo "	│	├── Fachgespräch und Präsentation: $fachgesprach_und_praesentation" >> "$log_file"
echo "	│	└── Dokumentation: $dokumentation" >> "$log_file"
echo "	└── Final average: $final_average" >> "$log_file"


