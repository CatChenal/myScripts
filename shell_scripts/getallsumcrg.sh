#!/bin/bash
# Scriptname: getallsumcrg.sh
#
# *************************************************************************
# Aug-09 - Cat Chenal
# WARNING:  Until modified this script WILL ONLY WORK FOR A 15-POINT TITRATION!
# *************************************************************************
# PURPOSE:	To convert sum_crg.out into comma separated file. Script is to be called
#		without argument in a folder that contains mcce working directories.
#
# Call example:	> . getallsumcrg.sh
# Output:	allsumcrg.csv
#
# 1 Grep residues only + ph val:
egrep 'pH|ASP|CYS|GLU|TYR|ARG|HIS|LYS' */sum_crg.out > ./sum_temp0

# 2 Remove 0-lines (why they are output at all is a mystery!):
grep -v '0.00  0.00  0.00  0.00  0.00  0.00  0.00  0.00  0.00  0.00  0.00  0.00  0.00  0.00  0.00' ./sum_temp0 > ./sum_temp1
grep -v '\-0.00 \-0.00 \-0.00 \-0.00 \-0.00 \-0.00 \-0.00 \-0.00 \-0.00 \-0.00 \-0.00 \-0.00 \-0.00 \-0.00 \-0.00' ./sum_temp1 > ./sum_temp0

# 3 Create comma-separated file:
awk 'BEGIN {OFS=","}{print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16}' ./sum_temp0 |
sed -e 's/\/sum_crg.out:/,/' -e 's/,pH/pH/' -e 's/\([A-Z]\)0/\1,/' -e 's/_//' > ./allsumcrg.csv

#sed -e 's/[A-D]0/&,/' -e 's/0      /,/'  -e 's/_//' > temp0
#chainD/sum_crg.out:LYS+D0455_,1.00,1.00,1.00,1.00,1.00,1

# 3.5 identify which file was used:
#filext=`echo "$3" | awk '{len=length($1); dot=index($1,"."); print substr($1, dot, len-dot+1)}' | sed 's/^./_/'`

# 4 Remove "pH," from first row & save:
#sed 's/^pH,//' ./sum_temp1 > ./$1_sumcrg$filext.csv

# 6 del temp files:
rm -f ./sum_temp*

echo --- getallsumcrg.sh over --- `date`
