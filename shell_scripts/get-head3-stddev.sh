#!/bin/sh

head -1 head3.lst > h3.hdr

#To get h3.list of non dummy CL:
grep CL head3.lst |grep -v DM > nonDMCL-h3.lst

## head3-sumE.lst needs to be calculated from nonDMCL-h3.lst
# To sum the energy terms in head3.lst:

awk '{sum=0; for(n=10;n<NF;n++){sum+=$n};tot=(NF+1);$tot=sum; {print}}' nonDMCL-h3.lst > temp1.lst
cat h3.hdr temp1.lst> temp2.lst;cat temp2.lst| awk 'NR==1 {$(NF+1)="Sum_E"};{print}' > head3-sumE.lst; head head3-sumE.lst
/bin/rm temp*.lst;

# tot # of records:
recs=`awk 'END {print NR}' nonDMCL-h3.lst`
totE=`get-col-total.sh head3-sumE.lst 17`

aver=`expr $totE / $recs`
echo "recs:  "$recs
echo "totE:  "$totE
echo "aver:  "$aver

export aver recs
nawk -v av="$aver" -v N="$recs" 'NR >1 {sumsq=0; {sumsq+=($17-av)^2} print}}; END {dev=sqrt(sumsq/N); print "\t\t\t\t\t\t\t\"dev}' head3-sumE.lst > head3-stddev.lst

exit 0
#===== Example of export syntax used in get-col-total.sh  =====#
##  Export column number to environment, so it's available for retrieval.
#export column_number
#awkscript='{ total += $ENVIRON["column_number"] };END { print total }'
##  Now, run the awk script.
#awk "$awkscript" "$filename"
