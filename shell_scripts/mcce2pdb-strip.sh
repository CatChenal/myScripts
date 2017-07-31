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
## ATOM  99999 0C00 MEM M0001_000 -56.770 -56.017 -18.336   1.700       0.000      BK________
##"%-6s  %5d   %4s %3s %9s%8.3f%8.3f%8.3f%6.2f%6.2f%12s\n"
## ATOM  51537  C   AXS X   3    4.321   0.000   0.000  1.70  0.00            C :12
## ATOM  51537  C   AXS X3000    4.321   0.000   0.000  1.70  0.00            C :11

awk 'BEGIN{prt11="%-6s%5d %-4s %3s %1s%4d    %8.3f%8.3f%8.3f %6.2f%6.2f\n"} \
      { if ( length($3)< 4 ) {atm=sprintf(" %-3s",$3)} else {atm=$3}; \
        if (NF==11) {chn=substr($5,1,1); seq=substr($5,2,4)} else {chn=$5; seq=$6}; \
        if ($4=="CYD") {$4="CYS"}; \
        if ($4=="AXS") {$3="_C"}; \
        if (($4=="HOH")&&(chn=="W")) {$3="_O"} } \
      { if (NF==11) {printf(prt11,$1,$2,atm,$4,chn,seq,$6,$7,$8,$9,$10)} else \
                    {printf(prt11,$1,$2,atm,$4,chn,seq,$7,$8,$9,$10,$11) } } ' $1 > tmp

sed -i 's/_/ /' tmp
if [ $# -eq 2 ]; then
  saveas=$2
else
  saveas=$(basename $1 .pdb)".PDB"
fi

mv -f tmp $saveas
echo "Converted pdb was saved as "$saveas
