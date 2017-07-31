#!/bin/bash
# Cat Chenal @ Gunner lab - 2013-06-17
if [ $# -lt 1 ]; then
  echo "Startname of folders to process expected. Exiting"
  exit 0
fi
start_with=$1

for fldr in $(ls |grep $start_with)
do
  if [ ! -d "$fldr" ]; then
    continue
  fi

  cd $fldr
    ##  /bin/rm -f run.prm step2_out.pdb energies* submit.sh
    ln -s ../run.prm .
    ln -s ../step2_out.pdb .
    ln -s ../energies.opp
    ln -s ../submit.sh .
    ln -s ../head3.lst .

    reset_h3_col.sh h3-file col_name col_value [res_name]
  cd ../
done

echo "TO DO NEXT: run reset-h3-Cl-comp-runs.cmd"

