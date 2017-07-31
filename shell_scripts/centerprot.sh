#!/bin/bash
if [[ $# -eq 0 ]]; then
  echo "pdb filename required"
  exit 0
fi

in_prot=$1
prot=${in_prot%.pdb*}"_ctrd.pdb"
#echo $in_prot ;echo $prot

babel -i pdb $in_prot -o pdb $prot -center

