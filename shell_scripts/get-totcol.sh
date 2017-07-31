#!/bin/sh
this="`basename $0`"
USAGE="---->  Call: "$this" filename"

# Example:  get-totcol.sh afile
#
#  The input file MUST HAVE the same format as that of fort.38: that is column 2 to last
#  can be summed in a meaningful way.
#
# Result is saved into a file named [input file name].tot
#
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
	echo "---->  "$this" requires a file as input"
        echo $USAGE
	exit
fi

OutFile=$InFile.tot

nawk 'BEGIN{OFS="\t"} {sum=0; for(n=2;n<=NF;n++){sum+=$n};tot=(NF+1);$tot=sum; {print} }' $InFile > $OutFile

echo ----  $this over ---  Result saved into $OutFile
