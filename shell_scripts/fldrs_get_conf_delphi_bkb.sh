#!/bin/bash
# Cat; 10-10-15
# For use to get bkb details from opp files when Delphi folder was saved.
# For the most occ conformers of given residue in a given folder(state), collates the bkb portion of vdw.
# When run for the first time, this proc will replace an unzipped energies folder with the delphi folder.
#
this=$(basename $0)
do_go=1
#read -p $this ":: Hard coded to get CL-bkb: ok to proceed? (0/1)" do_go

if [[ $do_go -eq 1 ]]; then

   CONF_x="_CL-1A0466_001 _CL-1B0466_001"
   CONF_c="_CL-1A0467_001 _CL-1B0467_001"

   for dir in $( ls -l | awk '/^d/{ L1=substr($NF,1,1); if ( L1 ~ /A|D|E|Q|W/ ) {print $NF} }' | egrep -v 'dn|Ex|_new|1new|new_R1' )
   do

      for conf in $(echo $CONF_x)
      do
         get_conf_delphi_bkb.sh $conf $dir CL_f00
         get_conf_delphi_bkb.sh $conf $dir CL_f00_E01
         get_conf_delphi_bkb.sh $conf $dir CL_f00_E-1
      done

      for conf in $(echo $CONF_c)
      do
         get_conf_delphi_bkb.sh $conf $dir CL_0f0
         get_conf_delphi_bkb.sh $conf $dir CL_0f0_E01
         get_conf_delphi_bkb.sh $conf $dir CL_0f0_E-1
      done

done

fi
