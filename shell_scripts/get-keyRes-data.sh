#!/bin/bash
start_with="clusterAB"

#start_with="sliceAB"
#start_with="MD-C0"

if [[ $# -eq 1 ]]; then
 start_with=$1
fi
# flag to get distance calcs and other ops:
doThis=1

read -p "Process subfolders starting with: "$start_with" (1/0)?" Reply
if [ $Reply ]; then

  for dir in $(ls -l | grep $start_with| grep ^d | awk '{print $NF}')
  do
    if [ ! -f $dir/fort.38 ]; then
      echo $dir": Missing fort.38"
      continue
    fi

    cd $dir

    if [ $doThis ]; then
      getnon0rows.sh fort.38
      if [[ -f fort.38.non0 ]]; then
        mv fort.38.non0 fort.38
      fi
      getnon0rows.sh respair.lst 1
      if [[ -f respair.lst.non0 ]]; then
        mv respair.lst.non0 respair.lst
      fi
      awk '$1 ~/A0113/ {print}; $1 ~/A0148/ {print};$1 ~/A0202/ {print};$1 ~/A0203/ {print}' respair.lst |sed 's/_/ /g' >keyResA-respair.lst
      get-mostocc.sh 3.5 4.5
      if [[ -f $dir-pH4.5.PDB ]]; then
        get-step2-dist-from-anchor.sh 0 0 0 'ctr' $dir-pH4.5.PDB 1
      fi
    fi

    get-dimer-Net.sh

    cd ../
  done
  egrep 'A0113|A0148|A0202|A0203' $start_with*/keyResA-respair.lst | sed 's/\/keyResA-respair.lst:/ /' > $start_with"-keyResA-respair.csv"
  egrep 'A0113|A0148|A0202|A0203' $start_with*/pK.out | sed 's/\pK.out:/ /' > $start_with"-keyResA-pka.csv"
  egrep 'A0113|A0148|A0202|A0203' $start_with*/sum_crg.out | sed 's/\sum_crg.out:/ /' > $start_with"-keyResA-crg.csv"
  egrep Net $start_with*/*.out | sed -e 's/\sum_crg.out:/ /; s/\sumNetA.out:/ /; s/\sumNetB.out:/ /' |sort > $start_with"-Net.csv"

fi # reply ok
