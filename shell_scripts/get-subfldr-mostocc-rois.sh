#!/bin/sh

if [ $# -eq 0 ]; then   # do all titration points
   set `cat fort.38.hdr| sed 's/ [pe]h              //'`
fi

for fldr in `ls -l | grep '^d'|awk '{print $NF}'| grep '^cl'`
do
  cd $fldr
  CLfile="$fldr"-cl.pdb
  if [ ! -f "$CLfile" ]; then
   touch $CLfile
  fi
  
  for pH in $@
    do
       infile="$fldr"-occph"$pH".pdb.PDB
       outfile="$fldr"-rois"$pH".pdb
       egrep 'A  27|A  54|A 107|A 111|A 113|A 117|A 131|A 147|A 148|A 172|A 175|A 202|A 203|A 234|A 246|A 278|A 281|A 357|A 385|A 414|A 445|A 457|A 459' $infile > tmp1
       cat tmp1 $CLfile > $outfile       
    done
    /bin/rm tmp*
    CLfile=""

  cd ../
done
echo "Over!"

