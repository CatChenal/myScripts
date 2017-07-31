#!/bin/bash
# Add a field= aver of values in col2 to NF
# file needed

infile=$1

   awk 'BEGIN { OFS="\t" }
       $1 !~ /----------/{  for (i=2; i<=NF; i++) { sum += $i };
                            aver=sprintf("%5.2f",sum/(NF-1));
                            print $0, aver; sum=0;aver=0;
       }' $infile  > $infile"_av"

