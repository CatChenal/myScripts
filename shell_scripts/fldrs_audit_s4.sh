#!/bin/bash

if [[ $# -eq 0 ]]; then
  echo "Usage: $(basename $0) : Folder name needed for filtering. Exiting"
  exit 0
fi

fld=$1

skipped_completed=1

for dir in $(ls -l */$fld/run.prm | awk '{ if ($1 ~/^l/) {print substr($(NF-2), 1, index($(NF-2), "/")-1)} else {print substr($NF, 1, index($NF, "/")-1)} }'|egrep -v 'EQ|EA|^c|^x|^$' )
do
   if [[ -f $dir/$fld/fort.38  ]]; then
     echo $dir/$fld ": s4 done"
   else
     echo $dir/$fld ": s4 not done"
   fi
done

