#!/bin/bash

if [[ $# -eq 0 ]]; then
  echo Input file name needed
  exit 0
fi
infile=$1
converted=0	#=> step2 format

for dir in $( ls -l|awk '/^d/ {print $NF}'|grep $filter )
do
   get_step2-dist-from-anchor.sh 0467_001 $infile $converted 1
done
echo Over
