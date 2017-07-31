#!/bin/bash
if [[ $# -eq 0 ]]; then
  echo "1: Name of pdb required; [2: remove H+? (0/1)]"
  exit 0
fi
in_pdb=$1

noH=0
if [[ $# -eq 2 ]]; then
  noH=$2
fi
grep -v MEM $1 > tmp
if [[ $noH -eq 1 ]]; then
  sed -i '/  H  /d;/  H[A-Z]/d;/ [1-3]H/d' tmp
fi

read -p "For pdb "$in_pdb": motif id (string): " motif_id
read -p "For pdb "$in_pdb", motif: "$motif_id"; Seq number of motif first residue: " first
read -p "For pdb "$in_pdb", motif: "$motif_id"; Seq number of motif last residue: " last

# 146 - 152 #-> the first line of VAL 152 will be included.
# 208 - 214
#strin="QE-R1_cl000_4.5.PDB"; echo ${strin%_4*} => QE-R1_cl000
#str=${in_pdb%_4*}

out_pdb=$(echo ${in_pdb%_4*} | sed -e 's/-//;s/cl//' )"-"$motif_id

chains=$(awk '$5 !="M" {print $5}' tmp | uniq)
for chn in $(echo $chains)
do
  sedARG="-n '/ $chn $first /,/ $chn $last /p' "
  eval sed "$sedARG" tmp > $out_pdb"-"$chn".pdb"

done
/bin/rm -f tmp
