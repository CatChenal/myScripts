#!/bin/bash
if [[ $# -eq 0 ]]; then
  echo File with residue id missing
  exit 0
fi
# arg1= file with list of residues id Annnn
if [[ ! -f fort.38.non0 ]]; then
  echo fort.38.non0 not found.
  exit 0
fi
do_append=0
if [[ -f basecheck ]]; then
  read -p "Append to existing basecheck file?(1/0) " do_append
fi
if [[ $do_append -eq 0 ]]; then
   mv basecheck basecheck.bkp
   touch basecheck
fi
for resid in $(cat $1)
do
  grepsum '0.'$resid fort.38.non0 >> basecheck

done
