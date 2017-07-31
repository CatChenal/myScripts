#!/bin/bash
if [[ $# -ne 3 ]]; then
   echo $(basename $0)" arguments: DIR subFLD ID=xnnnn"
   exit 0
fi
DIR=$1
FLD=$2
ID=$3
do_crg=0

for dir in $(ls -l $DIR*/head3.lst|awk '{print substr($NF, 1, index($NF, "/h")-1)}')
do
   echo $dir
   cd $dir

      get_conf_E.sh $FLD $ID 0
      if [[ $do_crg -eq 1 ]]; then
         get_conf_E.sh $FLD $ID 1
      fi

   cd ../
done
echo "Over (fldrs_get_conf_E.sh)"

