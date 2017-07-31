#!/bin/bash
# To obtain the conf_id of the most occupied conf of the given residue number (nnnn) at the given pH/eH point [show_occ (0/1)]

RES=$1
mostocc=""
awkscript1=""
awkscript2=""
occ=0
pH=""
Col=""

if [ $# -lt 2 ]; then
  echo `basename $0`"Two arguments needed: residue number (nnnn) and pH/eH point; [show_occ_value: 0 or 1]."
  exit 0
else
  pH=$2
fi
if [ $# -eq 3 ]; then
  occ=$3
fi

#  export pH
  awkscript1='{ for(n=2;n<=NF;n++) {if ( $n == col ) print n} }'
  Col=`head -1 fort.38 | awk -v col="$pH" "$awkscript1"`
  awkscript1=""
echo "Col for given pH"$pH": "$Col

  awkscript1='{ print $1"\t"$col }'
  awkscript2='NR==1 {print $1}'
#    export Col
if [ $occ -eq 0 ]; then
  mostocc=`grep "$RES" fort.38 |awk -v col="$Col" "$awkscript1" |sort -r -k2|awk "$awkscript2"`
else
  mostocc=`grep "$RES" fort.38 |awk -v col="$Col" "$awkscript1" |sort -r -k2|awk 'NR==1 {print}'`
fi
echo $mostocc
