#!/bin/bash
# Cat Chenal 2011-08-02
# Rev 2013-01-15: print format
# To convert mcce file (eg step2) to pdb format and strip the last 2 cols

if [ $# -lt 1 ]; then
  echo "Usage:  file_name [saveas]"
  exit 0
fi

## Print format in MCCE write_pdb.c:
##"ATOM  %5d %4s %3s %c%04d%c%03d%8.3f%8.3f%8.3f %7.3f      %6.3f      %-11s\n
## ....  nnnnn XXXX RRR Cnnnn_000xxxxxxxxyyyyyyyyzzzzzzzz ooooooo      bbbbbb      sssseeqq...
## 1     2     3    4   5        6       7       8        9            10          11
## ATOM      1  N   ARG A0017_000  78.380  43.780  77.170   1.500      -0.350      BK____M000 :: always 11 cols

#Cut last col only:
awk 'BEGIN{prt11="%-6s%5d %-4s %3s %1s%4d    %8.3f%8.3f%8.3f %6.2f\n"} \
   { printf(prt11,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10) } ' $1 > tmp

if [ $# -eq 2 ]; then
  saveas=$2
else
  saveas=$(basename $1 .pdb)".PDB"
fi

mv -f tmp $saveas
echo "Converted pdb was saved as "$saveas
