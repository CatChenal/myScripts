#!/bin/bash
# to be called in the folder to process
if [[ $# -lt 1 ]]; then
  echo "Missing: folder_id [subset folder]"
  exit 0
fi
fldr=$1
if [[ $# -eq 2 ]]; then
  if [[ ! -d $2 ]]; then
    echo "Folder '" $subset "' not found"
    exit 0
  fi
  subset=$2
fi

if [[ $(grep 'GLU ' pK.out &> /dev/null) -eq 0 ]]; then # not amended
 amend_pKout.sh
fi

for cl_dir in $(echo cl*)
do
#  E148file=$fldr"-"$subset"-"$cl_dir"-E148_mfe2.csv"
#  E203file=$fldr"-"$subset"-"$cl_dir"-E203_mfe2.csv"
  get_combo_mfe2.sh $fldr $cl_dir $subset
done

