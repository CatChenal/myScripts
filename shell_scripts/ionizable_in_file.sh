#!/bin/bash

USAGE="Usage: $0 path/any non-pdb file that references 3-letter res names"

if (( "$#" < "1" )); then
   echo $USAGE
   exit 1
fi

echo
echo -n "Total ionizable residues in "$1" :  "; egrep -c "ASP|GLU|ARG|CYS|HIS|LYS|TYR" $1 
echo
echo -n "ACID(s): "
egrep -ciw "ASP|GLU"
echo -n "    ASP: "; grep -iw 'ASP' $1 | grep -c ASP
echo -n "    GLU: "; grep -iw 'GLU' $1 | grep -c GLU
echo

echo -n "BASE(s): "
egrep -ciw "ARG|CYS|HIS|LYS|TYR" $1
echo -n "    ARG: "; grep -iw 'ARG' $1 | grep -c ARG
echo -n "    CYS: "; grep -iw 'CYS' $1 | grep -c CYS
echo -n "    HIS: "; grep -iw 'HIS' $1 | grep -c HIS
echo -n "    LYS: "; grep -iw 'LYS' $1 | grep -c LYS
echo -n "    TYR: "; grep -iw 'TYR' $1 | grep -c TYR
echo
echo ----- $0 over ------
