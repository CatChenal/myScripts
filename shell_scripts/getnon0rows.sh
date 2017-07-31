#!/bin/bash
this=$(basename $0)
USAGE="---->  Call: "$this" filename [threshold_value; 1st_numerical_col]"
# Example:  getnon0rows.sh afile 0.25 3
#  This script can be called without a threshold value, then 0.000 is used by default
#  and is applied to the sum of values in all columns but the first.
#  The input file format must be either that of fort.38 or respair.lst.
#  The threshold value on fort.38 is applied to the sum of occ across the
#  pH range, while on respair.lst, it is applied on pairwise column.
# If a row contains the word SUM it it is output w/o cuttoff check.
# Result is saved into a file named [input file name].non0
#
if [ $# -eq 0 ]; then
	echo "----> "$this" requires a filename"
        echo $USAGE
	exit
fi
if [ -f $1 ]; then
	InFile=$1
else
	echo "---->  "$this" requires a file as input"
        echo $USAGE
	exit
fi
Min="0.000"; col1=2
if [ $# -eq 3 ]; then
 echo $2
echo $3
  Min=$(printf "%6.3f" $2)
  col1=$3
elif [ $# -eq 2 ]; then
  Min=$(printf "%6.3f" $2)
fi
#echo "First numeric col: " $col1

# String comparison because numeric one only works on integers:
if [ "$Min" == "0.000" ]; then
  Min2=$Min
#  echo "inputfile: "$1"; cutoff: zero values excluded"
else
  Min2=$(printf "%6.3f" $(echo "scale=3; $Min*-1"|bc));
#  echo "inputfile: "$1"; cutoff: "$Min2" to "$Min
fi
if [[ $1 == "respair.lst" ]]; then
  if [ "$Min" == "0.000" ]; then
    nawk 'BEGIN{OFS="\t"} { if (NR > 1) { if($5 != 0) print } }' $InFile|sort > $InFile.non0
  else
    nawk -v lim1="$Min" -v lim2="$Min2" 'BEGIN{OFS="\t"} { if (NR > 1) { if(($5 >= lim1)||($5 <= lim2)) print }}' $InFile|sort > $InFile.non0
  fi
elif [[ $1 == "acc.res" ]]; then
  if [ "$Min" == "0.000" ]; then
    nawk 'BEGIN{OFS="\t"} { sum=($4+$5) }; { if($sum != 0) print }' $InFile > $InFile.non0
  else
    # last 2 cols have values
    nawk -v lim1="$Min" -v lim2="$Min2" 'BEGIN{OFS="\t"} {sum=0; sum=($4+$5)}; {if((sum >= lim1)||(sum <= lim2)) print}' $InFile > $InFile.non0
  fi
elif [[ $1 == "acc.atm" ]]; then
  if [ "$Min" == "0.000" ]; then
    nawk 'BEGIN{OFS="\t"} { if($NF != 0) print }' $InFile > $InFile.non0
  else
    # last col has values
    nawk -v lim1="$Min" -v lim2="$Min2" 'BEGIN{OFS="\t"} {if(($NF >= lim1)||($NF <= lim2)) print}' $InFile > $InFile.non0
  fi
else
  if [ "$Min" == "0.000" ]; then
    nawk -v col="$col1" 'BEGIN{OFS="\t"};{ if( ($1~/SUM/)||($2~/SUM/) ){print} else {sum=0; for(n=col;n<=NF;n++){sum+=$n}; {if(sum != 0) print}} }' $InFile > $InFile.non0
  else
    nawk -v col="$col1" -v lim1="$Min" -v lim2="$Min2" 'BEGIN{OFS="\t"}
         { if( ($1~/SUM/)||($2~/SUM/) ){print} else {sum=0; for(n=col;n<=NF;n++){sum+=$n}; {if((sum >= lim1)||(sum <= lim2)) print}} }' $InFile > $InFile.non0

## This line outputs sum as an extra field:
#    nawk -v col="$col1" -v lim1="$Min" -v lim2="$Min2" 'BEGIN{OFS="\t"}; \
#        { if( ($1~/SUM/)||($2~/SUM/) ){print} else {sum=0; for(n=col;n<=NF;n++){sum+=$n};$(NF+1)=sum; {if((sum >= lim1)||(sum <= lim2)) print}} }' $InFile > $InFile.non0
  fi
fi

if [[ ! -s $InFile.non0 ]]; then
  echo $this "over --- No result with threshold (+-)" $Min
  /bin/rm $InFile.non0
fi
