#!/bin/bash
# To use when pdb from MD sim has the same chain ltr (non-null char)
#..................................
##original inpdb : chain letter assigned with Gromacs editconf: B
outpdb=$1
cl_tot=$2
# cl_tot = number of CL in chain A
# Recover chain A:  CLC 1OTS cA: res 17 to 460
# Get record number for last res of cA:
cA_end=$(awk '/B 460/{print NR}' $outpdb | tail -1)
echo "cA_end: "$cA_end
ro=$(awk 'END{ print NR}' $outpdb)
echo "rows: "$ro
CLa_start=$(echo "scale=0; $ro - (2*$cl_tot) + 1" | bc)
echo "CLa_start: "$CLa_start

awk -v eoA="$cA_end" -v clA="$CLa_start" -v CLs="$cl_tot" 'BEGIN{ prtPDB="%-6s%5d  %-3s %3s %c%4d    %8.3f%8.3f%8.3f%6.2f%6.2f\n"} \
                           { i=NR; \
                             for (i=NR; i<=eoA; i++) { $5="A"}; if(CLs==3) { if( (NR==clA)||(NR==(clA+1))||(NR==(clA+2)) ) { $5="A"} }; \
                             printf prtPDB,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11  \
                           }' $outpdb > tmp
# To correct protons alignment:
sed -i 's/  \([1-9]H[A-Z].\)/ \1/' tmp

/bin/rm $outpdb
mv tmp $outpdb

tail $outpdb

