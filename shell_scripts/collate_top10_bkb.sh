#!/bin/bash
# collate in 1 file/chain
if  [[ $# -lt 2 ]]; then
  echo $(basename $0) " - Required: <4-digit residue number> <folder where most occ'd conf came from>"
  # [ <cutoff value> ]" files not symmetric with cutoff values
  exit 0
fi
RES=$1
if [[ ${#RES} -ne 4 ]]; then
  echo $(basename $0) " - Wrong input: 4-digit residue number needed."
  exit 0
fi
FLDR=$2

Res="A"$RES
out="all_"$Res"_top10_bkb.csv"

awk 'BEGIN{OFS="\t"}
     {printf "%s %s %s %5.2f\n", substr(FILENAME,1, index(FILENAME,"/")-1), substr($1,1,3), substr($1,5,5), $2}' */BKB/$Res"_"$FLDR"_top10_bkb.csv" > $out
sed -i '/_new/d; /1new/d' $out
sed -i "/EA_/d; s/gold/g/; s/_R/_/; s/WT3CL/WT'/; s/WTnew/WT'n/" $out

Res="B"$RES
out="all_"$Res"_top10_bkb.csv"
awk 'BEGIN{OFS="\t"}
     {printf "%s %s %s %5.2f\n", substr(FILENAME,1, index(FILENAME,"/")-1), substr($1,1,3), substr($1,5,5), $2}' */BKB/$Res"_"$FLDR"_top10_bkb.csv" > $out
sed -i '/_new/d; /1new/d' $out
sed -i "/EA_/d; s/gold/g/; s/_R/_/; s/WT3CL/WT'/; s/WTnew/WT'n/" $out

