#!/bin/bash
# Cat Chenal @ Gunner lab - 2011-10-05

for fldr in `echo cl000 cl001 cl010 cl011 cl100 cl101 cl110 cl111`
do
  if [ ! -d "$fldr" ]; then
     mkdir $fldr
  fi

  cd $fldr
  echo "OK: $fldr";
  /bin/rm run.prm step2_out.pdb submit.sh energies*
  ln -s ../run.prm .
  ln -s ../step2_out.pdb .
  ln -s ../energies.opp
  ln -s ../submit.sh .
 
  cd ../
done
echo "TO DO NEXT: run reset-h3-Cl-comp-runs.cmd"
echo "*****************************************"

