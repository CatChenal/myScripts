#!/bin/bash

for dir in $(ls -l |gawk '/^d/{if (substr($NF,1,1)~/[A|D|E|Q|W]/) {print $NF} }')
do
  cd $dir
  echo $dir

  for fld in $(ls -l | gawk '/^d/{if (substr($NF,1,1)~/[C|Q|W]/) {print $NF} }')
  do
    if [[ -f $fld/sum_crg.out ]]; then

     cd $fld
       echo $fld
       sumcrg_chain_Net.sh
     cd ../

    fi
  done
  cd ../
done

# Get fixed runs Net crg:

egrep Net */QE_*/Net_sum_crg.csv > Fixedruns_Net.csv
egrep Net */WT_*/Net_sum_crg.csv >> Fixedruns_Net.csv

sed -i 's/\/Net_sum_crg.csv:/ /; s/\// /' Fixedruns_Net.csv
