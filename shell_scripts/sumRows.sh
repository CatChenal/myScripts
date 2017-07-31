#!/bin/bash
# NOTE: ASSUMES first column is descriptive (not totalled)
#       USES fort.38 by default, else given filename
#
E_WRONGARGS=85
if [ $# -lt 1 ]
then
   echo "Usage: $(basename $0) conf_identifier"
   exit $E_WRONGARGS
fi

id=$1
echo $id

filename="fort.38"
if [ $# -eq 2 ]; then
  filename=$2
elif [ -f fort.38.non0 ]; then
  filename="fort.38.non0"
fi
/bin/rm $id"_occ.csv"

awkARG='$1 ~ res { print; for (i=2; i<=NF; i++){sum[i]+=$i} } END{ prtLine=sprintf("%14s",res"_tot"); for (i=2; i<=NF; i++){prtLine=prtLine" "sprintf("%5.3f",sum[i])}; print prtLine }'
echo $awkARG
nawk -v res="$id" "$awkARG" $filename > $id"_occ.csv"
