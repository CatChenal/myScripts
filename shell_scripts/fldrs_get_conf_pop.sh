#!/bin/bash

FLD="CL_ff0"	# CL_1f0 w/u: to get estimate for CL_100
RES="0148"
PT="b"  	#: which occ/respw point to return? b=1st pt, u=last point

apo="CL_000"

RETURN_ALL_CONFS=0
RESA="A"$RES
RESB="B"$RES

if [[ $FLD =~ $apo ]]; then
#   echo 'Like _000'
   dir_list=$(ls -l */$FLD/head3.lst| awk '{ dir=substr($NF, 1, index($NF, "/C")-1); if ($1 ~/^l/) { dir=substr($(NF-2), 1, index($(NF-2), "/C")-1) }}{ print dir }'| egrep -v 'x|c|^E')
else
#   echo 'not Like _000'
   dir_list=$(ls -l */$FLD/head3.lst| awk '{print substr($NF, 1, index($NF, "/C")-1)}'| egrep -v 'x|c|^E|^$' )
fi

for dir in $(echo $dir_list)
do
   cd $dir
      get_conf_pop2.sh $FLD $RESA 0 $PT $RETURN_ALL_CONFS
      get_conf_pop2.sh $FLD $RESB 0 $PT $RETURN_ALL_CONFS
      get_conf_pop2.sh $FLD $RESA 1 $PT $RETURN_ALL_CONFS
      get_conf_pop2.sh $FLD $RESB 1 $PT $RETURN_ALL_CONFS
   cd ../
done

if [[ $RETURN_ALL_CONFS -eq 1 ]]; then
   outname="mostocc_all_"$RES"_totE_"$PT"_"${FLD:3:7}".csv"
else
   outname="mostocc_"$RES"_totE_"$PT"_"${FLD:3:7}".csv"
fi

grepline=" 'tot|"$RES"' "

eval egrep $grepline */$FLD/*$RES"_0_"$PT".csv" */$FLD/*$RES"_1_"$PT".csv" > tmp
sed '/EQ/d; s/\.csv:/\t/; s/R0/i/;s/R1/n/; s/gold/g/; s/3CL//; s/QE/UP/; s/WTnew/WTn/; s/\// /g;' tmp > $outname
/bin/rm tmp
