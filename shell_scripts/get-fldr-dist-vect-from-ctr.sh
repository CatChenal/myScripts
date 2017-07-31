#!/bin/bash
#
# Original purpose: to detect spatial changes of list of res in a series of pdbs
startwith="clusterAB-"
endwith="-dry.pdb"
this=$(basename $0)
echo $this" :: Processing files that start with "$startwith" and end with "$endwith": ok? [y/n]"
read reply
if [ "$reply" = "N" -o "$reply" = "n" ]; then
  exit 0
fi

for pdb in $( ls $startwith*$endwith )
do
  outFILE="dist_"${pdb/%.pdb/.csv}
  # Compute distance from (0,0,0):
#1       2   3     4   5  6      7       8        9       10    11         12
#ATOM    178    N  ARG A  17     -22.061 -15.228  28.007  0.00  0.00       P1
#ATOM    179  HT1  ARG A0017     -22.913 -14.625  28.134  0.00  0.00       P1
#1       2   3     4   5         6        7       8       9     10         11 

  nawk 'BEGIN{OFS="\t"; formatNF11="%5s%5s %5s    %8.2f\n";formatNF12="%5s%5s %1s %3d %8.2f\n" } \
        { if (NF==11) { dist=sqrt( $6^2 + $7^2 + $8^2 ) ; { printf( formatNF11, $3,$4,$5,dist) }} \
          else        { dist=sqrt( $7^2 + $8^2 + $9^2 ) ; { printf(formatNF12, $3,$4,$5,$6,dist) }}  }' $pdb > $outFILE
echo $outFILE" done"
done
