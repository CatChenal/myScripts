#!/bin/sh
# Cat Chenal @ Gunner lab - 2011-02-11
# Rev:
# 
this="`basename $0`"
Usage="Call pattern: $this head3_formatted_file\n"

if [ $# -lt 1 ]; then
   echo $Usage;
   exit 0;
fi

# sum = vdw0+vdw1+tors+epol+dsolv

awk 'BEGIN {sum=0;printf("%-6s%-14s%-3s%4s%7s%6s%6s%3s%3s%8s%8s%8s%8s%8s%8s%11s\n","iConf","CONFORMER","FL","occ","crg","Em0","pKa0","ne","nH","vdw0","vdw1","tors","epol","dsolv","extra","totE")};
NR>1 {sum=0;for(i=10;i<=14;i++){sum+=$i};$NF=sum; {printf("%05d %14s %s %4.2f %6.3f %5.0f %5.2f %2d %2d %7.3f %7.3f %7.3f %7.3f %7.3f %7.3f %10.3f\n", $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16)}}' $1 > $1.totE

echo ----  $this over ---  Result saved into $1.totE
