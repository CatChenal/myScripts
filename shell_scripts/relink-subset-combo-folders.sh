#!/bin/bash
# Cat Chenal @ Gunner lab - 2013-09

for subset in $(echo n*)
do
  cd $subset

  for fldr in $(echo cl*)
  do
    cd $fldr
      /bin/rm -f run.prm step2_out.pdb step3_out.pdb energies* submit.sh
      ln -s ../../run.prm .
      ln -s ../../step2_out.pdb .
      ln -s ../../energies .
      ln -s ../../energies step3_out.pdb
      ln -s ../../submit.sh .
    cd ../
  done

  cd ../
done
