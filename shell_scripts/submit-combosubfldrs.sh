#!/bin/bash

if [[ $# -lt 1 ]]; then
  echo "Expected start of folder name to process. Exiting."
  exit 0
fi
start_with=$1
link_nrg_fldr=0

if [[ $# -eq 2 ]]; then
 link_nrg_fldr=$2
fi
# Parent unzipped energies folder must also exist as step3_out.pdb (via a link to energies):
# => to setup S4 for Yifan's MC; need fldr called step3_out.pdb/ with the opp files in it

for fldr in $(ls -l| grep ^d|grep $start_with |awk '{print $NF}')
do
  cd $fldr
  for subfldr in $(ls -l|grep ^d|grep cl |awk '{print $NF}')
  do
    cd $subfldr
    /bin/rm -f *log run.trace

      if [ $link_nrg_fldr -eq 1 ]; then
        /bin/rm -f energies.opp *bkp
#        if [ ! -d step3_out.pdb ]; then
          /bin/rm -fr step3_out.pdb
#        fi
        ln -s ../step3_out.pdb  .
      fi

      qsub submit.sh
    cd ../
  done
  cd ../
done
