#!/bin/bash
# ARG1=start of folders to process
# ARG2=res id e.g. A0148
if [[ $# -ne 4 ]]; then
   echo " Arg missing: 1) outfile id (start of name); 2) startname of folders to process; 3) res_id (B0100); 4) pH"
   exit 0
fi
outID=$1
fldr_start=$2
res=$3
ph=$4

if [[ ! -f fort.38.hdr ]]; then
  echo " Need to save fort.38 header into fort.38.hdr in the current folder."
  exit 0
fi

awkscript='{ for(n=2;n<=NF;n++) {if ( $n == col ) print n} }'
Col=$(nawk -v col="$ph" "$awkscript" "fort.38.hdr")

OUT=$outID"-"$ph"-occ-"$res"-most.csv"

/bin/rm -f $OUT
touch $OUT

for dir in $(ls |grep ^$fldr_start)
do
  cd $dir
  getnon0rows.sh fort.38
  confs=$(grep $res fort.38| awk 'END{printf("%03d",NR)}')
  grep $res fort.38.non0| awk -v col=$Col '{print $1, $(col)}' |grep -v 0.000 >  pass1

  tot=$(awk 'END{print NR}' pass1)
  sort -k2.1nr pass1 |head -1 > pass2
  echo $dir" "$(cat pass2) $tot $confs >> ../$OUT
  /bin/rm -f pass*
  cd ../
done
