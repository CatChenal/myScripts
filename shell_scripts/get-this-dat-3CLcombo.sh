#!/bin/bash
if [[ $# -eq 0 ]]; then
  echo "File listing 3CLcombo folders to process needed, e.g.: sliceAB.lst"
  exit 0
fi
lstfile="$1"
subf="cl"

DO_THIS=0

for dir in $(cat $1)
do
  if [[ $DO_THIS -eq 1 ]]; then
    cd $dir
    for subf in $(ls -l | grep ^d | grep cl | awk '{print $NF}')
    do
      cd $subf
      if [[ ! -f fort.38.non0 ]]; then
        getnon0rows.sh fort.38
        /bin/mv -f fort.38.non0 fort.38
      fi
      if [[ ! -f respair.lst.non0 ]]; then
        getnon0rows.sh respair.lst 1
        /bin/mv -f respair.lst.non0 respair.lst
      fi
      if [[ ! -f step2_out.pdb ]];then
        ln -s ../step2_out.pdb .
      fi
      if [[ ! -f $dir"-"$subf"-pH4.5.PDB" ]]; then
        get-mostocc.sh 4.5 # => noCL-pH4.5.PDB
        mv $subf"-pH4.5.PDB" $dir"-"$subf"-pH4.5.PDB"
      fi
      cd ../
    done
    cd ../
  fi

  pkafile=$dir"-pka.csv"
  crgfile=$dir"-crg.csv"
  netfile=$dir"-net.csv"
  sedARG=" 's/${dir%R*}//' " # = start_with

  if [[ $DO_THIS -eq 1 ]]; then
    egrep 'A0113|A0148|A0202|A0203' $dir/$subf*/pK.out | sed -e 's/\/pK.out:/ /; s/>/ /; s/</ /; s/_//' |sort -k2 > "cA-"$pkafile
    egrep 'A0113|A0148|A0202|A0203' $dir/$subf*/sum_crg.out | sed -e 's/\/sum_crg.out:/ /; s/_//' |sort -k2 > "cA-"$crgfile
    egrep 'B0113|B0148|B0202|B0203' $dir/$subf*/pK.out | sed -e 's/\/pK.out:/ /; s/>/ /; s/</ /; s/_//' |sort -k2 > "cB-"$pkafile
    egrep 'B0113|B0148|B0202|B0203' $dir/$subf*/sum_crg.out | sed -e 's/\/sum_crg.out:/ /; s/_//' |sort -k2 > "cB-"$crgfile
    egrep 'Net' $dir/$subf*/sum_crg.out | sed 's/\/sum_crg.out:/ /' > $netfile
  fi

  DO_THIS=1
  if [[ $DO_THIS -eq 1 ]]; then

    egrep 'A0' $dir/$subf*/pK.out | sed -e 's/\/pK.out:/ /; s/>/ /; s/</ /; s/_ //; s/\// /' |sort -k1 -k2 -k3 | eval sed "$sedARG"  > $dir/"cA-"$pkafile
    egrep 'A0' $dir/$subf*/sum_crg.out | sed -e 's/\/sum_crg.out:/ /; s/_ //; s/\// /' |sort -k1 -k2 -k3 mp | eval sed "$sedARG" > $dir/"cA-"$crgfile

    egrep 'B0' $dir/$subf*/pK.out | sed -e 's/\/pK.out:/ /; s/>/ /; s/</ /; s/_ //; s/\// /' |sort -k1 -k2 -k3 | eval sed "$sedARG" > $dir/"cB-"$pkafile
    egrep 'B0' $dir/$subf*/sum_crg.out | sed -e 's/\/sum_crg.out:/ /; s/_ //; s/\// /' |sort -k1 -k2 -k3 | eval sed "$sedARG" > $dir/"cB-"$crgfile

  fi
done

