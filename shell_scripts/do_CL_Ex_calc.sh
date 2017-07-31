#!/bin/bash

read -p "Use existing mfe files (in sm_mfe subfolder)? 1=yes, 0=no (redo mfe calc): " redo_mfe

for dir in $(ls -l | grep ^d|grep CL_|awk '{print $NF}')
do
   cd $dir
   if [[ $redo_mfe -eq 0 ]]; then
      if [[ -d sm_mfe ]]; then
         /bin/rm -r sm_mfe
      fi
   fi

   get_CL_energies.sh
   get_TotE.sh 0148 $redo_mfe

   cd ../

done

