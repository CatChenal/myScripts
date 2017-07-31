#!/bin/bash
#i=0

for fldr in $(ls -l | grep '^d' | awk '{print $NF}')
do

#  let "i+=1"
#  if [[ $fldr == *NR ]]; then
#	continue
#     echo $fldr
#  else
#     echo $i    $fldr" : Relaxed"
#  fi

# check for core dump:
  if [ -f "$fldr/core" ]; then
    echo $fldr" : Core dump"
  else

    cd $fldr
    if [ -d "hbond" ]; then
      echo $fldr" :hbond fldr setup"
      if [ -f "hbond/hb.txt" ]; then
        echo $fldr"/hbond/hb.txt"
        # prep-respairlist.cmd
      fi
    fi
    for out in $(echo "step1_out.pdb step2_out.pdb head3.lst")
    do
      if [ ! -f "$out" ]; then
        echo $fldr" : "$out" missing"
      fi
    done
    if [ -f "fort.38" ]; then
      if [ -f "pK.out" ]; then
        echo $fldr" : S4 completed"
        if [ ! -f "fort.38.non0" ]; then
          getnon0rows.sh fort.38 0.005
        fi
        if [ ! -f "respair.lst.non0" ]; then
          getnon0rows.sh respair.lst 0.5
          /bin/rm respair.lst
        fi
      else
        echo $fldr" : pK.out missing"
      fi
    else
      echo $fldr" : fort.38 missing"
    fi

  cd ../
  fi # no crash
done

