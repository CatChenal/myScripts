#!/bin/bash

RES=$1
pH=$2
Col=1
awkscript=""


 # Get column number from given ph/eh:
 export pH
 awkscript='{ for(n=2;n<=NF;n++) {if ( $n == col ) print n} }'

for fldr in `echo cl000 cl001 cl010 cl011 cl100 cl101 cl110 cl111`
do
 cd $fldr
 head -1 fort.38 > fort.38.hdr
 Col=`nawk -v col="$pH" "$awkscript" "fort.38.hdr"`
 echo "$fldr - $RES"
 # Get confs of RES at given pH & get non0 confs:
 export Col
 grep $RES fort.38 | nawk -v col="$Col" '{ print $1"\t"$col }' | grep -v 0.000 > $fldr-$RES-occ-ph$pH.csv
 
 cd ../
done
