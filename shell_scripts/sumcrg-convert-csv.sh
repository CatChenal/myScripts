#!/bin/bash
# Scriptname: sumcrg-convert-csv.sh
#
# *************************************************************************
# 09-30-09 - Cat Chenal  - Converts sumcrg.out to comma sep file
# WARNING:	Until modified this script WILL ONLY WORK FOR A 15-POINT TITRATION!
# *************************************************************************
#
# USAGE: To be in the mcce working directory (where sum_crg.out resides).
# USAGE: Argument#1 ($1) = pdbid; argument#2 ($2) = path; arg#3 ($3) = filename of sum_crg.out to use.
#        (Some are sum_crg.out1)
# CALL example: . sumcrg-convert-csv.sh chainA . sum_crg.out

# 1 Grep residues only + ph val:
egrep 'pH|ASP|CYS|GLU|TYR|ARG|HIS|LYS' $2/$3 > ./sum_temp0

# 2 Remove 0-lines (why they are output at all is a mystery!):
grep -v '0.00  0.00  0.00  0.00  0.00  0.00  0.00  0.00  0.00  0.00  0.00  0.00  0.00  0.00  0.00' ./sum_temp0 > ./sum_temp1
grep -v '\-0.00 \-0.00 \-0.00 \-0.00 \-0.00 \-0.00 \-0.00 \-0.00 \-0.00 \-0.00 \-0.00 \-0.00 \-0.00 \-0.00 \-0.00' ./sum_temp1 > ./sum_temp0

# 3 Create comma-separated file:
awk 'BEGIN {OFS=","}{print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16}' ./sum_temp0 > ./sum_temp1

# 3.5 identify which file was used:
filext=`echo "$3" | awk '{len=length($1); dot=index($1,"."); print substr($1, dot, len-dot+1)}' | sed 's/^./_/'`

# 4 clean up & save:
sed -e 's/^pH/res,seq/' -e 's/\([A-Z]\)0/\1,/' -e 's/_//' ./sum_temp1 > ./$1_sumcrg$filext.csv
#-e 's/0,/,/'

# 6 del temp files:
rm -f ./sum_temp*

echo --- sumcrg-convert-csv.sh over --- `date`
