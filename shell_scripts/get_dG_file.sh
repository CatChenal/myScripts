#!/bin/bash

#SEQ=$1
#RESID=$2
#res=${RESID:0:3}

SEQ="0148"
RESID="GLU-1"
res=${RESID:0:3}

for ch in $(echo 'A B')
do
    RESid=$ch$SEQ       # A0148
    Neu=$res'0.'$RESid  # GLU0.A0148
    Neg=$RESID$RESid    # GLU-1A0148

    # Calc dG=(negTOT - neuTOT)
      # ch_point      CONFORMER         vdw0    vdw1    epol   dsolv   h3Tot holo_mfe     TOT
      # neu_holo_min  GLU01A0148_001   0.28   1.32   0.96   2.50   5.06  -4.09   0.97

  for stat in $(echo 'holo apo')
  do
    neu_file=$RESid"_neu.h3."$stat".tot.csv"
    neg_file=$RESid"_neg.h3."$stat".tot.csv"
    sed -i '/CONF/d' $neu_file
    sed -i '/CONF/d' $neg_file

    nawk 'BEGIN{ OFS="\t" }
          { if (NR==1) { if ($NF>0) { print; exit } else { print } }
            else { if ($NF<0) {print} } }' $neg_file > $stat".neg"

    nawk 'BEGIN{ OFS="\t" }
          { if (NR==1) { if ($NF>0) { print; exit } else { print } }
            else { if ($NF<0) {print} } }' $neu_file > $stat".neu"

    cat  $stat".neg"  $stat".neu" > $RESid"_"$stat".csv"

##   /bin/rm $neg_file $neu_file $stat*

   done #stat
done #ch
