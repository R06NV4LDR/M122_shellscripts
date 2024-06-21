#!/bin/bash

# Logfile definieren
LOG_DIR="Docs/log"

LOGFILE="$LOG_DIR/$(date '+%Y-%m')-sys-$(hostname).log"

# Funktion zum Loggen und Anzeigen der Informationen
# If für optionales Logfile
echo "$0 $1"
log_and_display() {
	if [ "$1" = "file" ]; then
    		printf "$1\n" | tee -a $LOGFILE
	else
		printf "$1\n"
	fi
}

TO_FILE="false"
if [ "$1" = "-f" ]; then
	TO_FILE="true"

fi

# Logdatei leeren
>> $LOGFILE

# Datum und Uhrzeit
log_and_display "==================================== SYSTEM INFORMATION ================================="
log_and_display "Datum und Uhrzeit: $(date)"
log_and_display "========================================================================================="
log_and_display ""

# Betriebssystem und Kernel-Version
log_and_display "Betriebssystem: $(uname -o)"
log_and_display "Kernel-Version: $(uname -r)"
log_and_display ""

# Hostname, IP & Uptime
log_and_display "Hostname: $(hostname)"
log_and_display "IP-Adresse: $(hostname -I | awk '{print $1}')"
log_and_display "Uptime: $(uptime -p)"
log_and_display ""

# CPU-Informationen
log_and_display "==================================== CPU INFORMATION ===================================="
log_and_display "Modellname der CPU: $(lscpu | grep 'Model name:' | awk -F: '{print $2}' | sed 's/^ *//')"
log_and_display "Anzahl der CPU-Cores: $(lscpu | grep '^CPU(s):' | awk -F: '{print $2}' | sed 's/^ *//')"
log_and_display ""

# Speicherinformationen
log_and_display "=================================== MEMORY INFORMATION =================================="
log_and_display "Gesamter Arbeitsspeicher: $(free -h | awk '/^Mem:/ {print $2}')"
log_and_display "Genutzter Arbeitsspeicher: $(free -h | awk '/^Mem:/ {print $3}')"
log_and_display ""

# Festplattenplatz
log_and_display "====================================== DISK USAGE ======================================="
log_and_display "Belegter Speicher auf dem Dateisystem: $(df -h --total | grep 'total' | awk '{print $3}')"
log_and_display "Freier Speicher auf dem Dateisystem: $(df -h --total | grep 'total' | awk '{print $4}')"
log_and_display ""

# Netzwerkdetails
log_and_display "=================================== NETWORK INFORMATION ================================="
log_and_display "$(ip -4 addr show | grep -E 'inet' | sed 's/^/    /')"
log_and_display ""

log_and_display "========================================================================================="
if [ "$TO_FILE" = "true" ]; then
	log_and_display "Logfile wurde erfolgreich erstellt: $LOGFILE"
fi
