#!/bin/bash

if [[ $# -ne 2 ]]; then
  echo "1:Start of folder name required for regex; 2:data set id for get_all_minconf-occ script"
  exit 0
fi
do_CL=1
do_Ex=1

do_other=0
do_combine=0

start=$1
FLDR=$2

for fld in $(ls -l|grep ^d|grep $start | awk '{print $NF}')
do
      if [ -f $fld/fort.38 ]; then
         cd $fld
         echo $fld

         if [ ! -f fort.38.non0 ]; then
            getnon0rows.sh fort.38 0.05
         fi
         if [[ $do_CL -eq 1 ]]; then
            get_CL_energies.sh
         fi
         if [[ $do_Ex -eq 1 ]]; then
            get_min_ch_TotE.sh 0148 GLU-1  # output: A0148_holo.csv
         fi
         if [[ $do_other -eq 1 ]]; then
            get_min_ch_TotE.sh 0445 TYR-1
            get_min_ch_TotE.sh 0107 SER-1
         fi
         if [ -f $fld"_CL-Ex-occ.csv" ]; then
            /bin/rm  $fld"_CL-Ex-occ.csv"
         fi
         egrep 'CL-1|GLU-1[A|B]0148' fort.38.non0 > $fld"_CL-Ex-occ.csv"

         cd ../
      fi
done

if [[ $do_combine -eq 1 ]]; then
echo Combining...
    for res in $(echo 'A0148 B0148')
    do
       nawk 'BEGIN { OFS="\t"; printf("%-12s%-14s%-14s%8s%8s%8s%8s%8s%9s%8s\n","Run","ch_point","CONFORMER","vdw0","vdw1","epol","dsolv","h3Tot" ,"apo_mfe", "TOT") } 
             { print FILENAME, $0 }' $start*/$res"_apo.csv" | sed 's/\// /' > tmp

       strSED=" 's/"$res"_apo.csv/ /' "
       eval sed $strSED tmp > $start"_"$res"_chE-apo.csv"; /bin/rm tmp
echo $start"_"$res"_chE-apo.csv" created

       nawk 'BEGIN { OFS="\t"; printf("%-12s%-14s%-14s%8s%8s%8s%8s%8s%9s%8s\n","Run","ch_point","CONFORMER","vdw0","vdw1","epol","dsolv","h3Tot", "holo_mfe", "TOT") }
             { print FILENAME, $0 }' $start*/$res"_holo.csv" | sed 's/\// /' > tmp
       strSED=" 's/"$res"_holo.csv/ /' "
       eval sed $strSED tmp > $start"_"$res"_chE-holo.csv"; /bin/rm tmp
echo $start"_"$res"_chE-holo.csv" created

    done
#grep A $start*"_chE-holo.csv"

#   grep CL_f0 CL_f_A*_chE-holo.csv > CL_f0x_A0148_chE-holo.csv
#   grep CL_f0 CL_f_B*_chE-holo.csv > CL_f0x_B0148_chE-holo.csv
#   grep CL_f0 CL_f_A*_chE-apo.csv > CL_f0x_A0148_chE-apo.csv
#   grep CL_f0 CL_f_B*_chE-apo.csv > CL_f0x_B0148_chE-apo.csv

#   grep CL_f1 CL_f_A*_chE-holo.csv > CL_f1x_A0148_chE-holo.csv
#   grep CL_f1 CL_f_B*_chE-holo.csv > CL_f1x_B0148_chE-holo.csv
#   grep CL_f1 CL_f_A*_chE-apo.csv > CL_f1x_A0148_chE-apo.csv
#   grep CL_f1 CL_f_B*_chE-apo.csv > CL_f1x_B0148_chE-apo.csv

#   grep CL_ff CL_f_A*_chE-holo.csv > CL_ffx_A0148_chE-holo.csv
#   grep CL_ff CL_f_B*_chE-holo.csv > CL_ffx_B0148_chE-holo.csv
#   grep CL_ff CL_f_A*_chE-apo.csv > CL_ffx_A0148_chE-apo.csv
#   grep CL_ff CL_f_B*_chE-apo.csv > CL_ffx_B0148_chE-apo.csv
fi

get_all_minconf-occ.sh $FLDR

echo "do_energies script over"
