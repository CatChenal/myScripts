#!/bin/bash

basefile="cl000/sum_crg.out"

nawk -v baseF="$basefile" '
    BEGIN { while ( getline < "f1.txt" > 0 )
            {
              f1_counter++
              f1[f1_counter] = $1
            }
  }
  { 
    print $1, $2, f1[NR], $3 >> outfile
   } ' f2.txt
#.............................................................

  while read newinline
  do
    nawk -v newline="$newinline" -v col="$new" '
       BEGIN{ split(newline,cols) }
      {
       if ( ($3==cols[1])&&($4==cols[2])&&($5==cols[3]) ) {$(col)=cols[4]};
       { printf($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11) >> outfile };
      }' $F2
  done < $F1

#.............................................................

paste file{1,2} | awk '{for (i=1;i<=NF/2;i++) printf "%s ", ($i==$i+0)?$i-$(i+NF/2):$i; print  ""}'
