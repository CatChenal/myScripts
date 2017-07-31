#!/bin/bash
do_overwrite=1
if [[ $# -eq 1 ]]; then
   filt=$1
   fld_list=$(ls -l */fort.38|awk -v lim="$filt" '$NF ~ lim {print substr($NF, 1,index($NF, "/")-1)}')
else
   fld_list=$(ls -l */fort.38|awk '{print substr($NF, 1,index($NF, "/")-1)}')
fi

for fld in $(echo $fld_list)
do
  echo $fld
  if [[ (! -f $fld/hi_stdv_confs.csv) || ($do_overwrite -eq 1) ]]; then
     cd $fld
     get_rowstdv.sh # uses fort.38
     cd ../
  fi
done
