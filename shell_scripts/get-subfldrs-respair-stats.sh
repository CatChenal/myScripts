#!/bin/bash
#  Cat Chenal @ Gunner Lab - 2010-10-21
# To obtain basic stats from respair.lst for the given residue sequence identifyer [nnnn]
#
this="`basename $0`"; here=`pwd`; parent=`basename $here`

NEU="GLY ALA VAL ILE CYS MET PRO PHE TYR TRP"
POL="SER THR ASN GLN"
POS="HIS ARG LYS"
NEG="ASP GLU"
LIST="NEU POL POS NEG"
txtNEU="Hydrophobic/neutral:"
txtPOL="Polar uncharged:"
txtPOS="Positively charged:"
txtNEG="Negatively charged:"

if [ $# -lt 3 ]; then
    echo "* Missing argument(s): folders_to_process_start_of_name; subfolder_to_process; residue_sequence_identifyer [nnnn]. Exiting."
    exit 0
fi
start_with=$1
subfldr=$2
res=$3
outOK=$parent-$start_with-$subfldr-pwise$res-stats.csv
outNot=$parent-$start_with-$subfldr-pwise$res-notfound.csv
if [ -f $outOK ]; then
  /bin/rm $outOK
fi
if [ -f $outNot ]; then
  /bin/rm $outNot
fi
touch $outOK
touch $outNot

lstARG=" '^$start_with' "
for fldr in `ls -l | grep '^d' | awk '{print $NF}'| eval grep "$lstARG"`
do
  cd $fldr/$subfldr
  if [ ! -f "respair.lst.non0" ]; then
    echo "** File respair.lst.non0 not in $fldr" >> ../../$outNot
    cd ../../
    continue
  fi

  tot=0; pwe=0
  grepARG=" '$res' "
  eval grep "$grepARG" respair.lst.non0 > $res.tmp
  if [ ! -s "$res.tmp" ]; then
    /bin/rm $res.tmp
    echo "* "$res" not found in respair.lst.non0 of "$fldr >> ../../$outNot
    cd ../../
    continue
  fi

  echo "">> ../../$outOK
  echo "$parent - $fldr/$subfldr:" >> ../../$outOK
  echo "Interactions with $res:" >> $outOK

  # Get Min/Max for given id
  #  ARG+P0027_  GLUP0221_      -0.03   -2.52   -2.56   -1.00
  #  res1        re2            3       4       5
  awk 'NR == 1 {top=$5 ; bot=$5; t_res1=$1; t_res2=$2; b_res1=$1; b_res2=$2} \
  $5 >= top {top = $5; t_res1=$1; t_res2=$2} \
  $5 <= bot {bot = $5; b_res1=$1; b_res2=$2} \
  END {print " Max = "top": "t_res1" -> "t_res2"\n","Min = "bot": "b_res1" -> "b_res2}' $res.tmp >> ../../$outOK
  echo " ........................................"  >> ../../$outOK

  for grp in `echo -n "$LIST"`
  do
    if [[ $grp == "NEU" ]];then
      echo "	$txtNEU" >> ../../$outOK
      res2="$NEU"
    elif [[ $grp == "POL" ]];then
      echo "	$txtPOL" >> ../../$outOK
      res2="$POL"
    elif [[ $grp == "POS" ]];then
      echo "	$txtPOS" >> ../../$outOK
      res2="$POS"
    else
      echo "	$txtNEG" >> ../../$outOK
      res2="$NEG"
    fi

    for partner in `echo -n "$res2"`
    do
      cnt=0; nrg=0;
      awkARG=""; grepARG=""
      export partner
      awkARG='BEGIN{total=0};{if ( ( ($1 ~ id)&&($1 !~ ref) )||( ($2 ~ id)&&($2 !~ ref) ) ) {total+=$5}}; END {print total}'
      nrg=`nawk -v id="$partner" -v ref="$res" "$awkARG" "$res.tmp"`

      grepARG=" -c '$partner'"
      cnt=`eval grep "$grepARG" "$res.tmp"`
      if [ $cnt -ne 0 ]; then
        printf "\t%s\t%1.0f\t%1.2f\n" $partner $cnt $nrg >> ../../$outOK
      fi
      let tot+=$cnt
      pwe=$(echo "scale=2; $pwe + $nrg" | bc)
      unset partner
    done
    printf "\tTotal:\t%1.0f\t%1.2f\n" $tot $pwe >> ../../$outOK
    tot=0; pwe=0
  done
  cd ../../
done

if [ -s $outNot ]; then
  echo "Output file(s): "$outOK", ["$outNot"]:"
  cat $outOK
  echo
  cat $outNot
else
 /bin/rm $outNot
fi

