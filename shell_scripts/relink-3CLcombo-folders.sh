#!/bin/bash
# Cat Chenal @ Gunner lab - 2011-10-05
# ARG1: (1/0) relink unzipped parent energies folder only
#
#for fldr in $(echo 'cl000 cl001 cl010 cl011 cl100 cl101 cl110 cl111')
for fldr in $(echo cl*)
do
  if [ ! -d "$fldr" ]; then
    mkdir $fldr
  fi

  cd $fldr
  if [[ $# -eq 0 ]]; then
    ##  /bin/rm -f run.prm step2_out.pdb energies* submit.sh
    ln -s ../run.prm .
    ln -s ../step2_out.pdb .
    ln -s ../submit.sh .
    ln -s ../energies .
  else
    ln -s ../energies .
  fi
  cd ../
done

# echo "TO DO NEXT: run reset-h3-Cl-comp-runs.sh"

