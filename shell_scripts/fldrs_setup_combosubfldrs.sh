#!/bin/bash

read -p "Reset run.prm & submit.sh files from bkb_s3 to MC_s4 step? yes:1, no:0 " DO_reset

# for dir in $( ls -l */head3.lst |grep -v APO| awk '{print substr($NF, 1, index($NF, "/")-1)}' )

for dir in $(ls -l */head3.lst | egrep -v 'EQ|EA' | awk '{print substr($NF, 1, index($NF, "/")-1)} '| egrep -v '^c|EQ[2-4]|^x')
do
   cd $dir
   echo $dir

   if [[ $DO_reset -eq 0 ]]; then
      /bin/rm run.prm submit.sh
      ln -s ../ch_run.prm run.prm
      ln -s ../submit.sh .
   fi

   if [[ "$dir" == EA* ]] || [[ "$dir" == EQ* ]]; then
       setup-combosubfldrs.sh 1
   else
       setup-combosubfldrs.sh 0
   fi
  cd ../

done
