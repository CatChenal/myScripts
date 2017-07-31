#!/bin/sh
# Cat Chenal @ Gunner lab - 2011-08-04
Scriptname="pdb-format.sh"
# 
LINE1="Call pattern: pdb-format.sh filetoreformat outputfilename"
Usage=`echo "$LINE1"`

if [ $# -lt 2 ]; then
   echo "$Usage";
   exit 0;
fi

# PDB format:
# ATOM   3289  OE1 GLN A 460      54.524 -27.922  20.671  1.00114.30           O
# HETATM13230 CL    CL A 466      35.212  -5.086  14.865  1.00 55.04          CL
# ATOM      2  CA  ARG A  17      49.758 -12.116  54.808  1.00 99.60           C

#awk '{ printf("%-6s%5d %-4s %3s %9s%8.3f%8.3f%8.3f %7.3f      %6.3f      %-11s\n", $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11)} ' $1 > $2

awk '{ printf(" %-6s%5d %-4s %-3s %s %3d     %8.3f%8.3f%8.3f %5.2f\n", $1,$2,$3,$4,$5,$6,$7,$8,$9,$10)} ' $1 > $2

echo "End of $Scriptname  -------------------<"
