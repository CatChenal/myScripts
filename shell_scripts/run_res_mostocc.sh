#!/bin/bash
# to process chains A and B at once
#
if [[ $# -lt 4 ]]; then
   echo " ARG missing: 1) outfile id (start of name); 2) startname of folders to process; 3) res_seq (e.g. 100); 4) pH [; 5) combine_chain_data (1/0)"
   exit 0
fi
outID=$1
fldr_start=$2

res=$(echo $3|awk '{printf("%03d", $1)}')
echo $res
resA="A0"$res
resB="B0"$res
ph=$4

if [[ ! -f fort.38.hdr ]]; then
  echo " Need to save fort.38 header into fort.38.hdr in the current folder."
  exit 0
fi
outA=$outID"-"$ph"-occ-"$resA"-most.csv"
get_res_mostocc.sh $outID $fldr_start $resA $ph
outB=$outID"-"$ph"-occ-"$resB"-most.csv"
get_res_mostocc.sh $outID $fldr_start $resB $ph

if [[ $# -eq 5 ]]; then
  if [[ $5 -eq 1 ]]; then
    #  combine chains data:
    out=$outID"-"$ph"-occ-"$res"-most.csv"
    cat $outA $outB > $out
    /bin/rm $outA $outB
  fi
fi
