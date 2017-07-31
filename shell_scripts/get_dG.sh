#!/bin/bash

PK2KCAL=1.364
#SEQ=$1
#RESID=$2
#res=${RESID:0:3}

SEQ="0148"
RESID="GLU-1"
res=${RESID:0:3}

for ch in $(echo 'A')
do
    RESid=$ch$SEQ       # A0148
    Neu=$res'0.'$RESid  # GLU0.A0148
    Neg=$RESID$RESid    # GLU-1A0148

    # Calc dG=(negTOT - neuTOT)
      # ch_point      CONFORMER         vdw0    vdw1    epol   dsolv   h3Tot holo_mfe     TOT
      # neu_holo_min  GLU01A0148_001   0.28   1.32   0.96   2.50   5.06  -4.09   0.97

  for stat in $(echo 'holo apo')
  do
    neu_file=$RESid"_neu.h3."$stat".tot"
    neg_file=$RESid"_neg.h3."$stat".tot"

    nawk -v NegF="$neg_file" 'BEGIN { OFS="\t";
                                      # load array with contents of file1:
                                      while ( getline < NegF > 0 )
                                      { n = split(NegF, neg) }
                                    }
                                    { if (NF>1) { diff=($col-f1[NR,2]);
                                        { if (FILENAME ~ "respair") { print $1,$2,$col,f1[NR,2],diff }
                                          else { print $1,$col,f1[NR,2],diff }
                                        }
                                      }
                                    }' $neu_file > $RESid"_"$stat".dG.csv"

# BEGIN { n = split("this is not stored linearly",temp)
#  for (i=1; i<=n; i++) print i, temp[i]
#  print ""
#  for (i in temp) print i, temp[i]
# }
