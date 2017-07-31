#!/bin/sh
# Cat Chenal @ Gunner lab - 2010-11-22
# Rev: 2011-01-31
# 
LINE1="Call pattern: change-h3-Extra.sh confID [any part of it] new_value;\n"
LINE2="Call example: change-h3-Extra.sh A0100 999  :: change all the conformers of residue A0100 to 999\n"
LINE3="              change-h3-Extra.sh DM 1200    :: change all dummy conformers to 999\n"
LINE4="              change-h3-Extra.sh HOHDM 999  :: change all the dummy conformers of water to 999"
Usage=`echo "$LINE1""$LINE2""$LINE3""$LINE4"`
# NOTE: 999 = maximum value

if [ $# -lt 2 ]; then
   echo "$Usage";
   exit 0;
fi

echo "---->  FYI:  run.prm is setup to do: \n"
echo "-----         [ "`grep 'Number of titration' run.prm`" ]"
echo "-----         [ "`grep mfe run.prm`" ]"
echo "---->  Is that ok?  Enter y for yes, [n for no]: "; read answ
if [ "$answ" != "y" ]; then
   echo "---->  Exiting";
   exit 0;
fi

h3="head3.lst"
if [ -f $h3 ]&&[ -f run.prm ] ; then
   #if [ -h $h3 ]; then /bin/rm $h3   # already a link: remove?
   cp $h3 $h3.bkp
   echo "----  $h3 has been backed up into $h3.bkp";
else
   echo "---->  head3.lst or run.prm (or both) not found - Exiting";
   exit 0;
fi

# Save inputs:
conf=$1; val=$2
if [ $val -gt 999 ] ; then val=999
fi

export conf val
awk -v id=$conf -v new=$val 'BEGIN { printf("%-6s%-14s%-3s%4s%7s%6s%6s%3s%3s%8s%8s%8s%8s%8s%8s%11s\n","iConf","CONFORMER","FL","occ","crg","Em0","pKa0","ne","nH","vdw0","vdw1","tors","epol","dsolv","extra","history") }; $2~id {$15=new}; NR > 1 { printf("%05d %14s %s %4.2f %6.3f %5.0f %5.2f %2d %2d %7.3f %7.3f %7.3f %7.3f %7.3f %7.3f %11s\n", $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16)} ' $h3.bkp > $h3.new

/bin/rm $h3
ln -s $h3.new $h3

echo "---->  The new (amended) head3 file has been relinked as head3.lst. Ready for step4."
echo "End of change-h3-Extra.sh -------------------<\n"
