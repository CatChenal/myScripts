#!/bin/bash

for dir in $(ls -l|awk '/^d/{print $NF}')
do
   if [[ -f $dir/sum_crg.out ]]; then
    cd $dir
      sed -i 's/\([A-Z]\) \([A|B]\)/\1_\2/' sum_crg.out
    cd ../
   else
       echo $dir ": no sum_crg.out"
   fi

done

sed -i 's/\([A-Z]\) \([A|B]\)/\1_\2/' CL_111/mfe_E-1/sum_crg.out
sed -i 's/\([A-Z]\) \([A|B]\)/\1_\2/' CL_111/mfe_E01/sum_crg.out
