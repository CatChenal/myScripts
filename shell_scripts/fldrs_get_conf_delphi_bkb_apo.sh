#!/bin/bash
# Cat; 10-10-15
# For use to get bkb details from opp files when Delphi folder was saved.
# For the most occ conformers of given residue in a given folder(state), collates the bkb portion of vdw.
# When run for the first time, this proc will replace an unzipped energies folder with the delphi folder.
#
this=$(basename $0)

# [catalys@sibyl def-cl-comp4]> head  def4_000_Ex_occ.csv
# APO_R0 GLU-1A0148_042 1.000
# APO_R0 GLU-1B0148_049 1.000
# APO_R1 GLU-1A0148_050 1.000


for dir in $( ls -l | awk '/^d/{ L1=substr($NF,1,1); if ( L1 ~ /A|D|E|Q|W/ ) {print $NF} }' | egrep -v 'dn|Ex|_new|1new|new_R1' )
do

   for conf in $(echo $CONF_x)
   do
      get_conf_delphi_bkb.sh $conf $dir CL_000
   done

done
