#!/bin/bash

filt="CL_"
if [[ $# -eq 1 ]]; then
  filt=$1
fi

for dir in $(ls -l | awk -v fld="$filt" '/^d/{ if ($NF ~ fld) {print $NF} }')
do
  cd $dir
     echo $dir
     get_keyglu_mfep.sh
  cd ../

done
