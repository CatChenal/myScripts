#!/bin/bash
# Cat Chenal @ Gunner Lab
# Rev: 2011-03-31
# Input1 = single column file of values to be converted into concatenated argument for egrep
# Input2 = file to search with egrep statement
# Output: The egrep statement
# Call: get-egrepline-from-list.sh list.conf file-to-egrep
Usage="Call example: get-egrepline-from-list.sh conf.list [file eg: sum_crg.out]"

if [ $# -lt 1 ]; then
   echo $Usage;
   exit 0;
fi

oneline=""
for conf in `cat $1`
do
    oneline=$oneline$conf"|"
done
egrepARG="'"$(echo $oneline | sed 's/|$//')"'"

if [ $# -eq 2 ]; then
  echo "egrep "$egrepARG" $2 "> egrepline
else
  echo "egrep "$egrepARG > egrepline
fi
cat egrepline

/bin/rm egrepline*
