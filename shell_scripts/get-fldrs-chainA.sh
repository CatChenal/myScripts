#!/bin/bash

for fldr in $(ls -l | awk '/^d/ {print $NF}')
do
  cd $fldr
  echo $fldr

  dimer=$(ls -l | awk '/prot/ {print $NF}')		#WTab-R0000.pdb
  cA="cA_"$dimer
  grep ' A ' $dimer > $cA
  cd ../
done
echo $(basename $0) " over"

