#!/bin/bash
# 2012-Feb-16 to filter respair.lst
# for rendering in pymol: entries are mostly <0.5 +
# reformatted so that it's the same as hb.txt
if [ $# -eq 0 ]; then
   read -p "Enter a folder name (or part of it) to select folders to process: " filt
else
   filt=$1
fi
for fldr in $(ls -l | awk -v str="$filt" '/^d/{ if ($NF ~ str) {print $NF} }')
do
  cd $fldr

  if [ -f "respair.lst" ]; then
     echo $fldr
     if [ ! -f "respair.lst.non0" ]; then
        getnon0rows.sh respair.lst 0.05
     fi
     sed -e '/residue/d' -e 's/\([A-Z]\)[+|-]/\1/'  -e 's/\([0-9]\)_/\1/g' respair.lst.non0 | awk '{print $1"\t"$2"\t"$5}' > $fldr-net-respair.lst
  else
    echo $fldr": no respair.lst"
  fi

  cd ../
done

