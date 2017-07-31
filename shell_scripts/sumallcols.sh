#!/bin/bash
# NOTE:
# CALLS this other script: getcoltotal.sh
# ASSUMES first column is descriptive (not totalled)
#
E_WRONGARGS=85

if [ $# -lt 1 ]
then
   echo "Usage: `basename $0` filename [header]"
   exit $E_WRONGARGS
fi

flds=$(awk 'NR==1 {print NF}' $1)

hdr=""
if [ $# -eq 2 ]
then
   hdr=$2
fi

strout="Total:          "

for (( i=2; i <=$flds; i++ ))
do
    getcoltotal.sh $1 $i $hdr > c$i.sumtot
    strout=$strout" "$(cat c$i.sumtot)
done
echo $strout
/bin/rm c*.sumtot

