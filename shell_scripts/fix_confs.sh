#!/bin/bash
# Cat Chenal @ Gunner Lab
# Rev: 2014-08-13
# Input1 = single column file of values to be converted into concatenated argument for egrep
# Output:  do_fix.cmd

Usage="Call example: fix_confs.sh conf.list"

if [ $# -eq 0 ]; then
   echo $Usage;
   exit 0;
fi

oneline="sed -i -e '/"
for conf in $(cat $1)
do
    oneline=$oneline$conf"|"
done
strARG=${oneline%|}"/{s/f 0/t 0/}' head3.lst"

echo $strARG > do_fix.cmd
