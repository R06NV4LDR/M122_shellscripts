#!/bin/bash

for group in $(cat $1); do
	groupadd -f $group | usermod -a -G $group $2 #$2 ist username
done

