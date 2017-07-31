#!/bin/bash
if [[ $# -lt 2 ]]; then
  echo "Required: Residue_id pH [subfolder]"
  exit 0
fi
if [[ $# -gt 3 ]]; then
  echo "Three arguments at most: Required: Residue id [subfolder]; Others ignored"
fi

here=$(pwd)
fldr=$(basename "$here")
echo $here

pH=$2

occ_cutoff=0.100

awkscript='{ for(n=2;n<=NF;n++) {if ( $n == col ) print n} }'
file="fort.38"

if [[ -f $file".non0" ]]; then
  file=$file".non0"
fi

if [[ $# -eq 2 ]]; then

  col_num=$(head -1 $file |sed 's/ ph/ph /' | awk -v col="$pH" "$awkscript")
  awk -v lim="$occ_cutoff" -v col="$col_num" -v res="$1" 'NR==1 {print lim"_cutoff_at_pH", $col};$1 ~ res {if ($col>lim){print $1, $col} }' $file |sort -k2r

else
  if [[ ! -d $3 ]]; then
    echo "Not a folder: "$2
  else

    echo $3
    col_num=$(head -1 $3/$file |sed 's/ ph/ph /' | awk -v col="$pH" "$awkscript")
    awk -v lim="$occ_cutoff" -v col="$col_num" -v res="$1" 'NR==1 {print lim"_cutoff_at_pH", $col};$1 ~ res {if ($col>lim){print $1, $col} }' $3/$file |sort -k2r
  fi
fi
