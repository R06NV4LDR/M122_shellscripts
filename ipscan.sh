#!/bin/bash
# Get all network interfaces except loopback
for i in $(ifconfig | grep -E "inet (addr:)?[0-9]+\.[0-9]+\.[0-9]+\." | grep -v "127.0.0.1" |
          awk '{print $2}' | cut -d ':' -f 2 | cut -d '.' -f 1-3); do
  for k in $(seq 1 255); do
      if fping -c 1 -t 250 "$i.$k" 2>&1 | grep -q " 0% "; then
          echo "$i.$k" >> ips.txt
      fi
  done
done
