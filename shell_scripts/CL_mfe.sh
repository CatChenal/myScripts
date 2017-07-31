#!/bin/bash

col=8  # = pH4.5 in my range

if [[ $# -eq 1 ]]; then
  col=$1
fi

mfe++ _CL-1A0466_001 > CL466-1_A_mfe.csv
mfe++ _CL-1A0467_001 > CL467-1_A_mfe.csv
mfe++ _CL-1A0467_002 > CL467-2_A_mfe.csv
mfe++ _CL-1A0468_001 > CL468-1_A_mfe.csv
mfe++ _CL-1A0468_002 > CL468-2_A_mfe.csv

awk -v C="$col" 'BEGIN{OFS="\t"}  /CL/{print FILENAME,$1, $C}' *A_mfe.csv > CL_A_ph4.5_CL-mfe.csv
awk -v C="$col" 'BEGIN{OFS="\t"} /SUM/{print FILENAME,$1, $C}' *A_mfe.csv > CL_A_ph4.5_sum-mfe.csv

mfe++ _CL-1B0466_001 > CL466-1_B_mfe.csv
mfe++ _CL-1B0466_002 > CL466-2_B_mfe.csv
mfe++ _CL-1B0467_001 > CL467-1_B_mfe.csv
mfe++ _CL-1B0467_002 > CL467-2_B_mfe.csv
mfe++ _CL-1B0468_001 > CL468-1_B_mfe.csv

awk -v C="$col" 'BEGIN{OFS="\t"}  /CL/{print FILENAME,$1, $C}' *B_mfe.csv > CL_B_ph4.5_CL-mfe.csv
awk -v C="$col" 'BEGIN{OFS="\t"} /SUM/{print FILENAME,$1, $C}' *B_mfe.csv > CL_B_ph4.5_sum-mfe.csv


/bin/rm *.mfe
