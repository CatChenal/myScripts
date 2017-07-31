#!/bin/bash
if [[ $# -lt 1 ]]; then
  echo "Required arguments: 1: subfldr_start: string; 2 subfldr_end: string. Missing."
  echo "Call: "$0" <subfldr name>"
  exit 0
fi
subf_start=$1
pH="4.5"

  for fldr in $(ls -l | grep '^d' | grep $subf_start|awk '{print $NF}')
  do
    echo $fldr
    cd $fldr
#    get-mostocc.sh $pH
    cd ../
  done
