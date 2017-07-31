#!/bin/bash
# By removing zero entries, file size reduced by ~75%

read -p "Do cleanup & reduce head3_extended? Enter number: yes(1), no(0) " do_cleanup

if [[ $do_cleanup -eq 1 ]]; then
   for fld in $( ls  *_*/head3_extended.lst |awk '{print substr($NF, 1, index($NF, "/")-1)}' )
   do
      cd $fld
         cleanH3ext.sh
      cd ../
   done
fi
