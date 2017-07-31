#!/bin/bash
i=0

for fldr in `ls -l | grep '^d' | awk '{print $NF}'| grep -v 'err' | grep -v '^Script' |grep -v '^all-pK'|egrep 'R|NR'`
#for fldr in `ls -l | grep '^d' | awk '{print $NF}'| egrep '*apo*'`
#for fldr in `ls -l | grep '^d' | awk '{print $NF}'`
do

  let "i+=1"
  if [[ $fldr == *NR ]]; then
    echo $i    $fldr" : Not relaxed"
  else
     echo $i    $fldr" : Relaxed"
  fi
done
