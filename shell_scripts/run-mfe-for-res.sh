#!/bin/sh
# Cat Chenal @ Gunner lab - 2011-02-11
# Rev:
#
this="`basename $0`"
Usage="Call pattern: $this res-to-mfe.lst\n"

if [ $# -lt 1 ]; then
   echo $Usage;
   exit 0;
fi

`cat $1`| `nawk '{ print "mfe.py "$1" 4.5 0.5 > "$1".mfe" }'` | `sed 's/_\./\./'` > get-mfepy-45.cmd;

#for fldr in "cl0 cl1 cl2 cl3"
#do
#  cp get-mfepy.cmd $fldr/.;
#  cd $fldr;
#  . get-mfepy.cmd;
#  cd../
#done

#grep SUM cl*/*.mfe > cl-runs.sum.mfe
