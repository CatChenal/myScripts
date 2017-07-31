#!/bin/sh
# For 3cl runs only
#
if [ $# -eq 0 ]; then
  echo "========>  Missing pH/eH point at which to retrieve a crg-pK-Net vector."
  exit 0
fi
pH=$1
Col=1

for fldr in `ls -l | grep '^d'|awk '{print $NF}'`
do

  cd $fldr

  head -1 cl000/fort.38 > 38.hdr

  export pH
  awkscript='{ for(n=2;n<=NF;n++) {if ( $n == col ) print n} }'
  Col=`nawk -v col="$pH" "$awkscript" "38.hdr"`

 # echo "Column for pH$1: $Col"
 
  export Col
  egrep 'Net|0148|0203' cl*/sum_crg.out | nawk -v c="$Col" '{ print $1"\t"$c }'|sed 's/\/sum_crg.out:/\tcrg\t/' > $fldr-GLUs-crg-ph$pH.csv;
  egrep '0148|0203' cl*/pK.out|awk '{print $1"\t"$2"\t"$NF}'|sed 's/\/pK.out:/\tpK\t/' > $fldr-GLUs-pK-ph$pH.csv;

  /bin/rm 38.hdr
  cd ../

done
