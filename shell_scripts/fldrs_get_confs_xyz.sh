#!/bin/bash
if [[ $# -ne 3 ]]; then
   echo "DIr FLd ID (x000)"
   exit 0
fi
DIR=$1
FLD=$2
ID=$3           # A0148, B0148
neg="-1"$3"_"
neu="0."$3"_"

h3=$DIR"/"$FLD"/head3.lst"

fileout=$DIR"_"$FLD"_"$ID


awk 'BEGIN{OFS="\t"}/CG  ... A0148_/{print substr(FILENAME,1,index(FILENAME,"/s")-1),$5, $6, $7, $8 }' WD*/CL_f00_E01/step2_out.pdb
#[catalys@sibyl def-cl-comp4]> awk 'BEGIN{OFS="\t"}/CG  ... A0148_/{print substr(FILENAME,1,index(FILENAME,"/s")-1),$5, $6, $7, $8 }' WD*/CL_f00_E01/step2_out.pdb
#WD_R0/CL_f00_E01        A0148_001       1.517   5.264   -2.726
#WD_R0/CL_f00_E01        A0148_002       0.150   4.903   -0.286

awk '/SUM/{print substr(FILENAME, 1, index(FILENAME,".s")-1), $2}' WD*/CL_f00_E01/sm_mfe/*0*A0148*.sm_mfe.csv
#..............................
fldr=$1

for dir in $( ls -l */$fldr/head3.lst| awk '$NF !~/^x/{print substr($NF,1, index($NF,"/h")-1)}' )
do
   grep neutrals from head3[2] > neutrals

   for neutral in neutrals
   do
      grep neutral from step2 -> x, y, z"\t" > neu_data # _001 always included?
      grep neutral from head3[10-14]"\t" >> neu_data
      # get res_mfe
      awk '/SUM/{print $2}' WD*/CL_f00_E01/sm_mfe/*0*A0148*.sm_mfe.csv

#[catalys@sibyl def-cl-comp4]> awk '/SUM/{print substr(FILENAME, 1, index(FILENAME,".s")-1), $2}' WD*/CL_f00_E01/sm_mfe/*0*A0148*.sm_mfe.csv
#WD_R0/CL_f00_E01/sm_mfe/ASP01A0148_001 -4.3
#WD_R0/CL_f00_E01/sm_mfe/ASP01A0148_002 656.1


   done
done

