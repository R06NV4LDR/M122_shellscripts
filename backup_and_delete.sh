#!/bin/bash

name=$1_$(date '+%y-%m-%d').tar.gz;
find /home/user1/* -user $1 -exec cp {} /home/user1/Docs/found/ \;
tar -zcvf /home/user1/Docs/found/$name /home/user1/Docs/found/;
find /home/user1/Docs/found/ -type f ! -name $name -delete;
