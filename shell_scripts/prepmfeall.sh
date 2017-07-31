#!/bin/bash

#chn=`awk 'NR==1 {print substr($1,5,1)}' mfe-all-res`
prefix=$1

sed -e 's/.\{15\}[A-Z]/&_/g' -e 's/_ //g' -e 's/_0/_/' -e 's/\([A-Z][A-Z][A-Z]\)[A-Z]/\1_A/g' -e 's/\(_[A-Z]\)0/\1_/' mfe-all-res > temp0
#-e 's/\([A-Z]\{3\}\)[+-]/\1_/g'

gawk 'BEGIN{OFS="\t"}{print $1, $2, $3, $4, $5 | "sort +0 -1 +1 -2 +2 -3 +3 -4"}' temp0 |
gawk 'BEGIN{OFS="\t"}{cn=substr($1,5,1); print "chn"cn, $1, $2, $3,$4, $5}'> $prefix-mfe-all-res.csv
#chain$chn-mfe-all-res.csv
/bin/rm temp0

