#!/bin/bash
# To get favorable and unfavorable residues in mfe++ output
#
if [[ $# -lt 3 ]]; then
  echo "Required: dirID, cl_runID, resID (eg: 0148) [rerun_mfe (0/1): optional]"
  exit 0
fi

dirID=$1
cl_run=$2
resID=$3
rerun_mfe=1
if [[ $# -eq 4 ]]; then
  rerun_mfe=$4
fi

# Retrieve the 4 topmost occ'd conf for ionizable res:
# Reason for 4: if the neutral and ionized confs coexist, then there will be 2 lines per chains returned.
pre=$dirID"-"$cl_run
topfile=$pre"_"$resID"_top2mostocc.csv"

awk -v res="$resID" '$1 ~ res {if ($8>0.05){print "c"substr($1,6,1),$1,$8}}' fort.38|sort -k3nr -k1|head -4|sort > $topfile
# => output: chain conf occ

debug=0
if [[ $debug -ne 1 ]]; then
## mfe++ format for conf: SER_A0107_

for conf in $(awk '{print $2}' $topfile)
do
  if [[ $rerun_mfe -eq 1 ]]; then
    mfe++ $conf 1 1
    getnon0rows.sh $conf.mfe 3
  fi
#To DO get column for given pH
  awk '$8<0 {sum+=$8; print "c"substr($1,5,1),$1,$8}END{print "*** sum ",sum}' $conf.mfe.non0 > $pre"_"$conf"_fav-mfe.csv"

  egrep -v 'ph|SUM' $conf.mfe.non0|awk '$8>0 {sum+=$8; print "c"substr($1,5,1),$1,$8} END{print "*** sum ",sum}' > $pre"_"$conf"_unfav-mfe.csv"

done

fi
