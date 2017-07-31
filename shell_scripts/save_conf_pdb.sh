#!/bin/bash
# Cat Chenal 2013-08-14
# To convert a subgroup of conformer from step2 to pdb format and strip the last column.
# The comformer number if added to the seq num, so that the parent res = bkb conformer.

if [ $# -lt 1 ]; then
  echo "Usage:  file_name [saveas]"
  exit 0
fi

## 1     2     3    4   5        6       7       8        9            10          11
## ATOM      1  N   ARG A0017_000  78.380  43.780  77.170   1.500      -0.350      BK____M000 :: always 11 cols
##"%-6s  %5d   %4s %3s %9s%8.3f%8.3f%8.3f%6.2f%6.2f%12s\n"
## ATOM  51537  C   AXS X3000_000   4.321   0.000   0.000  1.70  0.00            C :11

nawk 'BEGIN{prt11="%-6s%5d %-4s %3s %1s%4d%8.3f%8.3f%8.3f %6.2f%6.2f\n"} \
      { if ( length($3)< 4 ) {atm=sprintf(" %-3s",$3)} else {atm=$3}; \
        if ($4=="CYD") {$4="CYS"}; if ($4=="AXS") {$3="_C"}; \
        chn=substr($5,1,1); seq=(sprintf("%4d",substr($5,2,4))+0); conf=(sprintf("%3d",substr($5,7,3))+0); newseq=seq+conf } \
      { printf(prt11,$1,$2,atm,$4,chn,newseq,$6,$7,$8,$9,$10) } ' $1 > tmp

if [ $# -eq 2 ]; then
  saveas=$2
else
  saveas=$(basename $1 .pdb)".PDB"
fi

mv -f tmp $saveas
echo "Converted pdb was saved as "$saveas

