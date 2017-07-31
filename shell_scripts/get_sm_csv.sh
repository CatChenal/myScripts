#!/bin/bash
# for pH4.5=col8

for infile in $(ls WTR1_n2_GLU*.mfe.nz.csv)
do
  basefile=${infile%%.*}
  echo $basefile

  awk '{if ( ($8>0.05)||($8<=-0.5)) {print $1, $8} }' $infile > $basefile".mfesm.csv"

done
