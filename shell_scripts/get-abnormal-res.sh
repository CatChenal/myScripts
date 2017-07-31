#!/bin/bash

# name:         get-abnormal-res.sh
# description:	find abnormal ionized residues in sum_crg.out (at pH7)
# Assumption 1:	sum_crg.out has its header line
# Assumption 2: pH7 is included in the pH titration
#
# ARG, LYS: pH<0.8	not fully charged
# ASP, GLU: pH>-0.8     "
# HIS     : pH>0.2      not fully neutral
# TYR, CYS: pH<-0.2     " (negatively charged)
#
unset colnum

here=`pwd`
foldr=`basename $here`
out=$foldr".abn"

tmp=`head -1 sum_crg.out | awk '{ for(n=2;n<=NF;n++) {if (($n == 7)||($n == 7.0)) print n} }'`
colnum=`expr $tmp + 0`

if [[ $colnum -eq 0 ]]; then
	echo "pH7 not found in header of sum_crg.out"
	exit 1
else
#echo "pH7 col: "$colnum

   export colnum
   awk -v pH="$colnum" '{ if (($1 ~ /(ARG|LYS)/) && ($pH < 0.8)) { print $1"\t"$pH }
   else if (($1 ~ /(ASP|GLU)/) && ($pH > -0.8)) { print $1"\t"$pH }
   else if (($1 ~ /HIS/) && ($pH > 0.2)) { print $1"\t"$pH }
   else if (($1 ~ /(TYR|CYS)/) && ($pH < -0.2)) { print $1"\t"$pH } }' sum_crg.out > $out

#   awk -v pH="$colnum" -v loc="$fldr" '{ if (($1 ~ /(ARG|LYS)/) && ($pH < 0.8)) { print loc"\t"$1"\t"$pH }
#   else if (($1 ~ /(ASP|GLU)/) && ($pH > -0.8)) { print loc"\t"$1"\t"$pH }
#   else if (($1 ~ /HIS/) && ($pH > 0.2)) { print loc"\t"$1"\t"$pH }
#   else if (($1 ~ /(TYR|CYS)/) && ($pH < -0.2)) { print loc"\t"$1"\t"$pH } }' sum_crg.out
fi
