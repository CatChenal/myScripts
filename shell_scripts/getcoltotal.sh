#!/bin/bash
E_WRONGARGS=85

if [ $# -lt 2 ]
then
   echo "Usage: `basename $0` filename column-number [header]"
   exit $E_WRONGARGS
fi

filename=$1
column_number=$2
export column_number

if [ $# -eq 3 ]
then 
# skip header
   awkscript='NR>1 {total+=$col_num } END { print total }'
else
   awkscript='{ total+=$col_num } END { print total }'
fi
awk -v col_num=$column_number "$awkscript" "$filename"

exit 0

