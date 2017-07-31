#!/bin/bash
if [[ $# -lt 2 ]]; then
  echo "Required arguments: 1: subfldr_start: string; 2 subfldr_end: string. Missing."
  echo "Call: get-subf-complete-step.sh clusterA 025e4"
  echo "Call: get-subf-complete-step.sh sliceA 025e4"
  exit 0
fi
subf_start=$1
subf_end=$2
#10
fldr_all=$subf_start"_all"
if [[ -f $fldr_all ]]; then
  /bin/rm $fldr_all
fi
/bin/rm $subf_start"_with"* 

ls | grep $subf_start |grep $subf_end > $fldr_all

# S1  .................................
S1yes=$subf_start"_with_S1"
S1no=$subf_start"_without_S1"

  ls -l $subf_start*/step1_out.pdb 2>&1 | awk '{print $NF}'|sed -e 's/directory//; s/\/step1_out.pdb//' > $S1yes
  if [[ -s $S1yes ]]; then
    sdiff $fldr_all $S1yes | grep '<' |awk '{print $1}'> $S1no
    if [[ ! -s $S1no ]]; then # no diff -> all done
#      /bin/rm $S1no
      echo $subf_start" | "$subf_end": All subfolders have completed S1."
      echo
    else
#      $fldr_all=$S1no
      echo "No S1 list:"
      cat $S1no
    fi
  else
    echo $subf_start" | "$subf_end": No subfolder has completed S1."
    exit 0
  fi

# S2  .................................
S2yes=$subf_start"_with_S2"
S2no=$subf_start"_without_S2"

  ls -l $subf_start*/step2_out.pdb 2>&1 |awk '{print $NF}'|sed -e 's/directory//; s/\/step2_out.pdb//' > $S2yes
  if [[ -s $S2yes ]]; then
    sdiff $fldr_all $S2yes | grep '<' |awk '{print $1}'> $S2no
    if [[ ! -s $S2no ]]; then
      echo $subf_start" | "$subf_end": All subfolders have completed S2."
      echo
    else
#      $fldr_all=$S2no
      echo "No S2 list:"
      cat $S2no
    fi
  else
    echo $subf_start" | "$subf_end": No subfolder has completed S2."
  fi

# S3  .................................
S3yes=$subf_start"_with_S3"
S3no=$subf_start"_without_S3"

  ls -l $subf_start*/head3.lst 2>&1|awk '{print $NF}'|sed -e 's/directory//; s/\/head3.lst//' > $S3yes
  if [[ -s $S3yes ]]; then
    sdiff $fldr_all $S3yes | grep '<' |awk '{print $1}'> $S3no
    if [[ ! -s $S3no ]]; then
      echo $subf_start" | "$subf_end": All subfolders have completed S3."
      echo
    else
 #     $fldr_all=$S3no
      echo "No S3 list:"
      cat $S3no
    fi
  else
    echo $subf_start" | "$subf_end": No subfolder has completed S3."
  fi

# S4  .................................
S4yes=$subf_start"_with_S4"
S4no=$subf_start"_without_S4"

  ls -l $subf_start*/pK.out 2>&1 | awk '{print $NF}'|sed -e 's/directory//; s/\/pK.out//' > $S4yes
  if [[ -s $S4yes ]]; then     #found
#20
    sdiff $fldr_all $S4yes | grep '<' |awk '{print $1}'> $S4no
    if [[ ! -s $S4no ]]; then
      echo $subf_start" | "$subf_end": All subfolders have completed S4."
      echo
    else
  #    $fldr_all=$S4no
      echo "No S4 list:"
      cat $S4no
    fi
  else
    echo $subf_start" | "$subf_end": No subfolder has completed S4."
  fi

 # /bin/rm $subf_start"_with_"*
