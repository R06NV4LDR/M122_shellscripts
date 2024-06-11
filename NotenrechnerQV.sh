#!/bin/bash

# Funktion zur Berechnung des Durchschnitts
calculate_weighted_average() {
	local total=0
	local weight=0

	while [[ $# -gt 0 ]]; do
		local grade=$1
		local grade_weight$2
		total=$(echo "$total + ($grade * $grade_weight)" | bc)
		weight=$(echo "$weight + $grade_weight" | bc)
		shift 2
	done

	echo "scale=2; $total / $weight" | bc
}

# Noteneingabe
echo "Enter the average grade for überbetriebliche Kurse (rounded to 1/2):"
read ueberbetriebliche_kurse_average

echo "Enter the average grade for Berufsschule Informatikkompetenzen (rounded to 1/2):"
read informatikkompetenzen_average

echo "Enter the average grade for Berufsschule erweiterte Grundkompetenzen (rounded to 1/2):"
read berufsschule_erweiterte_grundkompetenzen

echo "Enter the grade for Dokumentation (rounded to 1/2):"
read dokumentation

echo "Enter the grade for Fachgespräch und Präsentation (rounded to 1/2):"
read fachgesprach_und_praesentation

echo "Enter the grade for Resultat der Arbeit (rounded to 1/2):"
read resultat_der_arbeit

# Berechnet die Durchschnitte der einzelnen Kategorien
praktische_arbeit=$(calculate_weighted_average $resultat_der_arbeit 0.5 $dokumentation 0.25 $fachgespraech_und_praesentation 0.25)
erfahrungsnote_informatik=$(calculate_weighted_average $informatikkompetenzen_average 0.8 $ueberbetriebliche_kurse_average 0.2)
erweiterte_grundkompetenzen=$(echo "scale=2; $berufsschule_erweiterte_grundkompetenzen" | bc)

# Berechnet den Gesamtdurchschnitt
final_average=$(calculate_weighted_average $praktische_arbeit 3 $erfahrungsnote_informatik 3 $erweiterte_grundkompetenzen 2 $allgemeinbildung 2)


# Output the results
echo "Erfahrungsnote «erweiterte Grundkompetenzen»: $erweiterte_grundkompetenzen"
echo "Qualifikationsbereich Allgemeinbildung: $allgemeinbildung"
echo "Praktische Arbeit als IPA: $praktische_arbeit"
echo "Finaler Notenschnitt: $final_average"
