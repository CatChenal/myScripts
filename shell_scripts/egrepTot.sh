#!/bin/bash
# to grep from given file and subtotal conformers in col1 
# => fort.38, sum_crg  format.
# ARG1=grep_regex; ARG2=file; [ ARG3=conf_id_col (if other format)]
#
#ARG01A0147_001
#1234567890_1234

if [[ $# -eq 0 ]]; then
   echo "ARG1=grep_regex; ARG2=file"
   exit 0
fi
col_id=1
if [[ $# -eq 3 ]]; then
  col_id=$3  # all subsequent columns sumed up by col1 id
fi
eval egrep $1 $2 > tmp
awk -v col="$col_id" 'BEGIN{ OFS="\t"; prev_conf=$col; prev_id=substr($col,1,10)}
                     { prev_conf=$col; prev_id=substr($col,1,10);
                       if ( substr($col,1,10) == prev_id )
                       {  for (c=(col+1); c<=NF; c++)
                          {  sum[c]+=$c }
                          print $0; prev_id=substr($col,1,10); prev_conf=$col
                       } else
                       {  prtline=sprintf("%14s", prev_conf);
                         for (c=(col+1); c<=NF; c++)
                         {   prtline=prtline"\t"sprintf("%6.2f", sum[c]); sum[c]=0 }
                       }
                    }' tmp > multi_occ.csv
