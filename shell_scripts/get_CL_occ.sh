#!/bin/bash
if [[ $# -lt 2 ]] ;then
  echo Two inputs required: cA_mostocc cB_mostocc
  exit 0
fi

for conf in $(echo CL-1A0466 CL-1A0467 CL-1A0468)
do
echo $conf

  sumRows.sh $conf $1
  # outfile=$id_occ.csv
done

for conf in $(echo CL-1B0466 CL-1B0467 CL-1B0468)
do
echo $conf

  sumRows.sh $conf $2
  # outfile=$id_occ.csv
done

cat CL-1A*_occ.csv > cA_CL_occ.csv
cat CL-1B*_occ.csv > cB_CL_occ.csv

/bin/rm CL-1*_occ.csv
