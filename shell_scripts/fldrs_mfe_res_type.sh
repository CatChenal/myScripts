#!/bin/bash

# res_str="ASP GLU HIS LYS TYR ARG" #: do all

for fldr in $(ls -l */CL_000/sum_crg.out|awk '! /R0_2|QE_|DN_|APO|EQ|pH|gld|e8|EA_R0|1new|_new/ { if($1 ~ /^l/) {print substr($(NF-2),1,index($(NF-2),"/"D)-1)} else { print substr($NF,1,index($NF,"/")-1)}}')
do
   cd $fldr
   echo $fldr
   for dir in $(echo 'CL_ff0 CL_f10 CL_f10_E01 CL_f10_E-1 CL_1f0 CL_1f0_E01 CL_1f0_E-1 CL_f00 CL_f00_E01 CL_f00_E-1 CL_0f0 CL_0f0_E01 CL_0f0_E-1')
   do
      if  [[ -f $dir/sum_crg.out ]]; then
         cd $dir

         echo $dir

         mfe_res_type.sh GLU

         cd ../
      else
          echo $dir "no sum_crg.out"
      fi

   done

   cd ../
done

