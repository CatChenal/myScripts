#!/bin/bash
# Cat Chenal @ Gunner Lab
# Rev: 2011-02-07
# Input1 = single column file of values to be converted into concatenated argument for egrep
# Input2 = file to search with egrep statement
# [Input3 = outputfilename]
# Output: Result of egrep using val1|val2|val3|....from input1
# Call: get-egrepline-from-list.sh list.conf file-to-egrep file-out
Usage="Call example: run-egrepline-from-list.sh conf.list sum_crg.out [sum_crg-res.out]"

if [ $# -lt 2 ]; then
   echo $Usage;
   exit 0;
fi

oneline=""
for conf in $(cat $1)
do
    oneline=$oneline$conf"|"
done
egrepARG="'"$(echo $oneline | sed 's/|$//')"'"
echo "egrep "$egrepARG" $2 "> egrepline.cmd

if [ $# -eq 3 ]; then
  . egrepline.cmd > $3
  # echo "Output (head): $3"
  # head $3
else
  . egrepline.cmd 
fi
/bin/rm egrepline.*

