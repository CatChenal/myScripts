#!/bin/bash

if [[ $# -eq 0 ]]; then
  echo "File listing folders to process needed, e.g.: sliceAB.lst noCL*"
  exit 0
fi
lstfile="$1"
start_with=${lstfile%.*}

True=1

if [[ $# -eq 2 ]]; then
  subf="$2"

  if [[ $True -eq 1 ]]; then

    for dir in $(cat $1)
    do
      cd $dir
      for subf in $(echo $2)
      do
        cd $subf
#        echo $dir-$subf
        if [[ ! -f fort.38.non0 ]]; then
          getnon0rows.sh fort.38
        fi
        if [[ ! -f respair.lst.non0 ]]; then
          getnon0rows.sh respair.lst 1
        fi

        if [[ ! -f step2_out.pdb ]];then
          ln -s ../step2_out.pdb .
        fi
        get-mostocc.sh 3.5 4.5 # => noCL-pH4.5.PDB
        mv $subf"-pH3.5.PDB" $dir"-"$subf"-pH3.5.PDB"
        mv $subf"-pH4.5.PDB" $dir"-"$subf"-pH4.5.PDB"
        get-step2-dist-from-anchor.sh 0 0 0 'ctr' $dir"-"$subf"-pH4.5.PDB" 1
        cd ../
      do
      cd ../
    done
  fi

  pkafile=$start_with"-"$subf"-pka.csv"
  crgfile=$start_with"-"$subf"-crg.csv"
  netfile=$start_with"-"$subf"-net.csv"

  sed_ARG=" 's/\/"$subf"\/pK.out:/ /'"
  egrep 'A0202|A0203|A0113|A0148' $start_with*/$subf/pK.out | eval sed "$sedARG" > tmp
  run-egrepline-from-list.sh $lstfile tmp > $pkafile
  sed_ARG=" 's/\/"$subf"\/sum_crg.out:/ /'"
  egrep 'A0202|A0203|A0113|A0148' $start_with*/$subf/sum_crg.out | eval sed "$sedARG" > tmp
  run-egrepline-from-list.sh $lstfile tmp > $crgfile
  egrep 'Net' $start_with*/$subf/sum_crg.out | eval sed "$sedARG" > tmp
  run-egrepline-from-list.sh $lstfile tmp > $netfile

else
  True=0

  if [[ $True -eq 1 ]]; then
    CLsfile=${lstfile/%.lst/-CLs.csv}
    if [[ -f $CLsfile ]]; then
      /bin/rm $CLsfile
    fi
    touch $CLsfile
  fi
  True=1

  for dir in $(cat $1)
  do
    cd $dir
    if [[ $True -eq 1 ]]; then
      if [[ ! -f fort.38.non0 ]]; then
        getnon0rows.sh fort.38
      fi
      if [[ ! -f respair.lst.non0 ]]; then
        getnon0rows.sh respair.lst 1
      fi

      if [[ ! -f step2_out.pdb ]];then
        if [[ ! -f S2-MEM-new.pdb ]];then
          echo "No S2 pdb in "$dir
          continue
        else
          ln -s S2-MEM-new.pdb step2_out.pdb
       fi
      fi
      get-mostocc.sh 3.5 4.5 # => $dir-pH4.5.PDB
      get-step2-dist-from-anchor.sh 0 0 0 'ctr' $dir"-pH4.5.PDB" 1
    fi
  ###  grep CL-1 head3.lst|awk -v fldr="$dir" 'END{print fldr"\t",NR}'>> ../$CLsfile
    cd ../
  done

  True=0
  if [[ $True -eq 1 ]]; then
    pkafile=${lstfile/%.lst/-pka.csv}
    crgfile=${lstfile/%.lst/-crg.csv}
    netfile=${lstfile/%.lst/-net.csv}
    egrep '0202|0203|0113|0148' $start_with*/pK.out | sed 's/\pK.out:/ /' > tmp
    run-egrepline-from-list.sh $lstfile tmp > $pkafile
    egrep '0202|0203|0113|0148' $start_with*/sum_crg.out | sed 's/\sum_crg.out:/ /' > tmp
    run-egrepline-from-list.sh $lstfile tmp > $crgfile
    egrep 'Net' $start_with*/sum_crg.out | sed 's/\sum_crg.out:/ /' > tmp
    run-egrepline-from-list.sh $lstfile tmp > $netfile
  fi
fi

/bin/rm tmp
