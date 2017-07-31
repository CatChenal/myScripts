#!/bin/bash
# NEED FIXING 5/22/2012

USAGE="Usage: $0 a fasta-like file with 1-letter res names"
#  >gi|121422|sp|P08194.1|GLPT_ECOLI RecName: Full=Glycerol-3-phosphate transporter
#  MLSIFKPAPHKARLPAAEIDPTYRRLRWQIFLGIFFGYAAYYLVRKNFALAMPYLVEQGFSRGDLGFALS
#  GISIAYGFSKFIMGSVSDRSNPRVFLPAGLILAAAVMLFMGFVPWATSSIAVMFVLLFLCGWFQGMGWPP
#
if (( "$#" < "1" )); then
   echo $USAGE
   exit 1
fi
grep -v \> $1 > tmp
cat tmp

echo
echo -n "Total ionizable residues in "$1" :  "; egrep -c 'D|E|R|C|H|K|Y' tmp
echo
echo -n "ACID(s): "
egrep -ciw 'D|E' tmp
echo -n "    ASP: "; grep -c D tmp
echo -n "    GLU: "; grep -c E tmp
echo

echo -n "BASE(s): "
egrep -ciw 'R|C|H|K|Y' tmp
echo -n "    ARG: "; grep -c R tmp
echo -n "    CYS: "; grep -c C tmp
echo -n "    HIS: "; grep -c H tmp
echo -n "    LYS: "; grep -c K tmp
echo -n "    TYR: "; grep -c Y tmp
echo

#/bin/rm tmp

echo ----- $0 over ------
