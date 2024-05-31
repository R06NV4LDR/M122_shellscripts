#!/bin/bash

# Netzwerk-Range herausfinden
network=$(ip -o -f inet addr show | awk '/scope global/ {print $4}')

# Scannen des Netzwerks nach aktiven Geräten
echo "Scanning network: $network"
nmap -sn $network

# Ausgabe der aktiven Geräte
echo "Active devices in the network:"
nmap -sP $network | awk '/Nmap scan report for/{printf $5;}/MAC Address:/{print " ("$3")";}'
