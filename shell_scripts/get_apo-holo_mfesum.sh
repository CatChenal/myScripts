#!/bin/bash
apo="apo_mfe_sum.csv"
hol="holo_mfe_sum.csv"
fileID=".mfesm.csv"	# -> len=10
#files::
#_CL-1B0466_002.mfesm.csv
#GLU01A0148_005.mfesm.csv -> same length=24

here=$(pwd)
fldrID=$(basename $here)
#echo $fldrID

  awk '{ if (NR==1) {print "Conf", "SUM", $NF} else { if($1~/SUM/) { print substr(FILENAME,1,14), "SUM", $NF}} }' *$fileID > $fldrID"_"$apo
  awk '{ if (NR==1) {print "Conf", "SUM", $2 } else { if($1~/SUM/) { print substr(FILENAME,1,14), "SUM", $2 }} }' *$fileID > $fldrID"_"$hol

  egrep 'Conf|A0' $fldrID"_"$apo > $fldrID"_A_"$apo
  egrep 'Conf|A0' $fldrID"_"$hol > $fldrID"_A_"$hol

  egrep 'Conf|B0' $fldrID"_"$apo > $fldrID"_B_"$apo
  egrep 'Conf|B0' $fldrID"_"$hol > $fldrID"_B_"$hol

