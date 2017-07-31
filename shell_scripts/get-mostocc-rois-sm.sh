#!/bin/sh
#
# Outputs smaller set of ROIS: delta crg & delta pK in pH3 - 6 range
#
this="`basename $0`"
temp="`pwd`"
fldr="`basename $temp`"
echo "Folder: $fldr"
ALL=0
values=""

if [ $# -eq 0 ]; then
  ALL=1
fi
if [ ! -f "fort.38" ]
  then
    echo "Missing fort.38 (required) in $fldr"
    break               #exit 0
fi
if [ ! -f "fort.38.hdr" ]
  then
    head -1 fort.38 > fort.38.hdr
fi
if [ $ALL ]; then
    values=`cat fort.38.hdr| sed 's/ [pe]h              //'`
else
    values="$@"
    #those ph or eh vals passed as arg
fi
if [[ $fldr = "cl000" ]]; then
    for pH in $values
    do
       infile="$fldr"-occph"$pH".pdb
       outfile="$fldr"-rois"$pH"-sm.pdb
       egrep 'A  54|A 107|A 113|A 117|A 131|A 147|A 148|A 202|A 203|A 414|A 457|A 459|A 175|A 281|A 284|A 445' $infile > $outfile
    done
else
    for pH in $values
    do
       infile="$fldr"-occph"$pH".pdb
       outfile="$fldr"-rois"$pH"-sm.pdb
       CLfile="$fldr"-cl.pdb
       egrep 'A  54|A 107|A 113|A 117|A 131|A 147|A 148|A 202|A 203|A 414|A 457|A 459|A 175|A 281|A 284|A 445' $infile > tmp1
       cat tmp1 $CLfile > $outfile
       
       CLfile=""
    done
    /bin/rm tmp*
 fi

echo "Smaller sets of ROIs created."
