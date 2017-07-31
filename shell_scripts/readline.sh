#!/bin/bash

#SCRIPT:  method3.sh
#PURPOSE: Process a file line by line with while read LINE using file descriptors

FILENAME=$1
count0=

exec 3<&0
exec 0< $FILENAME

while read LINE
do
  let count++
  echo "$count $LINE"
done
exec 0<&3

echo -e "\nTotal $count Lines read"
