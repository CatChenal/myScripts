#!/bin/sh

if [ $# -eq 0 ]; then
  echo "Usage: At least 1 residue number is required (e.g. 0054)"
  exit 0
fi

for fldr in `ls -l | grep '^d'|awk '{print $NF}'`
do
  cd $fldr
  echo Folder: $fldr

  if [ ! -f "fort.38" ]
  then
    echo "Missing fort.38 (required) in $fldr"
    break 
  fi

  for res in "$@"
  do
    res-confs-stats.sh "$res" > "$fldr"-"$res"-confs.csv
  done  

  cd ../
done
