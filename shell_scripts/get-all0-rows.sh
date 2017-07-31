#!/bin/sh
# Cat Chenal @ Gunner Lab
# rev: 2011-02-11
#
this="`basename $0`"
USAGE="---->  Call: "$this" filename"
#
# Example:  $this afile
#
#  This script outputs rows whose sum is not 0.
#  Thus the input file MUST HAVE the same format as that of fort.38 or sum_crg: 
#  that is column 2 to last can be summed in a meaningful way.
# Result is saved into a file named [input file name].all0
#
extn=".all0"

if [ $# -lt 1 ]
then
    echo "----> "$this" requires a filename"
    echo $USAGE
    exit
fi
if [ !-f $1 ] 
then
    echo "----> $InFile not found."
    echo $USAGE
    exit
fi
nawk '{sum=0; for(n=2;n<=NF;n++){sum+=$n}; {if(sum=0) print}}' $1 > $1$extn

echo ----  $this over ---  Result saved into $1$extn
