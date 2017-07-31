#!/bin/bash

# Remove greater/lower than sign:
SED_ARG="-e '/ pH/d' -e 's/^_/0/' -e 's/\([0-9]\)_/\1/' -e 's/ >\([0-9].[0-9]\)/ \10/' -e 's/ <\([0-9].[0-9]\)/ \10/' pK.out"

egrep _ pK.out |eval sed "$SED_ARG"| sort -k1 > pK.out.csv

# ok when totE fixed:
#echo "TotE > 10:"
#awk '$NF>10 {print}' pK.out.csv
#echo "TotE < -10"
#awk '$NF<-10 {print}' pK.out.csv
