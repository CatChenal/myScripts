#!/bin/bash
# Input1 = single column file of values to be converted into concatenated argument for egrep
# Input2 = name of output file
# Output: val1|val2|val3|....
# Call: getsmallstep2fromconflist.sh s2-6A-CLB466.conf s2-6A-CLB466.pdb
#To obtain a conf list:
# awk '{print $5}' s2-atms-within6A-CLB466.pdb|uniq> s2-6A-CLB466.conf;cat s2-6A-CLB466.conf
#
oneline=""
for conf in `cat $1`
do
        oneline=$oneline$conf"|"
done
echo $oneline > egrepline.1
sed -i 's/|$//' egrepline.1

echo egrep "'"`cat egrepline.1`"'" step2_out.pdb > egrepline.cmd
. egrepline.cmd > $2

/bin/rm egrepline.*
