#!/bin/bash

#
API_KEY=""
CITY=""
URL=""


#
RESPONSE=$(curl -s $URL)
echo $RESPONSE > weather.json
