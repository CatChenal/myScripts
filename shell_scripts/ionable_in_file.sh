#!/bin/bash
#ionable_in_file.cmd

USAGE="Usage: $0 path/anyfile that references 3-letter res names"

if (( "$#" < "1" )); then
   echo $USAGE
   exit 1
fi

echo
echo -n "Total ionizable residues in "$1" :  "; egrep "ASP|CYS|GLU|SER|TYR|ARG|HIS|LYS" $1 | egrep -c "ASP|CYS|GLU|SER|TYR|ARG|HIS|LYS"
echo
echo -n "ACID(s): "
egrep -iw "ASP|CYS|GLU|SER|TYR" $1| egrep -ciw "ASP|CYS|GLU|SER|TYR"
echo -n "    ASP: "; grep -iw 'ASP' $1 | grep -c ASP
echo -n "    CYS: "; grep -iw 'CYS' $1 | grep -c CYS
echo -n "    GLU: "; grep -iw 'GLU' $1 | grep -c GLU
echo -n "    SER: "; grep -iw 'SER' $1 | grep -c SER
echo -n "    TYR: "; grep -iw 'TYR' $1 | grep -c TYR
echo
echo -n "BASE(s): "
egrep -iw "ARG|HIS|LYS" $1 | egrep -ciw "ARG|HIS|LYS"
echo -n "    ARG: "; grep -iw 'ARG' $1 | grep -c ARG
echo -n "    HIS: "; grep -iw 'HIS' $1 | grep -c HIS
echo -n "    LYS: "; grep -iw 'LYS' $1 | grep -c LYS
echo
echo ----- $0 over ------
