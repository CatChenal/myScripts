#!/bin/sh
# Cat Chenal @ Gunner lab - 2010-12-29
Scriptname="applymfe++format.sh"
# 
LINE1="Call pattern: applymfe++format.sh filetoreformat outputfilename"
Usage=`echo "$LINE1"`

if [ $# -lt 2 ]; then
   echo "$Usage";
   exit 0;
fi

cp $1 $1.bkp
echo "----  $1 has been backed up into $1.bkp";
# S2 format:
# awk '{ printf("%-6s%5d %-4s %3s %9s%8.3f%8.3f%8.3f %7.3f      %6.3f      %-11s\n", $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11)} ' $1.bkp > $2

# mfe++ format:

col=`awk 'NR=1 {print NF}'`
echo "Columns in file:  "$col

prtf="%-10s"

for (c=1; c=$col; c++)
do
   prtf=$prtf & " %6.2f"

echo "c: "$c"; Format string: "$prtf

awk '{ printf($prtf"\n", $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11)} ' $1.bkp > $2

echo "End of $Scriptname  -------------------<"
