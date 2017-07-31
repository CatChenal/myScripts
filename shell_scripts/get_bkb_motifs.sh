#!/bin/bash
if [[ $# -eq 0 ]]; then
   echo "Required: pdb_file"
   exit 0
fi
pdb=$1

#select Ex_motif, (resi 145-153) in bkb; 
#select Fx_motif, (resi 354-361) in bkb; 

# S2 format:
# ATOM      1  N   ARG A0017_000 -21.893 -17.001  28.775   1.500      -0.350      BK____M000
# PDB fortmat:
# ATOM      1  N   ARG A  17     -21.893 -17.001  28.775  1.00  0.00           N
# 1         2  3   4   5
#  => test to find out format: check length field 5.
occ_lim="0.1"

LB1="A0145"
UB1="A0153"
LB2="A0354"
UB2="A0361"

top1=$(awk -v res="$LB1" -v occ="$occ_lim" '{if ($1 ~ res) {$2>=occ){ print $1}}}' fort.38 |sort -k2nr|head -1)
top2=$(awk -v res="$UB1" -v occ="$occ_lim" '{if ($1 ~ res) {$2>=occ){ print $1}}}' fort.38 |sort -k2nr|head -1)
top3=$(awk -v res="$LB2" -v occ="$occ_lim" '{if ($1 ~ res) {$2>=occ){ print $1}}}' fort.38 |sort -k2nr|head -1)
top4=$(awk -v res="$UB2" -v occ="$occ_lim" '{if ($1 ~ res) {$2>=occ){ print $1}}}' fort.38 |sort -k2nr|head -1)

last1=$(grep $UB1 step2_out.pdb | tail -1|awk '{print $5}')
last2=$(grep $UB2 step2_out.pdb | tail -1|awk '{print $5}')

# Select by range for the two motifs:

awk -v lb1="$LB1" -v ub1="$last1" -v lb2="$LB2" -v ub2="$last2" '($5 ~ lb1, $5 ~ ub1)||($5 ~ lb2, $5 ~ ub2)' $pdb > motifs.pdb

#egrep_line="'"$LB1"_000|"$top1"|"$LB2"_000|"top2'"
#   eval egrep $egrep_line step2_out.pdb >> $res_confs_pdb

# change b-factors
# convert to pdb format

