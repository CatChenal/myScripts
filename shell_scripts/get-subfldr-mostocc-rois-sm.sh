#!/bin/sh
#
# Outputs smaller set of ROIS: delta crg & delta pK in pH3 - 6 range
#
if [ $# -lt 1 ]; then   # do all titration points
   set `cat fort.38.hdr| sed 's/ [pe]h              //'`
fi

for fldr in `ls -l | grep '^d'|awk '{print $NF}'`
do
  cd $fldr

  if [ "$fldr" = "cl000" ]; then
    for pH in "$@"
    do
       infile="$fldr"-occph"$pH".pdb
       outfile="$fldr"-rois"$pH"-sm.pdb
       egrep 'A  54|A 103|A 113|A 117|A 147|A 148|A 203|A 357' $infile > $outfile
    done
  else
    for pH in "$@"
    do
       infile="$fldr"-occph"$pH".pdb
       outfile="$fldr"-rois"$pH"-sm.pdb
       CLfile="$fldr"-cl.pdb
       egrep 'A  54|A 103|A 113|A 117|A 147|A 148|A 203|A 357' $infile > tmp1
       cat tmp1 $CLfile > $outfile
       
       CLfile=""
    done
    /bin/rm tmp*
  fi

  cd ../
done
echo "Smaller sets of ROIs created."
