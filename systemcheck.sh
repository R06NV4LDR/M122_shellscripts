#!/bin/bash

# Logfile definieren
LOGFILE="system_info.log"

# Funktion zum Loggen und Anzeigen der Informationen
log_and_display() {
    echo -e "$1" | tee -a $LOGFILE
}

# Logdatei leeren
> $LOGFILE

# Datum und Uhrzeit
log_and_display "=============================== SYSTEM INFORMATION =============================="
log_and_display "Datum und Uhrzeit: $(date)"
log_and_display "================================================================================="
log_and_display ""

# Betriebssystem und Kernel-Version
log_and_display "Betriebssystem: $(uname -o)"
log_and_display "Kernel-Version: $(uname -r)"
log_and_display ""

# Hostname und Uptime
log_and_display "Hostname: $(hostname)"
log_and_display "Uptime: $(uptime -p)"
log_and_display ""

# CPU-Informationen
log_and_display "================================ CPU INFORMATION ================================"
log_and_display "$(lscpu | grep -E 'Model name|Socket|Thread|Core|CPU\(s\)|MHz|Cache')"
log_and_display ""

# Speicherinformationen
log_and_display "============================== MEMORY INFORMATION ==============================="
log_and_display "$(free -h)"
log_and_display ""

# Festplattenplatz
log_and_display "================================== DISK USAGE ==================================="
log_and_display "$(df -h --total | grep -E 'Filesystem|total')"
log_and_display ""

# Netzwerkdetails
log_and_display "============================= NETWORK INFORMATION ==============================="
log_and_display "$(ip -4 addr show | grep -E 'inet')"
log_and_display ""

log_and_display "================================================================================="
log_and_display "Logfile wurde erfolgreich erstellt: $LOGFILE"

