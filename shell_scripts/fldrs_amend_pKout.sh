#!/bin/bash
# Purpose:  To correct pKout format
# ARG1: subfolder_str for filtering
# ----------------------------------

filt="CL_"

fld_list=$(ls -l */*/pK.out | awk -v str="$filt" '{ if ($NF ~ str) {print substr($NF, 1, index($NF, "/p")-1) } }')

for fldr in $(echo $fld_list)
do
  cd $fldr

   ## check formatting in pK.out:
   amend_pKout.sh

  cd ../../
done
