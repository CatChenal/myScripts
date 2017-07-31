#!/bin/sh
# Cat Chenal @ Gunner lab - 2010-12-28
Scriptname="applyS2format.sh"
# 
LINE1="Call pattern: applyS2format.sh filetoreformat outputfilename"
Usage=`echo "$LINE1"`

if [ $# -lt 2 ]; then
   echo "$Usage";
   exit 0;
fi

cp $1 $1.bkp
echo "----  $1 has been backed up into $1.bkp";

awk '{ printf("%-6s%5d %-4s %3s %9s%8.3f%8.3f%8.3f %7.3f      %6.3f      %-11s\n", $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11)} ' $1.bkp > $2

echo "End of $Scriptname  -------------------<"
