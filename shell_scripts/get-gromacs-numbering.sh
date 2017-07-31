#!/bin/bash
# $1: list of pdb files
# $2: list of residues, e.g. GLU, HIS
if [ $# -lt 2 ]; then
  echo "Usage:  pdbs_listfile residue_code_listfiles"
  exit 0
fi

#  96 ATOM   4061  N   GLU B 113      42.918  -2.182  49.029  1.00 83.26           N
#  96  GLU B 113

for dimer in $(cat $1)
do
 echo $dimer
  fout=$(basename $dimer .pdb)
  for res in $2
  do
    cAout=$fout"-cA-"$res".gro.num"
    cBout=$fout"-cB-"$res".gro.num"
    grep ' N   ' $dimer | grep ' A ' | awk '{print NR, $4, $5, $6}'|grep $res > $cAout
    grep ' N   ' $dimer | grep ' B ' | awk '{print NR, $4, $5, $6}'|grep $res > $cBout

  done
done
