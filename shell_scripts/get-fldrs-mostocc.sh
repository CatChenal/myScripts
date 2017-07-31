#!/bin/bash
if [[ $# -lt 2 ]]; then
  echo "Required arguments: 1: subfldr_start: string; 2 subfldr_end: string. Missing."
  echo "Call: "$0" clusterA 025e4"
  echo "Call: "$0" clusterAB 025e4"
  echo "Call: "$0" sliceA 025e4"
  exit 0
fi
subf_start=$1
subf_end=$2

for fldr in $(ls |grep $subf_start | grep $subf_end)
do
    cd $fldr
#    echo $fldr
    get-mostocc.sh 
  cd ../
done


