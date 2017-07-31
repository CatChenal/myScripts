#!/bin/bash
#  According to the PDB specification, columns 77-78 should contain the element symbol of an atom.
# P1 => chain A; P2 => chain B
#.....................................................................................
# 123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.
# ATOM..nnnnn XXXX RRR Cnnnn    xxxxxxxxyyyyyyyyzzzzzzzzoooooobbbbbb      sssseeqq
#            ^    ^   ^     ^^^^                                    ^^^^^^
# 1     2     3    4   56       7       8       9       10    11          12  13 14
#
# ATOM      1  N   ARG A  17      50.272 -12.812  56.028  1.00 99.30           N   :: 1otsa
#"%-6s%5d %4s %-3s %s%4d    %8.3f%8.3f%8.3f%6.2f%6.2f          %2s\n"               :: prt12, canon
#"%-6s%5d %4s %-3s %s%4d    %8.3f%8.3f%8.3f%6.2f%6.2f      %-4s\n"                  :: prt12, MD
#......................................................................
cp $1 $1.bkp

# Correct for wrong chain assignment: if $7 is neg&O65 then O65$ -> O66$; or $7 is pos and O66 -> O65;
# also assign CL to chains
# To center 3rd field:      printf "%*s\n" $(((${#3}+4)/2)) "$3" :works on its own, in c.

awk 'BEGIN{prt12="%-6s%5d %-4s %3s %s%4d    %8.3f%8.3f%8.3f%6.2f%6.2f      %-4s\n"} \
     { if( ($7<0)&&($NF=="O65") ) { $NF="O66" } else if( ($7>0)&&($NF=="O66") ) {$NF="O65"} } \
     { if( ($4=="_CL")&&($7<0) ) {$NF="P1"} else if( ($4=="_CL")&&($7>0) ) {$NF="P2"} } \
     { if(NF==12) {printf(prt12,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12)} \
             else {printf(prt12,$1,$2,$3,$4,substr($5,1,1),substr($5,2,4),$6,$7,$8,$9,$10,$11)} }' $1 > tmp

sed -e 's/\([0-9] \)\([A-Z]..\) /\1 \2/' \
    -e '/P1  $/{s/ P / A /}; /P1  $/{s/ AHE / PHE /}; /P1$/{s/ ARO / PRO /}' -e '/_CL/{/P1  $/{s/ O / A /}}' \
    -e '/P2  $/{s/ P / B /}; /P2  $/{s/ BHE / PHE /}; /P2$/{s/ BRO / PRO /}' -e '/_CL/{/P2  $/{s/ O / B /}}' tmp > $1

/bin/rm tmp *.bkp
