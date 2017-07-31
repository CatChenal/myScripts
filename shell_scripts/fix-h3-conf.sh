#!/bin/bash
# Cat Chenal @ Gunner lab - 2010-12-29
#
LINE1='Call pattern: fix-h3-conf.sh conf t(f) [new_occ]'
LINE2='          > : conf is either an exact conf_name or a portion thereof (or a regex): e.g. "DM" would affect ALL dummies'
LINE3='          > : t argument means FL=t and occ=1.000 (or new_occ if provided)'
LINE4='          > : f argument means FL=f and occ=0.000 (or new_occ if provided)'

if [ $# -lt 2 ]; then
   echo "$LINE1"
   echo "$LINE2"
   echo "$LINE3"
   echo "$LINE4"
   exit 0
fi

h3="head3.lst"
if [ -f $h3 ]; then
    cp $h3 $h3.bkp
else
    echo "----  head3.lst not found - Exiting";
    exit 0
fi
  # Save inputs:
  conf=$1
  flag=$2
  occ=0.00

  if [ "$flag" == "t" ]; then
     occ=1.00
  fi
  if [ $# -eq 3 ]; then
    occ=$3
  fi
  # echo "Conformer: $conf - Flag: $flag - Occ: $occ"
  export conf flag occ
  #  Change flag and occ ($3):
  nawk -v id=$conf -v fl=$flag -v oc=$occ ' \
      BEGIN {fmtTitle="%-6s%-14s%-3s%4s%7s%6s%6s%3s%3s%8s%8s%8s%8s%8s%8s%11s\n"; frmRow="%05d %14s %s %4.2f %6.3f %5.0f %5.2f %2d %2d %7.3f %7.3f %7.3f %7.3f %7.3f %7.3f %11s\n"; \
             printf(fmtTitle,"iConf","CONFORMER","FL","occ","crg","Em0","pKa0","ne","nH","vdw0","vdw1","tors","epol","dsolv","extra","history")}; \
             $2~id {$3=fl; $4=oc}; NR > 1 {printf(frmRow,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16)}' $h3.bkp > $h3.new

  /bin/rm $h3
  ln -s $h3.new $h3
  echo
  echo "---->  The new (amended) head3 file has been relinked as head3.lst. Ready for step4."
