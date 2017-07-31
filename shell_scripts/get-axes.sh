#!/bin/bash
if [ $# -lt 1 ]; then
  echo "File to process needed as arg."
  exit 0
fi

# PDB format:
#ATOM   4919  C   ALA A 325      11.409  -4.428 -24.033  0.00  0.00           [C: converted pdb may not have the last col]
#1     2      3   4   5  6      7        8       9       10    11             12
PDBf="%-6s%5d  %-3s %3s %1s%4d %8.3f%8.3f%8.3f%6.2f%6.2f %12s\n"
#     $1, $2, "C","AXS","Z",substr($5,2,4),$6,0,0,$9,$10,"C"

# S2 format:
#ATOM  51529 6C73 MEM M0003_000   5.655  15.830 -17.915   1.700       0.000      BK________
#1     2     3    4   5           6      7      8         9           10         11
S2f="%-6s%5d %-4s %3s %9s%8.3f%8.3f%8.3f%8.3f    %8.3f%16s\n"

S2=$(grep ATOM $1|head -1|egrep '_[0-9][0-9[0-9]')

if [[ ${#S2} -eq 0 ]]; then
  PRT=$PDBf
  ATM='CA  '
  #x-axis:
  grep ATOM $1| grep $ATM |sort -k7n| \
  awk -v frmt="$PRT" '{printf(frmt,$1,$2,$3,"AXS","X",$6,$7,0,0,$10,$11,$12 )}' > tmpx
  #y-axis:
  grep ATOM $1| grep $ATM |sort -k8n| \
  awk -v frmt="$PRT" '{printf(frmt,$1,$2,$3,"AXS","Y",$6,0,$8,0,$10,$11,$12 )}'  > tmpy
  #z-axis:
  grep ATOM $1| grep $ATM |sort -k9n| \
  awk -v frmt="$PRT" '{printf(frmt,$1,$2,$3,"AXS","Z",$6,0,0,$9,$10,$11,$12 )}' > tmpz

else
  PRT=$PDBf
  ATM='[0-9]CA..'
  #x-axis:
  grep ATOM $1| grep $ATM |sort -k6n| \
  awk -v frmt="$PRT" -v ax="X" '{ if(NR==1) {ref=$6; printf(frmt,$1,$2,"C","AXS",ax,NR,$6,0,0,$9,$10,"C") } else \
                                {   if($6>=(ref+1)) {printf(frmt,$1,$2,"C","AXS",ax,NR,$6,0,0,$9,$10,"C"); ref=$6} } }' > tmpx
  #y-axis:
  grep ATOM $1| grep $ATM |sort -k7n| \
  awk -v frmt="$PRT" -v ax="Y" '{ if(NR==1) {ref=$7; printf(frmt,$1,$2,"C","AXS",ax,NR,0,$7,0,$9,$10,"C") } else \
                                {   if($7>=(ref+1)) {printf(frmt,$1,$2,"C","AXS",ax,NR,0,$7,0,$9,$10,"C"); ref=$7} } }' > tmpy
  #z-axis:
  grep ATOM $1| grep $ATM |sort -k8n| \
  awk -v frmt="$PRT" -v ax="Z" '{ if(NR==1) {ref=$8; printf(frmt,$1,$2,"C","AXS",ax,NR,0,0,$8,$9,$10,"C") } else \
                                {   if($8>=(ref+1)) {printf(frmt,$1,$2,"C","AXS",ax,NR,0,0,$8,$9,$10,"C"); ref=$8} } }' > tmpz
fi
cat tmpx tmpy tmpz >$(basename $1 .pdb)".xyz.pdb"
/bin/rm tmp*
