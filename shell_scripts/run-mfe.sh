#!/bin/sh
# Cat Chenal @ Gunner lab - 2011-07-1
# Rev:
#
this="`basename $0`"
Usage="Call pattern: $this get-mfepy.cmd-file\n"

if [ $# -lt 1 ]; then
   echo $Usage;
   exit 0;
fi

for fldr in `ls -l | grep '^d'|awk '{print $NF}'`
do
  cd $fldr;
	echo $fldr
  cp ../$2 .;
  `. $2`
  cd ../
done

grep TOTAL cl*/*.mfe > cl-runs-tot.mfe; sed -i 's/  sum_crg//' cl-runs-tot.mfe
