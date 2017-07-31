#!/bin/sh
# Cat Chenal @ Gunner Lab
# rev: 2011-02-11
#
this="`basename $0`"
USAGE="---->  Call: "$this" filename [threshold_value]"
#
# Example:  $this afile 0.25
#
#  This script can be called without a threshold value, then 0.05 is used by default
#  and is applied to the sum of values in all columns but the first.
#  Thus the input file MUST HAVE the same format as that of fort.38 or sum_crg: 
#  that is column 2 to last can be summed in a meaningful way.
# Result is saved into a file named [input file name].non0
#
Min="0.05"

if [ $# -lt 1 ]
then
	echo "----> "$this" requires a filename"
        echo $USAGE
	exit
fi
if [ -f $1 ] 
then
	InFile=$1
else
	echo "----> $InFile not found."
        echo $USAGE
	exit
fi
if [ $# -eq 2 ]
then
	Min=$2
fi
# myvar=`bc <<< "scale=2;(2/3)+(7/8)"`
Min2=`echo "$Min*-1"|bc`

export Min Min2
nawk -v lim1="$Min" -v lim2="$Min2" 'BEGIN{OFS="\t"} {sum=0; for(n=2;n<=NF;n++){sum+=$n};tot=(NF+1);$tot=sum; {if((sum >= lim1)||(sum <= lim2)) print}}' $InFile > $InFile.non0

echo ----  $this over ---  Result saved into $InFile.non0
