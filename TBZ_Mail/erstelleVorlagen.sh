#!/bin/bash

# Download the mock data
curl https://haraldmueller.ch/schueler/m122_projektunterlagen/b/MOCK_DATA.csv > mock_data.csv

# Create necessary directories
mkdir -p Docs/logs
mkdir -p emails
