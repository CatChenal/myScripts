#!/bin/bash
# 2012-Feb-2 to setup hbond subdirectories with files needed to run Xuyu hbond routines
# NEEDED:
# cp /home/xzhu/mcce2.5/param04/hb.tpl to your parameter directory(ies)
# Reset run.prm to run step4 only with 1 pH point & MONTE_RUNS set to 1 -> least # of ms generated
STEP1="  1 = setup subfolders & run mcce_ms"
STEP2="  2 = compute hb connections"
STEP3="  3 = output H-bond list (final step)"

if [ "$#" -eq "0" ]; then
  echo "Usage:  switch needed: 1, 2, 3:"
  echo $STEP1";"
  echo $STEP2";"
  echo $STEP3
  exit 0
else
  for fldr in `cat hbond-folder-list.csv`
  do
    cd $fldr

    if [ "$1" -eq "1" ]; then
      echo "Doing Step"$STEP1" in "$fldr

      mkdir hbond
      cd hbond
        # Link from parent folder:
        ln -s ../run.prm .
        ln -s ../step2_out.pdb .
        ln -s ../head3.lst .
        ln -s ../energies.opp .
        # Make local cp of step1 with new name:
        cp ../step1_out.pdb ms_gold
        #This mcce version will run step4 of MCCE and save the microstates
        /home/xzhu/mcce_version/test/mcce_ms/mcce > ms_run.log&
      cd ../

    elif [ "$1" -eq "2" ]; then
      cd hbond
      echo "Doing Step"$STEP2" in "$fldr
      # Get all the H-bond connections of all the conformers:
      /home/xzhu/bin/hb_3/hb > hb_run.log&
      cd ../

    elif [ "$1" -eq "3" ]; then
      cd hbond
      echo "Doing Step"$STEP3" in "$fldr
      # Output the H-bond connections of all the residues in file "hb.txt":
      /home/xzhu/bin/hb_3/hmatrix > mtrx_run.log&
      cd ../

    else
      echo "Wrong switch: must be 1, 2, or 3"
    fi

    cd ../
  done
fi
