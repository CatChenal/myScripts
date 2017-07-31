#!/bin/bash

for dir in $(ls -l |grep ^d| awk '{print $NF}'|egrep '^[1|Q|W]')
do
  if [[ -f $dir/step2_out.pdb ]]; then
    echo $dir":  "$(grep MEM $dir/step2_out.pdb |wc -l)
  else
    echo $dir":  No step2"
  fi
  if [[ -f $dir/R28L/step2_out.pdb ]]; then
    echo $dir"/R28L:  "$(grep MEM $dir/R28L/step2_out.pdb |wc -l)
  else
    echo $dir"/R28L: No step2"
  fi
done
