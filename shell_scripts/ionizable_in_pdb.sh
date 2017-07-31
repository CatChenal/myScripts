#!/bin/bash
this=`basename $0`

USAGE="Usage: $this any.pdb chain_ltr"
if [ $# -lt 2 ]; then
   echo $USAGE
   exit 1
fi
fname=`basename $1`
# in case pdb from MD sim, transform all His:
sed 's/CA  HS[D|E]/CA  HIS/' $1 > tmp
# Reset arguments:
set tmp $2

totRes=`egrep -c 'ATOM.{9}CA  [A-Z][A-Z][A-Z] '$2'' $1`
totIon=`egrep 'ATOM.{9}CA  [A-Z][A-Z][A-Z] '$2'' $1 | egrep -c "ASP|GLU|ARG|CYS|HIS|LYS|TYR"`

echo
echo -n "Total number of residues in "$fname" (chain "$2") :  "$totRes;
echo
echo "Total ionizable residues in "$fname" (chain "$2") :  "$totIon;
# pctIon=`float_eval "$totIon / $totRes"`
# echo $pctIon

#ATOM   1086  CA  GLY A 159
echo;echo
totAcid=`egrep 'ATOM.{9}CA  [A-Z][A-Z][A-Z] '$2'' $1 | egrep -c "ASP|GLU"`
totBase=`egrep 'ATOM.{9}CA  [A-Z][A-Z][A-Z] '$2'' $1 | egrep -c "ARG|CYS|HIS|LYS|TYR"`
totArom=`egrep 'ATOM.{9}CA  [A-Z][A-Z][A-Z] '$2'' $1 | egrep -c "HIS|PHE|TRP|TYR"`

echo "ACID(s): "$totAcid;
echo -n "    ASP: "; egrep -c 'ATOM.{9}CA  ASP '$2'' $1
echo -n "    GLU: "; egrep -c 'ATOM.{9}CA  GLU '$2'' $1
echo
echo "BASE(s): "$totBase;
echo -n "    ARG: "; egrep -c 'ATOM.{9}CA  ARG '$2'' $1
echo -n "    CYS: "; egrep -c 'ATOM.{9}CA  CYS '$2'' $1
echo -n "    HIS: "; egrep -c 'ATOM.{9}CA  HIS '$2'' $1
echo -n "    LYS: "; egrep -c 'ATOM.{9}CA  LYS '$2'' $1
echo -n "    TYR: "; egrep -c 'ATOM.{9}CA  TYR '$2'' $1
echo

echo "Total aromatic residues in "$fname" (chain "$2") :  "$totArom;
echo -n "    HIS: "; egrep -c 'ATOM.{9}CA  HIS '$2'' $1
echo -n "    PHE: "; egrep -c 'ATOM.{9}CA  PHE '$2'' $1
echo -n "    TRP: "; egrep -c 'ATOM.{9}CA  TRP '$2'' $1
echo -n "    TYR: "; egrep -c 'ATOM.{9}CA  TYR '$2'' $1

/bin/rm tmp

