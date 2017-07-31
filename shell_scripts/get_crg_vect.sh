#!/bin/bash

for dir in $(ls -l */CL_000/sum_crg.out |awk '{if ($1 ~/^l/){name=$(NF-2)} else {name=$NF}; {print substr(name, 1, index(name, "/C")-1)} }' | egrep -v 'pH|-2|_new|1new')
do
   echo $dir
   if [[ $(grep 'ch extra' $dir/CL_000/sum_crg.out &> /dev/null) -ne 0 ]]; then # not amended
      sed -i 's/ extra   /ch extra/' $dir/CL_000/sum_crg.out
   fi

   out=$dir"_apo_crg_v2.csv"
   awk '{print substr(FILENAME,1,index(FILENAME, "/")-1), $1,$2, $4}' $dir/CL_000/sum_crg.out > $out

done
