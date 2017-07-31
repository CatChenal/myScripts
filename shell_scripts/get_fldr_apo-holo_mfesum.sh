#!/bin/bash

# In /def-cl-comp4/WT3CL_R000/ch_4.5/CL_free_ch_252ymc:
#[catalys@sibyl CL_free_ch_252ymc]> ls -l| awk '$1~/^d/{print $NF}'
#CL_f01_E01
#CL_f01_E-1
#CL_f01_Ef
#CL_f10
#CL_f11_E01
#CL_f11_E-1
#CL_f11_Ef :: len=9
#CL_fff

for fldr in $(ls -l| awk '$1~/^d/{print $NF}')
do
  if [[ ${#fldr} -gt 9 ]]; then
    cd $fldr
    get_apo-holo_mfesum.sh
    cd ../
  fi
done
