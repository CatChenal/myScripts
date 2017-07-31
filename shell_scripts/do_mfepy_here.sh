#!/bin/bash

# input = dir_apoEx_mfe
dir_list=$1

for fldr in $(cat $dir_list)
do
   cd $fldr
   echo $fldr
   cd CL_000
      out=$res"mfep"
      mymfe.py GLU-A0148_ 4.5 1 > $out".csv"     # mfe output w/o mV column & crg column
      # get smaller output: pH and kcal/mol cols only:
mymfe.py GLU-A0148_ 4.5 1 |      awk 'BEGIN{IFS="\t"; OFS="\t"}{print $1, $2, $NF}' >  $out"s.csv"

   cd ../
  cd ../
done

