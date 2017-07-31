#!/bin/bash
if [ $# -lt 1 ]; then
  echo "conformer needed"
  exit 0
fi
infile="head3.lst"
if [[ ! -f $infile ]]; then
  echo "head3.lst needed"
  exit 0
fi
cp $infile $infile.bkp

# To fill extra col with -(vdw0 + dsolv)
# hdr:  iConf CONFORMER     FL  occ    crg   Em0  pKa0 ne nH    vdw0    vdw1    tors    epol   dsolv   extra    history
# col:  1     2             3   4      5     6    7    8  9     10      11      12      13     14      15       16

#  if ( ( ($1 ~ id)&&($1 !~ ref) )||( ($2 ~ id)&&($2 !~ ref) ) )

# awk '/CLDM/{$10=sprintf("%8.3f",0)}; /CL-1/{$10=sprintf("%8.3f",-2.443)}; {print}' head3.lst.bkp > head3.lst

nawk -v conf=$1 '
  BEGIN { print "iConf CONFORMER     FL  occ    crg   Em0  pKa0 ne nH    vdw0    vdw1    tors    epol   dsolv   extra    history";
        h3format="%05d %s %c %4.2f %6.3f %5.0f %6.2f %2d %2d %7.3f %7.3f %7.3f %7.3f %7.3f %7.3f %11s\n" }
   NR>1 { if ($2 ~ conf) { $(NF-1)=-($10+$(NF-2)) }; printf h3format, $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16 }
  ' $infile > $infile.extra

rm $infile ; ln -s $infile.extra $infile 

head $infile
