#!/bin/sh
# Will use subfolders that have fort.38.non0 in it

if [ $# -lt 1 ]; then
  echo "Usage:  res-confs-stat.sh resid1 (e.g. 0148, not just 148) [resid2 ...]"
  exit 0
fi

here=$(pwd)
fldr=$(basename "$here")
fileout="confs.stats.txt"

for fld in $(ls */fort.38.non0 | awk 'str=substr($1, 1 , length($1)- 13 ) {print str}')
do
  cd $fld
#  /bin/rm -f $fileout
#  touch $fileout

  for id in "$@"
  do
     fileid=$id"_"$fileout
     echo $fld - Conformers of $id > $fileid
     printf "%s - ..........\t%s\t%s\n" $fld "cA" "cB" >> $fileid
     printf "%s - Grand-Total:\t%s\t%s\n" $fld $(grep -c A"$id" fort.38) $(grep -c B"$id" fort.38)  >>  $fileid
     printf "%s - Neu:  \t%s\t%s\n" $fld $(grep A"$id" fort.38|grep -c '0.A') $(grep B"$id" fort.38|grep -c '0.B') >>  $fileid
     printf "%s - Crg:  \t%s\t%s\n" $fld $(grep A"$id" fort.38|grep -cv '0.A') $(grep B"$id" fort.38|grep -cv '0.B') >>  $fileid
     printf "%s - Non zero: \t%s\t%s\n" $fld $(grep -c A"$id" fort.38.non0) $(grep -c B"$id" fort.38.non0) >>  $fileid
     printf "%s - Neu:  \t%s\t%s\n" $fld $(grep A"$id" fort.38.non0|grep -c '0.A') $(grep B"$id" fort.38.non0|grep -c '0.B') >>  $fileid
     printf "%s - Crg:  \t%s\t%s\n" $fld $(grep A"$id" fort.38.non0|grep -cv '0.A') $(grep B"$id" fort.38.non0|grep -cv '0.B') >>  $fileid
  done
 # cat $fileid

  cd ../
done
