#!/bin/bash
DO_this=1
if [[ $# -lt 2 ]]; then
   echo $(basename  $0) ": To get non 0 occ'y of Ex and CL ions"
   echo "1st arg: start of folder names to process"
   echo "2nd arg: common identifier for outputs"
   exit 0
fi
fldr_start=$1
out_start=$2

for infile in $(ls $1*/fort.38)
do
  fldr=${infile%/fort.38}
  outfile=$out_start"_"$fldr"_occ.csv"
  echo $outfile

  if [[ $DO_this -eq 1 ]]; then

     awk '/ex|ph/{ print FILENAME,$0}; /CL-1|0148/ { for (i=2; i<=NF; i++){ sum+=$i }; { if(sum>0.2){print FILENAME, $0}; sum=0 }}' $infile > $outfile
     sed -i 's/\/fort\.38//' $outfile

  fi
done
