#!/bin/bash

here=`pwd`
if [[ $# -eq 1 ]]; then
  fil=$1

#  echo "........ Linked "$fil" files in "`basename "$here"` "folders ........"
  for fldr in `ls -l | grep '^d' | awk '{print $NF}'`
  do
    cd $fldr
    echo $fldr
    # `grep '\-N' submit.sh`
    # . /home/catalys/cl-channels/runs/prep-respairlist.cmd
#    echo -e "\t"`ls -l | grep '^l' |awk '{print $(NF-2)"\t"$(NF-1)"\t"$NF}'|grep $fil`
    ls -l | grep '^l' |awk '{print $(NF-2)"\t"$(NF-1)"\t"$NF}'|grep $fil
    #    get-non0-rows.sh fort.38 0.1
    cd ../
  done
else
  echo "Type of file needed (pdb, sh,...)"
fi
