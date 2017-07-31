#!/bin/bash
# Cat Chenal 2013-08-14
# To convert a subgroup of conformers of a SINGLE RESIDUE from step2 to pdb format and strip the last column.
# The comformer number if added to the seq num, so that the parent res = bkb conformer.
if [ $# -lt 1 ]; then
  echo "Usage:  file_name [saveas]"
  exit 0
fi
## 1     2     3    4   5        6       7       8        9            10          11
## ATOM      1  N   ARG A0017_000  78.380  43.780  77.170   1.500      -0.350      BK____M000 :: always 11 cols
##"%-6s  %5d   %4s %3s %9s%8.3f%8.3f%8.3f%6.2f%6.2f%12s\n"
## ATOM  51537  C   AXS X3000_000   4.321   0.000   0.000  1.70  0.00            C :11

first=$(awk '/_001/ {print NR}' $1|head -1)
#tot=$(awk '/_001/' $1| wc -l)
last=$(tail -1 $1 | awk '{print substr($5,7,3)+0}')

if [ $# -eq 2 ]; then
  saveas=$2
else
  saveas=$(basename $1 .pdb)
fi

for ((i=1; i<=$last; i++))
do
  conf=$( printf "_%03d" $i );
  echo "Sart of loop i: "$i"; Conf: "$conf

  outfile=$saveas$conf

  tot=$( eval grep " $conf" $1| wc -l )

  grep $conf $1 > $outfile

#  i=$(echo "scale=1; $i+$tot-1"|bc); echo "Next i: " $i

done

#echo "Converted pdb was saved as "$saveas

