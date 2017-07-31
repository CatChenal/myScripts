#!/bin/bash

USAGE="Usage: $0 path/any.pdb"

if (( "$#" < "1" )); then
   echo $USAGE
   exit 1
fi

#123456789 123456789 12345
#ATOM   3321  CG  GLU A 459      51.111 -26.771  14.443  1.00113.06           C
#
#SEQRES  23 B  346

echo
echo -n "Total ionizable residues in "$1" :  "; egrep 'ATOM.{9}CA' $1 | egrep -c "ASP|CYS|GLU|SER|TYR|ARG|HIS|LYS"
echo "DBREF lines from $1:"
awk '/^DBREF/ {print}' $1 > dbref-$1; cat dbref-$1 
echo
echo -n "ACID(s): "
egrep 'ATOM.{9}CA' $1| egrep -c "ASP|CYS|GLU|SER|TYR"
echo -n "    ASP: "; egrep 'ATOM.{9}CA' $1 | grep -c ASP
echo -n "    CYS: "; egrep 'ATOM.{9}CA' $1 | grep -c CYS
echo -n "    GLU: "; egrep 'ATOM.{9}CA' $1 | grep -c GLU
echo -n "    SER: "; egrep 'ATOM.{9}CA' $1 | grep -c SER
echo -n "    TYR: "; egrep 'ATOM.{9}CA' $1 | grep -c TYR
echo
echo -n "BASE(s): "
egrep 'ATOM.{9}CA'  $1 | egrep -c "ARG|HIS|LYS"
echo -n "    ARG: "; egrep 'ATOM.{9}CA' $1 | grep -c ARG
echo -n "    HIS: "; egrep 'ATOM.{9}CA' $1 | grep -c HIS
echo -n "    LYS: "; egrep 'ATOM.{9}CA' $1 | grep -c LYS
echo
echo ----- $0 over ------
 
