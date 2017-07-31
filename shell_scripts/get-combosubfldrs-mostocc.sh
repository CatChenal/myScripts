#!/bin/bash
if [[ $# -lt 2 ]]; then
  echo "Required arguments: 1: subfldr_start: string; 2: output_id. Missing."
  echo "Call: "$0" <subfldr name>"
  exit 0
fi
subf_start=$1
pH="4.5"

for fldr in $(ls -l | grep '^d' | grep $subf_start|awk '{print $NF}')
do
  echo $fldr
  cd $fldr
  for subfldr in $(ls -l|grep ^d|grep cl |awk '{print $NF}')
  do
    echo $subfldr
    cd $subfldr
       get-mostocc.sh $pH
       Outfile=$subfldr"_"$pH".PDB"
       mv $Outfile ../$2"_"$Outfile
    cd ../
  done

  cd ../
done
