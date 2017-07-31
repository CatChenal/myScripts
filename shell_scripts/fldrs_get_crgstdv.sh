#!/bin/bash
# Returns rows with non 0 standard deviation

for fldr in $(ls -l */CL_*/sum_crg.out |awk ' {print substr($NF, 1, length($NF)-12)}'| egrep -v '_new|1new' | egrep 'CL_000|CL_f00|CL_0f0')
do
   if [[ -f $fldr/sum_crg.out ]]; then
      cd $fldr
         get_crgstdv.sh
      cd ../../
   else
      echo $fldr" sum_crg not found"
   fi
done

awk '($NF > 0.1)||($2 ~ 0148){print substr(FILENAME, 1, index(FILENAME, "/s")-1), $0}' */CL_*/sum_crg_rowstdv.csv|egrep 'CL_f00|CL_0f0' > crg_rowstdv_hi.csv
