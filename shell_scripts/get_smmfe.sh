#!/bin/bash

file_end=".mfe4.5.csv"
if [[ $# -eq 1 ]]; then
  file_end=$1
fi

CUTOFF=3
if [[ $# -eq 2 ]]; then
  CUTOFF=$2
fi

for CL in $(echo "_CL-1A _CL-1B")
do
  chn=${CL:5:1}

  strAWK=' { if ( ($1 ~ /0107_'$chn'|0148_'$chn'|0445_'$chn'|CL_0..._'$chn'|UM/)||($2>'$CUTOFF') ) {print} } '
#  echo $strAWK

  for CLfile in $(ls $CL*$file_end)
  do
#    echo $CLfile
    conf=${CLfile%%.*}
    awk -v ch="$chn" "$strAWK" $CLfile > $conf".mfesm.csv"
  done
done
