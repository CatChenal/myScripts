#!/bin/bash
# Input1 = single column file of values to be converted into concatenated argument for egrep
# Input2 = name of output file
# Output: file of conformers from head3.lst to be used to call mfe++
#
# Call:  get-mfe-conf.sh list.conf conf-mfe.cmd
#
#  example: get-mfe-conf.sh res-5A-CLA466.conf res-5A-CLA466-mfe.cmd

oneline=""
conf=0

for conf in `cat $1`
do
    oneline=$oneline$conf"|"
done

echo $oneline | sed 's/|$//' > egrepline.1
#echo "# "`cat egrepline.1`;echo

conf=2
export conf

echo egrep "'"`cat egrepline.1`"'" head3.lst > egrepline.cmd
. egrepline.cmd | sed '/CLDM/d' > egrepline.1
awk -v fld=$conf '{print $fld}' egrepline.1 | sed 's/^/mfe++ /' > $2
echo "Output:  "
cat $2
echo "Do you want to mfe++ now? (Type y for yes or n for No)"
read answ
if [ "$answ" == "y" ] 
then
  . $2
fi

/bin/rm egrepline.*

