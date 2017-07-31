#!/bin/bash
if [[ $# -lt 2 ]]; then
  read -p "Enter an identifier for this (parent) folder: " fld_id
  read -p "Enter a directory name identifier (for filtering folders): " filter
else
  fld_id=$1
  filter=$2
fi
Run=$fld_id"_"$filter

# Pull 203 out of hi_stdv_confs.csv:
Out=$Run"_0203_hi_stdv.csv"
awk '/0203/{ idx=index(FILENAME, "/h"); {print substr(FILENAME, 1, idx-1), $0}}' $filter*/hi_stdv_confs.csv | sort -k2 > $Out

In=$Run"_0203_hi_stdv.csv"
Out=$Run"_0203_hiconfs"
#get list of uniq confs to output pdb:
awk '{ conf=substr($2, 6, 14); { if (conf != prev) {print conf; prev=conf}} }' $In > tmp

do_pdb=0

if [[ -s tmp ]]; then
   if [[ $do_pdb -eq 1 ]]; then
     for id in $(cat tmp)
     do
        grepline="'"${id%_*}"_000|"$id"'"
        eval egrep $grepline step2_out.pdb | cut -c -74  > $Run"_"$id".PDB"
     done
   fi
   # Replace hiconf list with same but with stdv values:
   awk '{print $1, $NF}' $In |sort -k1|uniq > $Out
fi
/bin/rm tmp
