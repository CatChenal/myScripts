#!/bin/bash
# Input files assumed to be symmetric
# Field/col1=assumed to be descriptive: copied to output

F1=$1
F2=$2
fld=$3	# field/col to subtract
out=$4

nawk -v file1="$F2" -v col="$fld" 'BEGIN { OFS="\t"; 
                                           # load array with contents of file1:
                                           while ( getline < file1 > 0 )
                                                 {
                                                   f1_counter++
                                                   f1[f1_counter,1] = $1
                                                   f1[f1_counter,2] = $col
                                                 }
                                         }
                                   { diff=(f1[NR,2]-$col); { if (diff!=0) { print $1,$col,f1[NR,2],diff } } }
                                   END { print file1"\n","minus\n",FILENAME"\n" }' $F1 > $out


