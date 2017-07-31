#!/bin/bash
# Outputs each added files as columns to the right of the first file data.
# Merge files from listing given filters
#
if [[ $# -eq 0 ]]; then
   dir="*/BKB"
   pre="A0148"
   post="_bkb_000.csv"
   out=tmp
else
   read -p "Enter a directory search string (e.g. */BKB): " dir
   read -p "Enter a filename prefix filter (e.g. A0148): " pre
   read -p "Enter a filename suffix filter (e.g. bkb_000.csv): " post
   read -p "Enter an output file name: " out
fi

ls -l $dir/$pre*$post| awk '{print $NF}' > files
# ls -l */BKB/A0148_*_bkb_000.csv| awk '{str=str" "$NF}END{print str}'
# APO_R0/BKB/A0148_042_bkb_000.csv APO_R1/BKB/A0148_050_bkb_000.csv DN_R0/BKB/A0148_017_bkb_000.csv EA_R0/BKB/A0148_001_bkb_000.csv EQ_R0/BKB/A0148_001_bkb_000.csv QD_R0/BKB/A0148_048_bkb_000.csv QE_R0/BKB/A0148_050_bkb_000.csv QE_R0_gold/BKB/A0148_126_bkb_000.csv QE_R1/BKB/A0148_044_bkb_000.csv WD_R0/BKB/A0148_025_bkb_000.csv WT3CL_R0_2/BKB/A0148_055_bkb_000.csv WT3CL_R0.2/BKB/A0148_072_bkb_000.csv WT3CL_R0/BKB/A0148_011_bkb_000.csv WT3CL_R1/BKB/A0148_089_bkb_000.csv WTnew_R0/BKB/A0148_047_bkb_000.csv WTnew_R1/BKB/A0148_083_bkb_000.csv WT_R0_gold/BKB/A0148_121_bkb_000.csv

 awk 'BEGIN{OFS="\t"}
      FNR < NR { exit; }
      {
         for ( i=ARGC-1; ARGV[i] != FILENAME; i--)
         {
             getline line < ARGV[i];
             split( line, fields);
             for ( j = 2; j <= NF; j++ )
             {
                $j += fields[j]" ";
             }
         }
         print
       }' files > $out


FILENAME == ARGV[1] { one[FNR]=$1 }
FILENAME == ARGV[2] { two[FNR]=$3 }
FILENAME == ARGV[3] { three[FNR]=$7 }
FILENAME == ARGV[4] { four[FNR]=$1 }

END {
    for (i=1; i<=length(one); i++) {
        print one[i], two[i], three[i], four[i]
    }
}
