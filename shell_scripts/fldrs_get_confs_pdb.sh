#/bin/bash

for fldr in $( ls -l |grep ^d| awk '{print $NF}' |egrep '^1|^Q|^W')
do
  cd $fldr

  awk '{if ($2 != prev ) {print "egrep '047", substr($2,6,5)"_000|", substr($2,6,9), "\047 step2_out.pdb"; prev=$2} }' *-4.5-occ-148-most.csv > get_conf_pdb.cmd;
  . get_conf_pdb.cmd > WTR1_DN-E148-occ-conf.pdb; mcce2pdb.sh WTR1_DN-E148-occ-conf.pdb
  ##    => Converted pdb was saved as WTR1_DN-E148-occ-conf.PDB

  cd ../

done
