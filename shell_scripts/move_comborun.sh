#!/bin/bash

N=$(echo "scale=0; $(ls -l | grep ^d| awk '{print $NF}'|grep '^n' | wc -l) + 1" |bc)
dir="n"$N
mkdir $dir
cp -a cl* $dir/.
echo Backup to $dir over.

cd $dir
  for fldr in $(echo cl*)
  do
    cd $fldr
      /bin/rm -f run.prm step2_out.pdb step3_out.pdb energies* submit.sh
      ln -s ../../run.prm .
      ln -s ../../step2_out.pdb .
      ln -s ../../energies .
      ln -s ../../energies step3_out.pdb
      cp ../../submit.sh .
    cd ../
  done
echo "Relinkage over."
ls -lstr
##cd ../
